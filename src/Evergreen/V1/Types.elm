module Evergreen.V1.Types exposing (..)

import ColorIndex exposing (ColorIndex)
import Lamdera exposing (ClientId)
import Set exposing (Set)


type alias BackendModel =
    { clients : Set ClientId
    , currentColor : ColorIndex
    }


type alias FrontendModel =
    { currentColor : Maybe ColorIndex
    }


type FrontendMsg
    = UserPressColor ColorIndex
    | FNoop


type ToBackend
    = ChooseColor ColorIndex
    | ClientConnect


type BackendMsg
    = Noop


type ToFrontend
    = UpdateColor ColorIndex
