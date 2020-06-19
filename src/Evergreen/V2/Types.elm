module Evergreen.V2.Types exposing (..)

import Evergreen.V2.ColorIndex
import Lamdera
import Set


type alias FrontendModel =
    { currentColor : (Maybe Evergreen.V2.ColorIndex.ColorIndex)
    , changeCount : (Maybe Int)
    }


type alias BackendModel =
    { clients : (Set.Set Lamdera.ClientId)
    , currentColor : Evergreen.V2.ColorIndex.ColorIndex
    , changeCount : Int
    , lastChangedBy : (Maybe Lamdera.SessionId)
    }


type FrontendMsg
    = UserPressColor Evergreen.V2.ColorIndex.ColorIndex
    | FNoop


type ToBackend
    = ChooseColor Evergreen.V2.ColorIndex.ColorIndex
    | ClientConnect


type BackendMsg
    = Noop
    | ClientDisconnect Lamdera.SessionId Lamdera.ClientId


type ToFrontend
    = UpdateColor Evergreen.V2.ColorIndex.ColorIndex Int