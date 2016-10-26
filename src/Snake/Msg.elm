module Snake.Msg exposing (..)

import Snake.Model.Geo exposing (..)
import Snake.Config exposing (maxPoint)

import Time exposing (Time)
import Random

type Msg
 = Tick Time
 | SetDirection Direction
 | Reseed Point
 | NoOp

newFood : Cmd Msg
newFood = Random.generate
  Reseed (Random.pair
    (Random.int 0 (fst maxPoint - 1))
    (Random.int 0 (snd maxPoint - 1)))
