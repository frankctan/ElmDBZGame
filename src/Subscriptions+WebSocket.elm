module Subscriptions exposing ( subscriptions
                              , wsSendFindMatch
                              , wsSendPlayerAction )
import WebSocket
import Model
import Json.Encode

subscriptions: Model -> Sub Msg
subscriptions model =
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
    [ ("username",  Json.Encode.string <| record.username)
    , ("matchName",  Json.Encode.string <| record.matchName)
    ]

encodeFindMatchToStr: JsonFindMatch -> String
encodeFindMatchToStr record =
  Json.Encode.encode 0 <| encodeJsonFindMatch record

encodeJsonPlayerAction : JsonPlayerAction -> Json.Encode.Value
encodeJsonPlayerAction record =
  Json.Encode.object
    [ ("username",  Json.Encode.string <| record.username)
    , ("matchName",  Json.Encode.string <| record.matchName)
    , ("playerAction",  Json.Encode.string <| toString <| record.playerAction)
    ]

encodePlayerActionToStr: JsonPlayerAction -> String
encodePlayerActionToStr action =
  Json.Encode.encode 0 <| encodeJsonPlayerAction action
