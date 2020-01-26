module Frontend exposing (Model, app)

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


init : ( Model, Cmd FrontendMsg )
init =
    ( { currentColor = Nothing }, Lamdera.sendToBackend ClientConnect )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        FNoop ->
            ( model, Cmd.none )

        UserPressColor colorIndex ->
            ( { model | currentColor = Just colorIndex }, Lamdera.sendToBackend (ChooseColor colorIndex) )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        UpdateColor colorIndex ->
            ( { model | currentColor = Just colorIndex }, Cmd.none )


view : Model -> { title : String, body : List (Html FrontendMsg) }
view model =
    case model.currentColor of
        Just color ->
            { title = "The best color is " ++ ColorIndex.toString color ++ "!"
            , body =
                [ Element.layout
                    []
                    (view_ model color)
                ]
            }

        Nothing ->
            { title = ""
            , body =
                [ Element.layout
                    []
                    Element.none
                ]
            }


view_ : Model -> ColorIndex.ColorIndex -> Element.Element FrontendMsg
view_ model color =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color (ColorIndex.toElColor color)
        ]
        [ Element.el [ Element.width Element.fill, Element.height <| Element.fillPortion 5 ] <|
            Element.column
                [ Font.size 40, Element.centerX, Element.centerY ]
                [ Element.text <| "The best color is"
                , Element.el
                    [ ColorIndex.toColor color |> Color.Manipulate.lighten 0.1 |> ColorIndex.colorToElColor |> Font.color
                    , Font.shadow { offset = ( 0, 2 ), blur = 3, color = Element.rgba 0 0 0 0.5 }
                    , Font.size 80
                    , Element.centerX
                    ]
                    (Element.text (ColorIndex.toString color ++ "!"))
                ]
        , Element.el
            [ Element.width Element.fill, Element.height <| Element.fillPortion 2 ]
            colorChoices
        ]


colorChoices =
    ColorIndex.allColors
        |> List.map colorButton
        |> Element.wrappedRow
            [ Element.centerX ]


colorButton colorInput =
    Input.button
        [ Element.width <| Element.px 80
        , Element.height <| Element.px 80
        , Background.color <| ColorIndex.toElColor colorInput
        ]
        { onPress = Just (UserPressColor colorInput), label = Element.none }
