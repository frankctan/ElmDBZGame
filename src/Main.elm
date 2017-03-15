module Main exposing (..)

import App exposing (..)
import Update exposing (..)
import Html exposing ( program )

main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
