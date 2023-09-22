module Backend exposing (app)

import ColorIndex
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)


app =
    Lamdera.backend
        { init = ( { currentColor = ColorIndex.Blue, changeCount = 0, lastChangedBy = Nothing }, Cmd.none )
        , update = \_ model -> ( model, Cmd.none )
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \_ -> Sub.none
        }


updateFromFrontend : SessionId -> ClientId -> ToBackend -> BackendModel -> ( BackendModel, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ClientConnected ->
            ( model
            , Lamdera.sendToFrontend clientId (UpdateColor model.currentColor model.changeCount)
            )

        ColorChosen chosenColor ->
            let
                changeCount =
                    if model.lastChangedBy == Just sessionId then
                        model.changeCount

                    else
                        model.changeCount + 1
            in
            ( { currentColor = chosenColor, lastChangedBy = Just sessionId, changeCount = changeCount }
            , Lamdera.broadcast (UpdateColor chosenColor changeCount)
            )
