module Model exposing (..)
-- import Strings as S exposing (..)

type PlayerAction
   = Block
   | Charge
   | Shoot
   | Steal

type alias Model =
  { currentPlayer: Player
  , selectedAction: PlayerAction
  , opposingPlayers: List Player
  , matchName: String
  , turnNumber: Int
  }

type alias Player =
  { uuid: String
  , username: String
  , charges: Int
  , health: Int
  , actionHistory: List PlayerAction
  }

-- JSON records

type alias JsonFindMatch =
  { username: String
  , matchName: String
  }

type alias JsonPlayerAction =
  { username: String
  , matchName: String
  , uuid: String
  , playerAction: PlayerAction
  }

-- INIT

modelInit: Model
modelInit = Model emptyPlayer Block [] "" 0

emptyPlayer: Player
emptyPlayer = Player "" "" 0 0 []

jsonFindMatchInit: Model -> JsonFindMatch
jsonFindMatchInit model =
  JsonFindMatch
    model.currentPlayer.username
    model.matchName

jsonPlayerActionInit: Model -> JsonPlayerAction
jsonPlayerActionInit model =
  JsonPlayerAction
    model.currentPlayer.username
    model.matchName
    model.currentPlayer.uuid
    model.selectedAction

-- Equatable

playerEquatable: Player -> Player -> Bool
playerEquatable p1 p2 =
  p1.uuid == p2.uuid
