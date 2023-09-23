port module Frontend exposing (app)

import ColorIndex
import Element
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Lamdera
import Types exposing (..)


port martinsstewart_set_favicon_to_js : String -> Cmd msg


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


init : ( FrontendModel, Cmd FrontendMsg )
init =
    ( { currentColor = Nothing, changeCount = Nothing }
    , Lamdera.sendToBackend ClientConnected
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        FNoop ->
            ( model, Cmd.none )

        UserPressColor colorIndex ->
            ( { model | currentColor = Just colorIndex }
            , Cmd.batch
                [ Lamdera.sendToBackend (ColorChosen colorIndex)
                , martinsstewart_set_favicon_to_js (ColorIndex.toColorFavicon colorIndex)
                ]
            )


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        UpdateColor colorIndex changeCount ->
            ( { model
                | currentColor = Just colorIndex
                , changeCount = Just changeCount
              }
            , martinsstewart_set_favicon_to_js (ColorIndex.toColorFavicon colorIndex)
            )


view : FrontendModel -> { title : String, body : List (Html FrontendMsg) }
view model =
    { title = "The best color is taking a break!"
    , body = [ Html.text "The best color is taking a break!" ]
    }



--case ( model.currentColor, model.changeCount ) of
--    ( Just color, Just changeCount ) ->
--        { title = "The best color is " ++ ColorIndex.toString color ++ "!"
--        , body =
--            [ Element.layout
--                []
--                (view_ changeCount color)
--            ]
--        }
--
--    _ ->
--        { title = ""
--        , body =
--            [ Element.layout
--                []
--                Element.none
--            ]
--        }


view_ : Int -> ColorIndex.ColorIndex -> Element.Element FrontendMsg
view_ changeCount color =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color (ColorIndex.toElColor color)
        , Element.text ("The best color has changed " ++ String.fromInt changeCount ++ " times.")
            |> Element.el [ Element.alignBottom, Element.alignRight, Element.padding 4 ]
            |> Element.inFront
        ]
        [ Element.el [ Element.width Element.fill, Element.height <| Element.fillPortion 5 ] <|
            Element.column
                [ Font.size 40, Element.centerX, Element.centerY ]
                [ Element.text <| "The best color is"
                , Element.el
                    [ ColorIndex.toHighlightColor color |> ColorIndex.colorToElColor |> Font.color
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
            [ Element.centerX, Element.above <| Element.el [ Font.size 30, Element.centerX ] <| Element.text "No! The best color is..." ]


colorButton colorInput =
    Input.button
        [ Element.width <| Element.px 80
        , Element.height <| Element.px 80
        , Background.color <| ColorIndex.toElColor colorInput
        ]
        { onPress = Just (UserPressColor colorInput), label = Element.none }
