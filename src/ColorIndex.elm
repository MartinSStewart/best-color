module ColorIndex exposing (ColorIndex(..), allColors, colorToElColor, toColor, toColorFavicon, toElColor, toHighlightColor, toString)

import Color exposing (Color)
import Color.Manipulate
import Element
import Image
import Image.Color


type ColorIndex
    = Red
    | Green
    | Blue
    | Orange
    | Brown
    | Purple
    | Pink
    | Yellow


toColor : ColorIndex -> Color
toColor colorIndex =
    case colorIndex of
        Red ->
            Color.red

        Green ->
            Color.green

        Blue ->
            Color.blue

        Orange ->
            Color.orange

        Brown ->
            Color.rgb255 110 71 0

        Purple ->
            Color.purple

        Pink ->
            Color.rgb 1 0.7 0.7

        Yellow ->
            Color.yellow


toHighlightColor : ColorIndex -> Color
toHighlightColor colorIndex =
    case colorIndex of
        Red ->
            Color.red |> Color.Manipulate.lighten 0.1

        Green ->
            Color.green |> Color.Manipulate.lighten 0.1

        Blue ->
            Color.blue |> Color.Manipulate.lighten 0.1

        Orange ->
            Color.orange |> Color.Manipulate.lighten 0.1

        Brown ->
            Color.rgb255 110 71 0 |> Color.Manipulate.lighten 0.1

        Purple ->
            Color.purple |> Color.Manipulate.lighten 0.1

        Pink ->
            Color.rgb 1 0.8 0.8

        Yellow ->
            Color.yellow |> Color.Manipulate.lighten 0.1


toElColor : ColorIndex -> Element.Color
toElColor =
    toColor >> colorToElColor


allColors : List ColorIndex
allColors =
    [ Red, Orange, Yellow, Green, Blue, Purple, Pink, Brown ]


colorFavicons : List ( ColorIndex, String )
colorFavicons =
    List.map
        (\index ->
            toColor index
                |> List.singleton
                |> List.singleton
                |> Image.Color.fromList2d
                |> Image.toPngUrl
                |> Tuple.pair index
        )
        allColors


toColorFavicon : ColorIndex -> String
toColorFavicon colorIndex =
    List.filterMap
        (\( index, value ) ->
            if index == colorIndex then
                Just value

            else
                Nothing
        )
        colorFavicons
        |> List.head
        |> Maybe.withDefault ""


toString : ColorIndex -> String
toString colorIndex =
    case colorIndex of
        Red ->
            "Red"

        Green ->
            "Green"

        Blue ->
            "Blue"

        Orange ->
            "Orange"

        Brown ->
            "Brown"

        Purple ->
            "Purple"

        Pink ->
            "Pink"

        Yellow ->
            "Yellow"


colorToElColor : Color -> Element.Color
colorToElColor color =
    let
        { red, green, blue, alpha } =
            Color.toRgba color
    in
    Element.rgba red green blue alpha
