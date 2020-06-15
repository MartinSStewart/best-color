module Evergreen.V1.Types exposing (..)

import Evergreen.V1.ColorIndex as ColorIndex
import Lamdera
import Set


type alias FrontendModel =
    { currentColor : (Maybe ColorIndex.ColorIndex)
    , changeCount : (Maybe Int)
    }


type alias BackendModel =
    { clients : (Set.Set Lamdera.ClientId)
    , currentColor : ColorIndex.ColorIndex
    , changeCount : Int
    , lastChangedBy : (Maybe Lamdera.SessionId)
    }


type FrontendMsg
    = UserPressColor ColorIndex.ColorIndex
    | FNoop


type ToBackend
    = ChooseColor ColorIndex.ColorIndex
    | ClientConnect


type BackendMsg
    = Noop


type ToFrontend
    = UpdateColor ColorIndex.ColorIndex Int