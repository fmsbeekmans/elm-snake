module Snake.Model exposing (..)

import List.Nonempty as NeL exposing (Nonempty, (:::))

type Direction = Right | Up | Left | Down

type alias Point = (Int, Int)

type Snake = Snake (Nonempty Point) Bool

type Status = Active Int | Paused | Finished
