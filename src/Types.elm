module Types exposing (..)

import Lamdera exposing (ClientId)
import Set exposing (Set)


type alias BackendModel =
    { counter : Int
    , clients : Set ClientId
    }


type alias FrontendModel =
    { counter : Int
    , clientId : String
    }


type FrontendMsg
    = Increment
    | Decrement
    | FNoop


type ToBackend
    = ClientJoin
    | CounterIncremented
    | CounterDecremented


type BackendMsg
    = Noop


type ToFrontend
    = CounterNewValue Int String
