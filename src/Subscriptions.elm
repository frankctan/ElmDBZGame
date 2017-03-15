module Subscriptions exposing ( subscriptions )

import Msg exposing (..)
import WebSocketsComm exposing ( wsListen )
import Model exposing (..)

subscriptions: Model -> Sub Msg
subscriptions model =
  wsListen ()
