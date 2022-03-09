module Evergreen.V6.Types exposing (..)

import Evergreen.V6.ColorIndex
import Lamdera


type alias FrontendModel =
    { currentColor : Maybe Evergreen.V6.ColorIndex.ColorIndex
    , changeCount : Maybe Int
    }


type alias BackendModel =
    { currentColor : Evergreen.V6.ColorIndex.ColorIndex
    , changeCount : Int
    , lastChangedBy : Maybe Lamdera.SessionId
    }


type FrontendMsg
    = UserPressColor Evergreen.V6.ColorIndex.ColorIndex
    | FNoop


type ToBackend
    = ColorChosen Evergreen.V6.ColorIndex.ColorIndex
    | ClientConnected


type BackendMsg
    = Noop


type ToFrontend
    = UpdateColor Evergreen.V6.ColorIndex.ColorIndex Int
