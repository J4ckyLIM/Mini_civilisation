module Main exposing (..)

{-| This is a skeleton for an interpreter application. For now it basically simply display what you type in.
You should just:

  - insert your code in the update and the viewMap functions,
  - surely add some field in the Model type.

You can of course add other types,
functions and modules but you shouldn't have to modify the code at other places -- if you think you have to modify
this code, reach your teacher out before doing this.

-}

-- import Command exposing (Command(..))
-- import Parser exposing (Parser)

import Browser
import Browser.Dom
import Collage exposing (Collage)
import Collage.Render
import Collage.Text
import Command exposing (BuildingType(..), Direction(..))
import Debug exposing (toString)
import Element exposing (Element, centerX, centerY, column, el, fill, height, padding, px, row, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import Task


type alias Model =
    { commandInput : String
    , history : List String
    , turn : Int
    , maxTurn : Int
    , gold : Int
    , worker : Worker
    , buildings : List Building
    }


type Msg
    = CommandEntered String
    | CommandSubmitted
    | NoOp



-- type BuildingType
--     = GoldMine
--     | House


type alias Building =
    { id : Int
    , buildingType : BuildingType
    , position : Position
    }


type alias Position =
    { x : Int
    , y : Int
    }


type alias Worker =
    { id : Int
    , position : Position
    }



-- type Direction
--     = Left
--     | Right
--     | Up
--     | Down


worker : Worker
worker =
    { id = 0
    , position = { x = -5, y = -4 }
    }


init : Model
init =
    { commandInput = ""
    , history = []
    , turn = 0
    , maxTurn = 100
    , gold = 100
    , worker = worker
    , buildings = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        CommandEntered command ->
            { model | commandInput = command }

        CommandSubmitted ->
            handleCommand model

        NoOp ->
            model


grassTileUrl : String
grassTileUrl =
    "https://i.pinimg.com/474x/0b/61/12/0b611238fe328faa6ba30e89aab39e32--grass-texture-grasses.jpg"


houseTileUrl : String
houseTileUrl =
    "https://cdn.imgbin.com/8/7/18/imgbin-house-pixel-art-drawing-roof-house-9d4keKLkd2tHxxtyfjBNPwyqe.jpg"


goldMineTileUrl : String
goldMineTileUrl =
    "https://e7.pngegg.com/pngimages/634/456/png-clipart-gold-mine-gold-mining-coal-mining-mines-furniture-text.png"


workerTileUrl : String
workerTileUrl =
    "https://images.vexels.com/media/users/3/127494/isolated/lists/ab8d7f5047b1673c44f91fae53039bc6-construction-worker-cartoon.png"


view : Model -> Element Msg
view model =
    column [ width fill, height fill ]
        [ el [ width fill, height fill ]
            (el [ Border.width 2, padding 2, centerX, centerY, Background.tiled grassTileUrl ]
                (Element.html (Collage.Render.svgBox ( 1000, 800 ) (viewMap model)))
            )
        , row [ width fill, height (px 50) ]
            [ el [] (text "Your command: ")
            , Input.text
                [ onEnter CommandSubmitted
                , Element.htmlAttribute (Html.Attributes.id "prompt")
                , width fill
                ]
                { onChange = CommandEntered
                , text = model.commandInput
                , placeholder = Nothing
                , label = Input.labelHidden "Enter the command"
                }
            ]
        ]


{-| the cell size in pixels. Feel free to change it if you prefer bigger or smaller cells
-}
cellSize : Float
cellSize =
    100


viewMap : Model -> Collage Msg
viewMap model =
    -- TODO: change this function! Here are some examples to draw basic shapes.
    -- Feel free to define some helper functions!
    -- Note that unfortunately, the Color.Color and Element.Color types doesn't match.
    Collage.group
        (List.concat
            [ [ -- Display a worker with its identifier
                Collage.image ( cellSize / 2, cellSize / 2 ) workerTileUrl
                    |> Collage.shift ( toFloat model.worker.position.x * cellSize, toFloat model.worker.position.y * cellSize )
              , Collage.Text.fromString (toString model.worker.id)
                    |> Collage.rendered
                    |> Collage.shift ( toFloat model.worker.position.x * cellSize + cellSize / 4, toFloat model.worker.position.y * cellSize + cellSize / 4 )
              ]

            -- Display buildings
            , viewBuildings model.buildings
            ]
        )


viewBuildings : List Building -> List (Collage Msg)
viewBuildings buildings =
    List.concatMap (\building -> viewBuilding building building.buildingType) buildings


viewBuilding : Building -> BuildingType -> List (Collage Msg)
viewBuilding building buildingType =
    case buildingType of
        House ->
            [ Collage.image ( cellSize, cellSize ) houseTileUrl
                |> Collage.shift ( toFloat building.position.x * cellSize, toFloat building.position.y * cellSize )
            , Collage.Text.fromString (toString building.id)
                |> Collage.rendered
                |> Collage.shift ( toFloat building.position.x * cellSize + cellSize / 3, toFloat building.position.y * cellSize + cellSize / 3 )
            ]

        GoldMine ->
            [ Collage.image ( cellSize, cellSize ) goldMineTileUrl
                |> Collage.shift ( toFloat building.position.x * cellSize, toFloat building.position.y * cellSize )
            , Collage.Text.fromString (toString building.id)
                |> Collage.rendered
                |> Collage.shift ( toFloat building.position.x * cellSize + cellSize / 4, toFloat building.position.y * cellSize + cellSize / 4 )
            ]


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )



-- move : Worker -> Direction -> Worker
-- move character direction =


move : Worker -> String -> Worker
move character direction =
    case direction of
        "Left" ->
                { character | position = { x = character.position.x - 1, y = character.position.y } }
        "Right" ->
                { character | position = { x = character.position.x + 1, y = character.position.y } }
        "Up" ->
                { character | position = { x = character.position.x, y = character.position.y + 1 } }
        "Down" ->
                { character | position = { x = character.position.x, y = character.position.y - 1 } }
        _ ->
            character



-- build : Worker -> BuildingType -> Building
-- build character buildingType =


build : Model -> String -> List Building
build model buildingType =
    case buildingType of
        "GoldMine" ->
            model.buildings ++ [ { id = 5, buildingType = GoldMine, position = model.worker.position } ]

        "House" ->
            model.buildings ++ [ { id = 6, buildingType = House, position = model.worker.position } ]

        _ ->
            model.buildings


handleCommand : Model -> Model
handleCommand model =
    case String.split " " model.commandInput of
        [ "Move", direction ] ->
                { model | worker = move model.worker direction, commandInput = "", turn = model.turn + 1 }
        [ "Build", buildingType ] ->
                { model | buildings = build model buildingType, commandInput = "", turn = model.turn + 1, gold = model.gold - 30 } 
        _ ->
            model


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() ->
                ( init
                , Browser.Dom.focus "prompt"
                    |> Task.attempt (always NoOp)
                )
        , view =
            \model ->
                Element.layout
                    [ width fill
                    , height fill
                    ]
                    (view model)
        , update =
            \msg model ->
                ( update msg model
                , if msg == CommandSubmitted then
                    Browser.Dom.focus "prompt"
                        |> Task.attempt (always NoOp)

                  else
                    Cmd.none
                )
        , subscriptions = always Sub.none
        }
