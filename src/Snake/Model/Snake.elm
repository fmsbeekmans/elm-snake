module Snake.Model.Snake exposing (..)

import List exposing (tail, foldl, reverse, length)
import List.Nonempty as Nonempty
import List.Nonempty exposing (Nonempty, fromElement, (:::), toList)

import Maybe exposing (withDefault)

import Snake.Model.Geo exposing (..)

import Snake.Msg exposing (..)

import Debug


type Snake = Snake Point (List Direction)

type alias Food = Point

snakeHead : Snake -> Point
snakeHead (Snake h _) = h

directions : Snake -> List Direction
directions (Snake _ ds) = ds

points : Snake -> (Nonempty Point)
points (Snake h dirs) =
  Nonempty.reverse (foldl (\d ps ->
    let
      p = d
        |> opposite
        |> move (Nonempty.head ps)
      in p ::: ps
    ) (fromElement h) dirs)

dropLast : (List a) -> (List a)
dropLast xs = xs
  |> reverse
  |> tail
  |> withDefault []
  |> reverse

moveSnake : Snake -> Direction -> Food -> (Snake, Bool, Cmd Msg)
moveSnake snake direction food =
  let
    to = direction
      |> move (snakeHead snake)
    newTailPoints = snake
      |> points
      |> toList
      |> dropLast
  -- eat self
  in if List.member to newTailPoints then
    ( snake, False, Cmd.none )
  -- eat food
  else if to == food then
    ( Snake to  (direction :: (directions snake)) , True , newFood )
  -- step
  else
    ( Snake to (direction :: (dropLast (directions snake))), True, Cmd.none )

count : Snake -> Int
count (Snake _ ds) = 1 + length ds
