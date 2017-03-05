module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Encode
import Json.Decode
import Dict exposing (..)

-- init
init: (Model, Cmd Msg)
init =
  (Model "" "" [] Block, Cmd.none)

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
  , players: [Player]
  , turnNumber: Int
  }

  , matchName: String
  }

type alias JsonString = String

type Msg
  -- Who is the current Player?
  = InputUsername String
  -- What is the name of the match?
  | InputMatchName String
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
    UserNameInput str ->
      ( { model | username = str }, Cmd.none )

    PayloadInput str ->
      ( { model | payload = str }, Cmd.none )

    Send ->
      let
        jsonStr: String
        jsonStr =
           encodeToJsonString ( model.username, model.payload )
           in
            -- (Model "" "" model.results, WebSocket.send webSocketServer jsonStr)
              ({ model | username = "", payload = "" }, WebSocket.send webSocketServer jsonStr)

    IncomingMessage str ->
      let jsonDict = decodeJsonString str
          message = case get "message" jsonDict of
            Just m -> m
            Nothing -> "Nothing!"
              in
                (Model "" "" (message :: model.results), Cmd.none)

    SelectAction playerAction ->
      ({ model | selectedAction = playerAction }, Cmd.none)


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
