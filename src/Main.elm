module Main exposing (..)

import Html exposing ( program )

import App exposing (..)
import Update exposing (..)
import View exposing (..)

main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
