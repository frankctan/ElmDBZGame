module WebSocketsComm exposing ( wsListen
                               , wsSendFindMatch
                               , wsSendPlayerAction )
import WebSocket
import Model exposing (..)
import Msg exposing (..)
import Json.Encode
import Strings as S exposing (..)

wsListen: () -> Sub Msg
wsListen () =
  WebSocket.listen webSocketServer UpdateModel


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

webSocketServer : String
webSocketServer =
  "ws://localhost:8080/ws"

encodeJsonFindMatch : JsonFindMatch -> Json.Encode.Value
encodeJsonFindMatch record =
  Json.Encode.object
    [ (S.typeKey,  Json.Encode.string <| record.type_)
    , (S.usernameKey,  Json.Encode.string <| record.username)
    , (S.matchNameKey,  Json.Encode.string <| record.matchName)
    ]

encodeFindMatchToStr: JsonFindMatch -> String
encodeFindMatchToStr record =
  Json.Encode.encode 0 <| encodeJsonFindMatch record

encodeJsonPlayerAction : JsonPlayerAction -> Json.Encode.Value
encodeJsonPlayerAction record =
  Json.Encode.object
    [ (S.typeKey,  Json.Encode.string <| S.jsonPlayerActionType)
    , (S.usernameKey,  Json.Encode.string <| record.username)
    , (S.matchNameKey,  Json.Encode.string <| record.matchName)
    , (S.playerAction,  Json.Encode.string <| toString <| record.playerAction)
    ]

encodePlayerActionToStr: JsonPlayerAction -> String
encodePlayerActionToStr action =
  Json.Encode.encode 0 <| encodeJsonPlayerAction action
