module Types exposing (..)

import Animator exposing (Animator)
import ColorIndex exposing (ColorIndex)
import Lamdera exposing (ClientId, SessionId)
import Set exposing (Set)


type alias BackendModel =
    { clients : Set ClientId
    , currentColor : ColorIndex
    , changeCount : Int
    , lastChangedBy : Maybe SessionId
    }


type FrontendModel
    = Loading
    | Loaded LoadedModel


type alias LoadedModel =
    { --Remove current color and lamdera live should work again
      currentColor : Animator.Timeline ColorIndex
    , changeCount : Int
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
    = UpdateColor ColorIndex Int
