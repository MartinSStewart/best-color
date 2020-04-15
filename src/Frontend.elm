module Frontend exposing (Model, app)

import Animator
import Animator.Inline
import Color exposing (Color)
import Color.Manipulate
import ColorIndex
import Element
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Lamdera
import Types exposing (..)


type alias Model =
    FrontendModel


{-| Lamdera applications define 'app' instead of 'main'.

Lamdera.frontend is the same as Browser.application with the
additional update function; updateFromBackend.

-}
app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


animator : Animator.Animator LoadedModel
animator =
    Animator.animator
        |> Animator.watching
            -- we tell the animator how
            -- to get the checked timeline using .checked
            .currentColor
            -- and we tell the animator how
            -- to update that timeline as well
            (\currentColor model_ ->
                { model_ | currentColor = currentColor }
            )


init : ( Model, Cmd FrontendMsg )
init =
    ( Loading, Lamdera.sendToBackend ClientConnect )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        FNoop ->
            ( model, Cmd.none )

        UserPressColor colorIndex ->
            case model of
                Loaded model_ ->
                    ( Loaded
                        { model_
                            | currentColor =
                                model_.currentColor
                                    |> Animator.go Animator.slowly colorIndex
                        }
                    , Lamdera.sendToBackend (ChooseColor colorIndex)
                    )

                Loading ->
                    ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        UpdateColor colorIndex changeCount ->
            case model of
                Loaded model_ ->
                    ( Loaded
                        { model_
                            | currentColor =
                                model_.currentColor
                                    |> Animator.go Animator.slowly colorIndex
                            , changeCount = changeCount
                        }
                    , Cmd.none
                    )

                Loading ->
                    ( Loaded { currentColor = Animator.init colorIndex, changeCount = changeCount }
                    , Cmd.none
                    )


view : Model -> { title : String, body : List (Html FrontendMsg) }
view model =
    case model of
        Loaded { currentColor, changeCount } ->
            { title =
                "The best color is "
                    ++ ColorIndex.toString (Animator.current currentColor)
                    ++ "!"
            , body =
                [ Element.layout
                    []
                    (view_ changeCount currentColor)
                ]
            }

        Loading ->
            { title = ""
            , body =
                [ Element.layout
                    []
                    Element.none
                ]
            }


view_ : Int -> Animator.Timeline ColorIndex.ColorIndex -> Element.Element FrontendMsg
view_ changeCount color =
    let
        animatedColor : Color
        animatedColor =
            Animator.Inline.backgroundColor color ColorIndex.toColor
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color (ColorIndex.colorToElColor animatedColor)
        , Element.text ("The best color has changed " ++ String.fromInt changeCount ++ " times.")
            |> Element.el [ Element.alignBottom, Element.alignRight, Element.padding 4 ]
            |> Element.inFront
        ]
        [ Element.el [ Element.width Element.fill, Element.height <| Element.fillPortion 5 ] <|
            Element.column
                [ Font.size 40, Element.centerX, Element.centerY ]
                [ Element.text <| "The best color is"
                , Element.el
                    [ animatedColor |> Color.Manipulate.lighten 0.1 |> ColorIndex.colorToElColor |> Font.color
                    , Font.shadow { offset = ( 0, 2 ), blur = 3, color = Element.rgba 0 0 0 0.5 }
                    , Font.size 80
                    , Element.centerX
                    ]
                    (Element.text (ColorIndex.toString (Animator.current color) ++ "!"))
                ]
        , Element.el
            [ Element.width Element.fill, Element.height <| Element.fillPortion 2 ]
            colorChoices
        ]


colorChoices =
    ColorIndex.allColors
        |> List.map colorButton
        |> Element.wrappedRow
            [ Element.centerX, Element.above <| Element.el [ Font.size 30, Element.centerX ] <| Element.text "No! The best color is..." ]


colorButton colorInput =
    Input.button
        [ Element.width <| Element.px 80
        , Element.height <| Element.px 80
        , Background.color <| ColorIndex.toElColor colorInput
        ]
        { onPress = Just (UserPressColor colorInput), label = Element.none }
