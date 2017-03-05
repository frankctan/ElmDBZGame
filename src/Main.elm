module Main exposing (..)

import App exposing (..)
-- import Subscriptions exposing (subscriptions)
import Html exposing (program)

main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
