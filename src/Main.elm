module Main exposing (..)

import Html exposing ( program )

import Update exposing (..)
import View exposing (..)
import Subscriptions exposing (..)
import Init exposing (..)

main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
