module Msg exposing ( Msg(..) )

import Model exposing (..)

type alias JsonString = String

type Msg
  -- Who is the current Player?
  = InputUsername String
  -- What is the name of the match?
  | InputMatchName String
  -- Tell the server to find or create a new match
  | FindMatch
  -- What action did the player pick?
  | ChooseAction PlayerAction
  -- Send action chosen to server.
  | LockInAction
  -- What is the server telling the client?
  | UpdateModel JsonString
