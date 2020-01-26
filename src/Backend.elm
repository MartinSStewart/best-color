module Backend exposing (app, init)

import ColorIndex
import Lamdera exposing (ClientId, SessionId)
import Set exposing (Set)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { currentColor = ColorIndex.Blue, clients = Set.empty }, Cmd.none )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ clientId msg model =
    case msg of
        ClientConnect ->
            ( { model | clients = Set.insert clientId model.clients }
            , Lamdera.sendToFrontend clientId (UpdateColor model.currentColor)
            )

        ChooseColor colorIndex ->
            ( { model | currentColor = colorIndex }
            , broadcast (Set.remove clientId model.clients) (UpdateColor colorIndex)
            )


broadcast : Set ClientId -> ToFrontend -> Cmd BackendMsg
broadcast clients msg =
    clients
        |> Set.toList
        |> List.map (\clientId -> Lamdera.sendToFrontend clientId msg)
        |> Cmd.batch
