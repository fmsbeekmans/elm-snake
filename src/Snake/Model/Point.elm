module Snake.Model.Geo where

type Direction = Left | Up | Right | Down


type alias Point = (Int, Int)

add : Point -> Direction -> Point
add (x, y) d = case directionToDifference d of
  (dx, dy) -> (x + dx, y + dy)
