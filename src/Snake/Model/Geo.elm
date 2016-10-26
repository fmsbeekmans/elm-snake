module Snake.Model.Geo exposing (..)

type alias Point = (Int, Int)

type Direction = Left | Up | Right | Down

move : Point -> Direction -> Point
move (x, y) d = case directionToDifference d of
  (dx, dy) -> (x + dx, y + dy)

directionToDifference : Direction -> Point
directionToDifference d = case d of
  Right -> (1, 0)
  Up -> (0, 1)
  Left -> (-1, 0)
  Down -> (0, -1)
