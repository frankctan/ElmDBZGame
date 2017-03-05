module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Encode
-- import Json.Decode
-- import Dict exposing (..)

-- init
init: (Model, Cmd Msg)
init =
  (Model "" Block (Match "" [] 0), Cmd.none)

-- Model
type alias Model =
  { currentPlayerUsername: String
  , selectedAction: PlayerAction
  , match: Match
  }

type alias Player =
  { username: String
  , charges: Int
  , health: Int
  }

type alias Match =
  { name: String
  , players: List Player
  , turnNumber: Int
  }

-- JSON records
type alias JsonFindMatch =
  { username: String
  , matchName: String
  }

type alias JsonPlayerAction =
  { username: String
  , matchName: String
  , playerAction: PlayerAction
  }

jsonFindMatchInit: Model -> JsonFindMatch
jsonFindMatchInit model =
  JsonFindMatch model.currentPlayerUsername model.match.name

encodeJsonFindMatch : JsonFindMatch -> Json.Encode.Value
encodeJsonFindMatch record =
    Json.Encode.object
        [ ("username",  Json.Encode.string <| record.username)
        , ("matchName",  Json.Encode.string <| record.matchName)
        ]

encodeFindMatchToStr: JsonFindMatch -> String
encodeFindMatchToStr record =
  Json.Encode.encode 0 (encodeJsonFindMatch record)

encodeJsonPlayerAction : JsonPlayerAction -> Json.Encode.Value
encodeJsonPlayerAction record =
    Json.Encode.object
        [ ("username",  Json.Encode.string <| record.username)
        , ("matchName",  Json.Encode.string <| record.matchName)
        , ("playerAction",  Json.Encode.string <| toString <| record.playerAction)
        ]


type alias JsonString = String

type Msg
  -- Who is the current Player?
  = InputUsername String
  -- What is the name of the match?
  | InputMatchName String
  -- Tell the server to find or create a new match
  | FindMatch
  -- What action did the player pick?
  | ChooseAction PlayerAction
  -- What action did the player lock in?
  | LockInAction PlayerAction
  -- What is the server telling the client?
  | UpdateModel JsonString

type PlayerAction
   = Block
   | Charge
   | Shoot
   | Steal

webSocketServer : String
webSocketServer =
  "ws://localhost:8080/ws"

-- update

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    InputUsername str ->
      ( { model | username = str }, Cmd.none )

    InputMatchName str ->
      ( { model | matchName = str}, Cmd.none )

    FindMatch ->
      -- TODO: Call websockets. WebSocket.send webSocketServer jsonStr
      ( model, Cmd.none )

    ChooseAction action ->
      ( { model | selectedAction = action }, Cmd.none )

    LockInAction action ->
      -- TODO: Call websockets. WebSocket.send webSocketServer jsonStr
      ( model, Cmd.none )

    PayloadInput str ->
      ( { model | payload = str }, Cmd.none )

    UpdateModel str ->
      -- TODO: Update model based on server
      ( model, Cmd.none )

encodeToJsonString: (String, String) -> String
encodeToJsonString (a, b) =
  -- (String, String) -> List (String, Json.Encode.Value) -> encoded string
  Json.Encode.encode 0
    <| Json.Encode.object
    <| [("username", Json.Encode.string a), ("payload", (Json.Encode.string b) )]

decodeJsonString: String -> (Dict String String)
decodeJsonString json =
  case Json.Decode.decodeString (Json.Decode.dict Json.Decode.string) json of
    Ok value -> value
    Err error -> singleton "Error" error

-- subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  WebSocket.listen webSocketServer IncomingMessage

-- view

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Username"
            , onInput UserNameInput
            , value model.username
            ] []
    , div []
        [ input [ placeholder "payload to send"
                , onInput PayloadInput
                , value model.payload
                ] []
        , button [onClick Send] [ text "Send" ]
        ]
      -- Display player actions here.
    , div []
        [
          button [ onClick (SelectAction Shoot) ] [ text "Shoot" ]
        ]
    , div []
        [
          button [ onClick Send ] [text "Lock In"]
        ]
    , div [] (List.map viewResult model.results)
    ]

viewResult: String -> Html Msg
viewResult result =
  div [] [ text result ]
