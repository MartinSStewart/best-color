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
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { currentColor = ColorIndex.Blue
      , changeCount = 8330 -- This was the last change count before the app was reset.
      , lastChangedBy = Nothing
      , clients = Set.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        ClientDisconnect _ clientId_ ->
            ( { model | clients = Set.remove clientId_ model.clients }
            , Cmd.none
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ClientConnect ->
            ( { model | clients = Set.insert clientId model.clients }
            , Lamdera.sendToFrontend clientId (UpdateColor model.currentColor model.changeCount)
            )

        ChooseColor colorIndex ->
            let
                changeCount =
                    if model.lastChangedBy == Just sessionId then
                        model.changeCount

                    else
                        model.changeCount + 1
            in
            ( { model | currentColor = colorIndex, lastChangedBy = Just sessionId, changeCount = changeCount }
            , broadcast model.clients (UpdateColor colorIndex changeCount)
            )


broadcast : Set ClientId -> ToFrontend -> Cmd BackendMsg
broadcast clients msg =
    clients
        |> Set.toList
        |> List.map (\clientId -> Lamdera.sendToFrontend clientId msg)
        |> Cmd.batch


subscriptions : Model -> Sub BackendMsg
subscriptions _ =
    Lamdera.onDisconnect ClientDisconnect
