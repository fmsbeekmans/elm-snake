module Snake.Model exposing (..)

import Snake.Model.Geo exposing (..)

import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, (:::), fromElement)

type alias Snake = Nonempty Point

type Status = Active | Paused | Lost | Won

type alias Model =
  { status : Status
  , food : Point
  , snake : Snake
  , direction : Direction
  }
