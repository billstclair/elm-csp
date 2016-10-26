port module Csp exposing (..)

import Html exposing (Html, div, h1, text, input, button)
import Html.App as App
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput, onClick)
import Random
import Time exposing (Time, second)

main =
  App.programWithFlags
    { init = init
    , view = view
    , update = updateWithStorage
    , subscriptions = subscriptions
    }

port save : (String, Model) -> Cmd msg

port request : String -> Cmd msg
port receive : (Maybe Model -> msg) -> Sub msg

-- Copied verbatim from https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
  let
    ( newModel, cmds ) = update msg model
  in
      ( newModel
      , Cmd.batch [ save ("", newModel), cmds ]
      )

-- MODEL

modelVersion : Int
modelVersion = 2

type alias Model =
  { version : Int
  , random : Int
  , time : Int
  , name : String
  }

init : Maybe Model -> (Model, Cmd Msg)
init maybeModel =
  let model = case maybeModel of
                   Nothing ->
                     { version = modelVersion
                     , random = 0
                     , time = 0
                     , name = ""
                     }
                   Just m ->
                     m
  in
      (model, Cmd.none)

-- UPDATE

type Msg
  = Tick Time
  | NewRandom Int
  | Change String
  | Save
  | Restore
  | Receive (Maybe Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = model.time + 1 }
       , Random.generate NewRandom <| Random.int 1 100
       )

    NewRandom r ->
      ( { model | random = r }, Cmd.none )

    Change new ->
      ( { model | name = new }, Cmd.none )

    Save ->
      ( model, save ( model.name, model ))

    Restore ->
      ( model, request model.name )

    Receive maybeModel ->
      let model' = case maybeModel of
                       Nothing -> model
                       Just m -> m
      in
          ( model', Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ Time.every second Tick
            , receive Receive
            ]

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.random) ]
    , div []
      [ text "Time: "
      , text <| toString model.time
      ]
    , div []
      [ input [ placeholder "Name", value model.name, onInput Change ]
          []
      , text " "
      , button [ onClick Save ] [ text "Save" ]
      , text " "
      , button [ onClick Restore ] [ text "Restore" ]
      ]
    ]
