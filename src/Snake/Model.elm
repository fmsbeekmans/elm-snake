module Snake.Model exposing (..)

import Snake.Model.Geo exposing (..)
import Snake.Model.Snake exposing (..)

import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty)

type Status = Active | Paused | Lost | Won

type alias Model =
  { status : Status
  , food : Food
  , snake : Snake
  , direction : Direction
  }

initialModel : Model
initialModel =
  { status = Active
  , food = ( 10, 10 )
  -- , snake = (7, 8) ::: ((8, 8) ::: (fromElement (9, 8)))
  , snake = Nonempty.Nonempty ( 7, 8 ) [ ( 8, 8 ), ( 9, 8 ) ]
  , direction = Up
  }
