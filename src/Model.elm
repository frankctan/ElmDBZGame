module Model exposing (..)
import Strings as S exposing (..)

type PlayerAction
   = Block
   | Charge
   | Shoot
   | Steal

type alias Model =
  { currentPlayerUsername: String
  , selectedAction: PlayerAction
  , match: Match
  }

type alias Player =
  { username: String
  , charges: Int
  , health: Int
  }

type alias Match =
  { name: String
  , players: List Player
  , turnNumber: Int
  }

-- JSON records

type alias JsonFindMatch =
  { type_: String
  , username: String
  , matchName: String
  }

type alias JsonPlayerAction =
  { type_: String
  , username: String
  , matchName: String
  , playerAction: PlayerAction
  }

-- INIT

jsonFindMatchInit: Model -> JsonFindMatch
jsonFindMatchInit model =
  JsonFindMatch
    S.jsonFindMatchType
    model.currentPlayerUsername
    model.match.name

jsonPlayerActionInit: Model -> JsonPlayerAction
jsonPlayerActionInit model =
  JsonPlayerAction
    S.jsonPlayerActionType
    model.currentPlayerUsername
    model.match.name
    model.selectedAction
