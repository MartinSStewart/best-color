module Types exposing (..)

import ColorIndex exposing (ColorIndex)
import Lamdera exposing (ClientId, SessionId)
import Set exposing (Set)


type alias BackendModel =
    { currentColor : ColorIndex
    , changeCount : Int
    , lastChangedBy : Maybe SessionId
    }


type alias FrontendModel =
    { currentColor : Maybe ColorIndex
    , changeCount : Maybe Int
    }


type FrontendMsg
    = UserPressColor ColorIndex
    | FNoop


type ToBackend
    = ColorChosen ColorIndex
    | ClientConnected


type BackendMsg
    = Noop


type ToFrontend
    = UpdateColor ColorIndex Int
