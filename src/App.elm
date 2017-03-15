module App exposing (..)

import Model exposing (..)
import Msg exposing (..)

import WebSocketsComm exposing (..)



-- init
init: (Model, Cmd Msg)
init =
  (modelInit, Cmd.none)

-- subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  wsListen ()
