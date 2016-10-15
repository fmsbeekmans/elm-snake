module Snake.Main exposing (main)

import Html exposing (..)
import Html.App

import Snake.Model exposing (..)

main : Program Never
main =
    Html.App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

type alias Model =
  {}

type Msg = Tick | SetDirection Direction

initialModel : Model
initialModel = {}

init : (Model, Cmd Msg)
init = ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )

view : Model -> Html Msg
view model = text (toString model)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
