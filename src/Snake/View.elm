module Snake.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import List exposing (..)
import List.Nonempty exposing (toList)

import Snake.Model exposing (..)
import Snake.Model.Geo exposing (..)
import Snake.Model.Snake exposing (..)


tile : Point -> Int -> Html a -> Html a
tile p rot content =
  div
    [ style
      [ ("left", (toString (30 * (fst p))) ++ "px")
      , ("top", (toString (30 * (snd p))) ++ "px")
      , ("transform", "rotate(" ++ (toString rot) ++ "deg)")
      , ("position", "absolute")
      ]
    ]
    [ content ]



drawFood : Food -> Html a
drawFood p = tile p 0 (text "x")

drawSnake : Snake -> Direction -> List (Html a)
drawSnake (Snake h ds) d =
  let
    ds' = d :: ds
    ps = (Snake h ds)
      |> points
      |> toList

  in (map3 (\d p imageSource ->
    tile p (directionToRotation d) (img
    [ src imageSource
    , width 30
    , height 30 ] [])
    ) ds' ps (snakeParts (Snake h ds)))

snakeParts : Snake -> List String
snakeParts s = "/assets/head0.png" :: ((repeat ((count s) - 2) "/assets/body0.png") ++ ["/assets/tail0.png"])

directionToRotation : Direction -> Int
directionToRotation d = case d of
  Right -> 0
  Up -> 90
  Left -> 180
  Down -> 270
