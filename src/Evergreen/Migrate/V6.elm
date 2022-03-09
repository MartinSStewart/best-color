module Evergreen.Migrate.V6 exposing (..)

import Evergreen.V2.ColorIndex
import Evergreen.V2.Types as Old
import Evergreen.V6.ColorIndex
import Evergreen.V6.Types as New
import Lamdera.Migrations exposing (..)


migrateColorIndex color =
    case color of
        Evergreen.V2.ColorIndex.Green ->
            Evergreen.V6.ColorIndex.Green

        Evergreen.V2.ColorIndex.Red ->
            Evergreen.V6.ColorIndex.Red

        Evergreen.V2.ColorIndex.Blue ->
            Evergreen.V6.ColorIndex.Blue

        Evergreen.V2.ColorIndex.Orange ->
            Evergreen.V6.ColorIndex.Orange

        Evergreen.V2.ColorIndex.Brown ->
            Evergreen.V6.ColorIndex.Brown

        Evergreen.V2.ColorIndex.Purple ->
            Evergreen.V6.ColorIndex.Purple

        Evergreen.V2.ColorIndex.Pink ->
            Evergreen.V6.ColorIndex.Pink

        Evergreen.V2.ColorIndex.Yellow ->
            Evergreen.V6.ColorIndex.Yellow


frontendModel : Old.FrontendModel -> ModelMigration New.FrontendModel New.FrontendMsg
frontendModel old =
    ModelUnchanged


backendModel : Old.BackendModel -> ModelMigration New.BackendModel New.BackendMsg
backendModel old =
    ModelMigrated
        ( { currentColor = migrateColorIndex old.currentColor
          , changeCount = old.changeCount
          , lastChangedBy = old.lastChangedBy
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
toFrontend old =
    MsgUnchanged
