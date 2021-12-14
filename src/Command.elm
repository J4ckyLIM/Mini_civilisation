-- module Command exposing (Command(..), buildBuilding, moveWorker, parse, Direction(..), BuildingType(..))

module Command exposing (Command(..), Direction(..), BuildingType(..))

-- import Parser exposing ((|.), (|=), Parser)
-- import Set
-- import Parser exposing (succeed)
-- import Parser exposing (symbol)
-- import Parser exposing (spaces)


type Command
    = Move Direction
    | Build BuildingType

type BuildingType
    = GoldMine
    | House

type Direction
    = Left
    | Right
    | Up
    | Down

-- moveWorker : Direction -> Command
-- moveWorker direction =
--     Move direction


-- buildBuilding : BuildingType -> Command
-- buildBuilding buildingType =
--     Build buildingType


-- parse : String -> Result (List Parser.DeadEnd) Command
-- parse string =
--     Parser.run (parser |. Parser.end) string


-- parser : Parser Command
-- parser =
--     Parser.oneOf
--         [ buildBuildingParser
--         , moveWorkerParser
--         ]

-- goldMine : Parser BuildingType
-- goldMine = succeed GoldMine
--     |. symbol "goldmine"
--     |. spaces

-- house : Parser BuildingType
-- house = succeed House 
--     |. symbol "house"
--     |. house
-- moveWorkerParser : Parser Command
-- moveWorkerParser =
--     Parser.succeed (\direction -> Move direction)
--         |. Parser.keyword "build"
--         |. Parser.spaces
--         |= Parser.variable { start = Char.isAlpha, inner = Char.isAlpha, reserved = Set.empty }


-- buildBuildingParser : Parser Command
-- buildBuildingParser =
--     -- TODO: write this parser! Run elm-test to ensure it works
--     Parser.succeed (\buildingType -> Build buildingType)
--         |. Parser.keyword "build"
--         |. Parser.spaces
--         |= Parser.variable { start = Char.isAlpha, inner = Char.isAlpha, reserved = Set.empty }
