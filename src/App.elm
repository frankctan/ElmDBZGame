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
  (Model "" "" [], Cmd.none)

-- model

type alias Model =
  { username: String
  , payload: String
  , results: List String
  }

type Msg
  = UserNameInput String
  | PayloadInput String
  | IncomingMessage String
  | Send

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
    , div [] (List.map viewResult model.results)
    ]

viewResult: String -> Html Msg
viewResult result =
  div [] [ text result ]
