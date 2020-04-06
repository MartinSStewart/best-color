module Frontend exposing (Model, app)

import Animator
import Animator.Inline
import Color exposing (Color)
import Color.Manipulate
import ColorIndex
import Element
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Lamdera
import Types exposing (..)


type alias Model =
    FrontendModel


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


init : ( Model, Cmd FrontendMsg )
init =
    ( Loading, Lamdera.sendToBackend ClientConnect )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    ( model, Cmd.none )


view : Model -> { title : String, body : List (Html FrontendMsg) }
view model =
    { title = "test", body = [] }
