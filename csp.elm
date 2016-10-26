import Html exposing (Html, div, h1, text)
import Html.App as App
import Random
import Time exposing (Time, second)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { random : Int
  , time: Int
  }

init : (Model, Cmd Msg)
init =
  ({ random = 0
   , time = 0
   }
  , Cmd.none)

-- UPDATE

type Msg
  = Tick Time
  | NewRandom Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = model.time + 1 }
       , Random.generate NewRandom <| Random.int 1 100
       )

    NewRandom r ->
      ( { model | random = r }, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.random) ]
    , div []
      [ text "Time: "
      , text <| toString model.time
      ]
    ]
