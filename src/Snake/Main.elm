module Snake.Main exposing (main)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Maybe exposing (withDefault)
import List exposing (..)
import List.Nonempty exposing (toList)

import Time exposing (Time, second)
import Keyboard exposing (..)

import Snake.Model exposing (..)
import Snake.Model.Geo exposing (..)
import Snake.Model.Snake exposing (..)

import Snake.Msg exposing (..)

import Debug exposing (log)

import Json.Encode

directionToRotation : Direction -> Int
directionToRotation d = case d of
  Right -> 0
  Up -> 270
  Left -> 180
  Down -> 90

main : Program Never
main =
    Html.App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

init : ( Model, Cmd Msg )
init = ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      SetPause p ->
        case ( p, model.status ) of
          ( True, Active ) -> ( { model | status = Paused}, Cmd.none )
          ( False, Paused ) -> ( { model | status = Active}, Cmd.none )
          _ -> ( model, Cmd.none )
      SetDirection direction ->
        if direction /= opposite model.direction then
          ( { model | direction = direction }, Cmd.none )
        else
          ( model, Cmd.none )
      Reseed p -> ( { model | food = p }, Cmd.none )
      Tick _ ->
        if model.status == Active then
          case moveSnake model.snake model.direction model.food of
            ( _, False, _ ) -> ( { model | status = Lost }, Cmd.none )
            ( snake, True, cmd ) -> ( { model | snake = snake}, cmd )
        else
          ( model, Cmd.none )
      NoOp -> ( model, Cmd.none )

view : Model -> Html Msg
view model =
  div
    []
    (tiles model)

tiles : Model -> List (Html a)
tiles model =
  [ tile model.food (text "x")
  ] ++ (map (\p -> tile p (text "^")) (toList (points model.snake)))

tile : Point -> Html a -> Html a
tile p content =
  div
    [ style
      [ ("left", (toString (30 * (fst p))) ++ "px")
      , ("top", (toString (30 * (snd p))) ++ "px")
--       , ("transform", "rotate(20deg)")
      , ("position", "absolute")
      ]
    ]
    [ content ]

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.status == Paused then
    Keyboard.presses (\code -> case code of
      32 -> SetPause False
      _ -> NoOp)
  else
    Sub.batch
    [ Time.every (second / 3) Tick,
      Keyboard.presses (\code -> case code of
        97 -> SetDirection Left
        44 -> SetDirection Down
        101 -> SetDirection Right
        111 -> SetDirection Up

        32 -> SetPause True

        _ -> NoOp)
    ]
