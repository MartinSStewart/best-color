module Evergreen.Migrate.V2 exposing (..)

import Evergreen.Type.V1 as Old
import Evergreen.Type.V2 as New
import Lamdera
import Lamdera.Migrations exposing (..)


frontendModel : Old.FrontendModel -> ModelMigration New.FrontendModel New.FrontendMsg
frontendModel old =
    ModelMigrated
        ( { currentColor = old.currentColor
          , changeCount = Nothing
          }
        , New.ClientConnect |> Lamdera.sendToBackend
        )


backendModel : Old.BackendModel -> ModelMigration New.BackendModel New.BackendMsg
backendModel old =
    ModelMigrated
        ( { clients = old.clients
          , currentColor = old.currentColor
          , changeCount = 0
          , lastChangedBy = Nothing
          }
        , Cmd.none
        )


frontendMsg : Old.FrontendMsg -> MsgMigration New.FrontendMsg New.FrontendMsg
frontendMsg old =
    MsgUnchanged


toBackend : Old.ToBackend -> MsgMigration New.ToBackend New.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Old.BackendMsg -> MsgMigration New.BackendMsg New.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Old.ToFrontend -> MsgMigration New.ToFrontend New.FrontendMsg
toFrontend (Old.UpdateColor color) =
    MsgMigrated ( New.UpdateColor color 0, Cmd.none )
