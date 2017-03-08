module WebSocketsComm exposing ( wsListen
                               , wsSendFindMatch
                               , wsSendPlayerAction
                               , decodeJsonString
                               , decodePlayer )
import WebSocket
import Model exposing (..)
import Msg exposing (..)
import Json.Encode
import Json.Decode
import Strings as S exposing (..)

wsListen: () -> Sub Msg
wsListen () =
  WebSocket.listen webSocketServer UpdateModel

decodeJsonString: String -> List (String, String)
decodeJsonString json =
  case Json.Decode.decodeString (Json.Decode.keyValuePairs Json.Decode.string) json of
    Ok value -> value
    Err error -> List.singleton ("Error", error)

decodePlayer: String -> Player -> Player
decodePlayer json player =
  let kv = decodeJsonString json in
  List.foldl decodePlayerAccumulator player (Debug.log "kv" kv)

wsSendFindMatch: Model -> Cmd Msg
wsSendFindMatch model =
  WebSocket.send webSocketServer
    <| encodeFindMatchToStr
    <| jsonFindMatchInit model

wsSendPlayerAction: Model -> Cmd Msg
wsSendPlayerAction model =
  WebSocket.send webSocketServer
    <| encodePlayerActionToStr
    <| jsonPlayerActionInit model

-- HELPER METHODS

decodePlayerAccumulator: (String, String) -> Player -> Player
decodePlayerAccumulator (key, data) acc =
  case key of
    "uuid" -> { acc | uuid = (Debug.log "uuid" data) }
    "username" -> { acc | username = data }
    "charges" -> { acc | charges = (Result.withDefault 0 <| String.toInt data)}
    "health" -> { acc | health = (Result.withDefault 0 <| String.toInt data)}
    "actionHistory" -> acc
    "Error" -> acc
    _ -> acc

webSocketServer : String
webSocketServer =
  "ws://localhost:8080/ws"

encodeJsonFindMatch : JsonFindMatch -> Json.Encode.Value
encodeJsonFindMatch record =
  Json.Encode.object
    [ (S.usernameKey,  Json.Encode.string <| record.username)
    , (S.matchNameKey,  Json.Encode.string <| record.matchName)
    ]

encodeFindMatchToStr: JsonFindMatch -> String
encodeFindMatchToStr record =
  Json.Encode.encode 0 <| encodeJsonFindMatch record

encodeJsonPlayerAction : JsonPlayerAction -> Json.Encode.Value
encodeJsonPlayerAction record =
  Json.Encode.object
    [ (S.usernameKey,  Json.Encode.string <| record.username)
    , (S.matchNameKey,  Json.Encode.string <| record.matchName)
    , (S.uuidKey,  Json.Encode.string <| record.uuid)
    , (S.playerActionKey,  Json.Encode.string <| toString <| record.playerAction)
    ]

encodePlayerActionToStr: JsonPlayerAction -> String
encodePlayerActionToStr action =
  Json.Encode.encode 0 <| encodeJsonPlayerAction action
