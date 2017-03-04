module Main exposing (..)

import App exposing (..)
import Html exposing (program)

main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
