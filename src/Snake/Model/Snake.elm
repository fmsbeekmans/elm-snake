module Snake.Model.Snake exposing (..)

import Snake.Model.Geo exposing (..)

import Snake.Msg exposing (..)

import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, (:::), reverse)

import Debug

type alias Snake = Nonempty Point

type alias Food = Point

snakeHead : Snake -> Point
snakeHead = Nonempty.head

body : Snake -> List Point
body = Nonempty.tail

moveSnake : Snake -> Direction -> Food -> (Snake, Bool, Cmd Msg)
moveSnake snake direction food =
  let
    to = direction
      |> move (snakeHead snake)
    newTailWithoudFood = snake
      |> reverse
      |> body
      |> List.reverse
  -- eat self
  in if List.member to newTailWithoudFood then
    ( snake, False, Cmd.none )
  -- eat food
  else if to == food then
    ( to ::: snake, True , newFood )
  -- step
  else
    ( Nonempty.Nonempty to newTailWithoudFood, True, Cmd.none )
