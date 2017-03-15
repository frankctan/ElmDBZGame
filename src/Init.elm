module Init exposing ( init )

import Model exposing (..)
import Msg exposing (..)

init: (Model, Cmd Msg)
init =
  (modelInit, Cmd.none)
