module Snake.Main exposing (main)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Keyboard exposing (..)

import Maybe exposing (..)
import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, (:::), fromElement)
import List exposing (..)
import Random

type alias Direction = (Int, Int)

right : Direction
right = (1, 0)

up : Direction
up = (0, 1)

left : Direction
left = (-1, 0)

down : Direction
down = (0, -1)

add : Point -> Direction -> Point
add (x, y) (dx, dy) = (x + dx, y + dy)

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
 = Tick
 | SetDirection Direction
 | Reseed Point
 | NoOp

maxPoint : Point
maxPoint = (16, 16)

initialModel : Model
initialModel =
  { status = Active
  , food = ( 0, 0 )
  -- , snake = (7, 8) ::: ((8, 8) ::: (fromElement (9, 8)))
  , snake = Nonempty.Nonempty ( 7, 8 ) [ ( 8, 8 ), ( 9, 8 ) ]
  , direction = right
  }

init : ( Model, Cmd Msg )
init = ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SetDirection direction -> ( { model | direction = direction }, Cmd.none )
      Reseed p -> ( { model | food = p }, Cmd.none )
      Tick -> tick model
      NoOp -> ( model, Cmd.none )

tick : Model -> ( Model, Cmd Msg )
tick model =
  let
    active = model.status == Active
    h = Nonempty.head model.snake
    tl = Nonempty.tail model.snake
    to = (add h model.direction)
    newTail = withDefault [] (tail (reverse tl))
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
  div
    []
    [ text (toString model) ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (\code -> case code of
      97 -> SetDirection left
      44 -> SetDirection up
      101 -> SetDirection right
      111 -> SetDirection down
      32 -> Tick
      _ -> NoOp)
