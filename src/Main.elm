module Main exposing (..)

{-| This is a skeleton for an interpreter application. For now it basically simply display what you type in.
You should just:

  - insert your code in the update and the viewMap functions,
  - surely add some field in the Model type.

You can of course add other types,
functions and modules but you shouldn't have to modify the code at other places -- if you think you have to modify
this code, reach your teacher out before doing this.

-}

import Browser
import Browser.Dom
import Collage exposing (Collage)
import Collage.Render
import Collage.Text
import Color
import Element exposing (Element, centerX, centerY, column, el, fill, focusStyle, height, padding, paddingEach, px, rgb, rgba, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import Task


type alias Model =
    { commandInput : String
    , history : List String
    }


type Msg
    = CommandEntered String
    | CommandSubmitted
    | NoOp


init : Model
init =
    { commandInput = ""
    , history = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        CommandEntered command ->
            { model | commandInput = command }

        CommandSubmitted ->
            -- TODO: Command parsing and applying goes here!!!
            { model | commandInput = "", history = model.history ++ [ model.commandInput ] }

        NoOp ->
            model


grassTileUrl : String
grassTileUrl =
    "https://i.pinimg.com/474x/0b/61/12/0b611238fe328faa6ba30e89aab39e32--grass-texture-grasses.jpg"


houseTileUrl : String
houseTileUrl =
    "https://lh3.googleusercontent.com/proxy/2Wr6rgQzX3MNJLZDkemAFKmOKzz2Mep8aS_AJRhYl2K32luc6WkmURB04wLNTPUKY3JGGwDeqOW5nNNp_8R-d7cEQg"


goldMineTileUrl : String
goldMineTileUrl =
    "https://lh3.googleusercontent.com/proxy/fhK_jHUof4nMDWATraR0GMcwB9BUHJSmFkbqwiLeXtgo6oqQMdJF6qKGl6tHBetEe2I4RNHcbfxByRm7m2OBSaxOLQ"


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
        [ -- Display a gold mine with its identifier
          Collage.image ( cellSize, cellSize ) goldMineTileUrl
            |> Collage.shift ( 2 * cellSize, 3 * cellSize )
        , Collage.Text.fromString "3"
            |> Collage.rendered
            |> Collage.shift ( 2 * cellSize + cellSize / 3, 3 * cellSize + cellSize / 3 )

        -- Display a worker with its identifier
        , Collage.image ( cellSize / 2, cellSize / 2 ) workerTileUrl
            |> Collage.shift ( -2 * cellSize, -3 * cellSize )
        , Collage.Text.fromString "1"
            |> Collage.rendered
            |> Collage.shift ( -2 * cellSize + cellSize / 4, -3 * cellSize + cellSize / 4 )

        -- Display house with its identifier
        , Collage.image ( cellSize, cellSize ) houseTileUrl
        , Collage.Text.fromString "2"
            |> Collage.rendered
            |> Collage.shift ( cellSize / 3, cellSize / 3 )

        -- You should have enough with the above examples, but if you need diving deeper in the `Collage` library
        -- here is the documentation link: https://package.elm-lang.org/packages/timjs/elm-collage/latest/
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
