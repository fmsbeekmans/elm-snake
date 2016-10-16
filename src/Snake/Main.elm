module Snake.Main exposing (main)

import Html exposing (..)
import Html.App
import Keyboard exposing (..)

import List.Nonempty as NeL exposing (fromElement, Nonempty, (:::))

import Snake.Model exposing (..)

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

type Msg = Tick | SetDirection Direction | NoOp

maxPoint : Point
maxPoint = (16, 16)

initialModel : Model
initialModel =
  { status = Paused
  , food = (0, 0)
  , snake = Snake ((7, 8) ::: ((8, 8) ::: (fromElement (9, 8)))) False
  , direction = Right
  }

init : (Model, Cmd Msg)
init = ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SetDirection direction -> ( { model | direction = direction } , Cmd.none )
      Tick -> ( tick model, Cmd.none )

view : Model -> Html Msg
view model =
  div
    []
    [ text (toString model) ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (\code -> case code of
      97 -> SetDirection Left
      44 -> SetDirection Up
      101 -> SetDirection Right
      111 -> SetDirection Down
      32 -> Tick
      _ -> NoOp)
