module Snake.Model exposing (..)

import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, (:::), fromElement)

type Direction = Left | Up | Right | Down

type alias Point = (Int, Int)

type alias Snake = Nonempty Point

type Status = Active | Paused | Lost | Won

type alias Model =
  { status : Status
  , food : Point
  , snake : Snake
  , direction : Direction
  }
