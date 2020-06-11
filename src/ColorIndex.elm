module ColorIndex exposing (ColorIndex(..), allColors, colorToElColor, toColor, toElColor, toString)

import Color exposing (Color)
import Element


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
            Color.rgb255 110 71 44

        Purple ->
            Color.purple

        Pink ->
            Color.rgb 1 0.7 0.7

        Yellow ->
            Color.yellow


toElColor : ColorIndex -> Element.Color
toElColor =
    toColor >> colorToElColor


allColors : List ColorIndex
allColors =
    [ Red, Orange, Yellow, Green, Blue, Purple, Pink, Brown ]


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
