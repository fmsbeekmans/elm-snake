module Snake.Main exposing (main)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Keyboard exposing (..)
import Time exposing (Time, second)

import Maybe exposing (withDefault)
import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, (:::), fromElement)
import List exposing (..)
import Random

import Debug

import Json.Encode

type Direction = Left | Up | Right | Down

directionToDifference : Direction -> Point
directionToDifference d = case d of
  Right -> (1, 0)
  Up -> (0, 1)
  Left -> (-1, 0)
  Down -> (0, -1)

directionToRotation : Direction -> Int
directionToRotation d = case d of
  Right -> 0
  Up -> 270
  Left -> 180
  Down -> 90

add : Point -> Direction -> Point
add (x, y) d = case directionToDifference d of
  (dx, dy) -> (x + dx, y + dy)

type alias Point = (Int, Int)

type alias Snake = Nonempty Point

type Status = Active | Paused | Lost | Won


main : Program Never
main =
    Html.App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

type alias Model =
  { status : Status
  , food : Point
  , snake : Snake
  , direction : Direction
  }

type Msg
 = Tick Time
 | SetDirection Direction
 | Reseed Point
 | NoOp

maxPoint : Point
maxPoint = (16, 16)

initialModel : Model
initialModel =
  { status = Active
  , food = ( 10, 10 )
  -- , snake = (7, 8) ::: ((8, 8) ::: (fromElement (9, 8)))
  , snake = Nonempty.Nonempty ( 7, 8 ) [ ( 8, 8 ), ( 9, 8 ) ]
  , direction = Up
  }

init : ( Model, Cmd Msg )
init = ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SetDirection direction -> ( { model | direction = direction }, Cmd.none )
      Reseed p -> ( { model | food = p }, Cmd.none )
      Tick _ -> tick model
      NoOp -> ( model, Cmd.none )

tick : Model -> ( Model, Cmd Msg )
tick model =
  let
    active = model.status == Active
    h = Nonempty.head model.snake
    tl = Nonempty.tail model.snake
    to = (add h model.direction)
    newTail = reverse (withDefault [] (tail (reverse tl)))
  in if (active && (to == model.food)) then -- eat!
    ( { model | snake = Nonempty.Nonempty to ( h :: tl ) }, newFood )
  else if member to tl then -- eat self
    ( { model | status = Lost}, Cmd.none )
  -- else if wall
  else
    ( { model | snake = Nonempty.Nonempty to ( h :: newTail ) }, Cmd.none )

newFood : Cmd Msg
newFood = Random.generate
  Reseed (Random.pair
    (Random.int 0 (fst maxPoint - 1))
    (Random.int 0 (snd maxPoint - 1)))

view : Model -> Html Msg
view model =
  Debug.log (toString model)
  div
    []
    (tiles model)

tiles : Model -> List (Html a)
tiles model =
  [ tile model.food (text "x")
  ] ++ (map (\p -> tile p (text "-")) (Nonempty.toList model.snake))

tile : Point -> Html a -> Html a
tile p content =
  div
    [ style
      [ ("left", (toString (30 * (fst p))) ++ "px")
      , ("top", (toString (30 * (snd p))) ++ "px")
--       , ("transform", "rotate(20deg)")
      , ("position", "absolute")
      ]
    ]
    [ content ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Time.every second Tick,
    Keyboard.presses (\code -> case code of
      97 -> SetDirection Left
      44 -> SetDirection Down
      101 -> SetDirection Right
      111 -> SetDirection Up
      _ -> NoOp)
  ]
