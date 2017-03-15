module Update exposing ( update )

import Msg exposing (..)
import Model exposing (..)
import WebSocketsComm exposing (..)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    InputUsername str ->
      ( updateCurrentPlayerUsername model str, Cmd.none )

    InputMatchName str ->
      ( { model | matchName = str }, Cmd.none )

    FindMatch ->
      ( model, wsSendFindMatch model )

    ChooseAction action ->
      ( { model | selectedAction = action }, Cmd.none )

    LockInAction ->
      ( model, wsSendPlayerAction model )

    UpdateModel str ->
      let
        player = decodePlayer (Debug.log "json" str) emptyPlayer
        ( currentPlayer_, opposingPlayers_ ) = updatePlayers player model
      in
        ( { model
            | opposingPlayers = (Debug.log "opposingPlayers:" opposingPlayers_)
            , currentPlayer = Debug.log "currentPlayer:" currentPlayer_
          }, Cmd.none )

updatePlayers: Player -> Model -> ( Player, List Player )
updatePlayers player model =
  let
    currentPlayer_ =
      if model.currentPlayer.uuid == "" ||
         ( playerEquatable player model.currentPlayer ) then
           player
      else
        model.currentPlayer

    opposingPlayers_ =
      if not (playerEquatable player currentPlayer_) then
        updateOpposingPlayers player model.opposingPlayers
      else
        model.opposingPlayers
  in
    ( currentPlayer_, opposingPlayers_ )

updateOpposingPlayers: Player -> List Player -> List Player
updateOpposingPlayers newPlayer oldList =
  let uuids = List.map .uuid oldList in
    if (List.member newPlayer.uuid uuids) then
      List.foldl
        (\p acc ->
          if (playerEquatable newPlayer p) then
            newPlayer :: acc
          else
            p :: acc)
        []
        oldList
    else
      newPlayer :: oldList

updateCurrentPlayerUsername: Model -> String -> Model
updateCurrentPlayerUsername model str =
  let
    oldPlayer = model.currentPlayer
  in
    { model | currentPlayer = { oldPlayer | username = str } }

updateCurrentPlayerUUID: Model -> String -> Model
updateCurrentPlayerUUID model str =
    let
      oldPlayer = model.currentPlayer
    in
      { model | currentPlayer = { oldPlayer | uuid = str } }
