module Model exposing (..)

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
  { username: String
  , matchName: String
  }

type alias JsonPlayerAction =
  { username: String
  , matchName: String
  , playerAction: PlayerAction
  }

-- INIT

jsonFindMatchInit: Model -> JsonFindMatch
jsonFindMatchInit model =
  JsonFindMatch model.currentPlayerUsername model.match.name

jsonPlayerActionInit: Model -> JsonPlayerAction
jsonPlayerActionInit model =
  JsonPlayerAction
    model.currentPlayerUsername
    model.match.name
    model.selectedAction
