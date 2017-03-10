module App exposing (..)

import Model exposing (..)
import Msg exposing (..)
import WebSocketsComm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- init
init: (Model, Cmd Msg)
init =
  (modelInit, Cmd.none)

-- update

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

-- subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  wsListen ()

-- view

signInView: Model -> Html Msg
signInView model =
  div []
    [ div []
      [ input [ placeholder "Username"
              , onInput InputUsername
              , value model.currentPlayer.username
              ] []
      ]
    , div []
        [ input [ placeholder "Match Name"
                , onInput InputMatchName
                , value model.matchName
                ] []
        ]
    , div []
        [ button [ onClick FindMatch ] [text "Find Match"] ]
    ]

matchView: Model -> Html Msg
matchView model =
  div []
    [ div [] [ text <| String.append "matchName:" model.matchName ]
    , playerStatsView model.currentPlayer
    , if List.length model.opposingPlayers == 0 then
        findingMatchView model
      else
        div []
        [ playerActionButtonsView
        -- TODO: Support multiple players. For now, enforce 2 player requirement.
        , playerStatsView
          <| Maybe.withDefault emptyPlayer
          <| List.head model.opposingPlayers
        ]
    ]

playerStatsView: Player -> Html Msg
playerStatsView player =
  div []
  [ div [] [ text player.username ]
  , div [] [ text <| String.append "health: " <| toString player.health ]
  , div [] [ text <| String.append "charges: " <| toString player.charges ]
  ]

playerActionButtonsView: Html Msg
playerActionButtonsView =
  div []
  [ div []
    [ button [ onClick (ChooseAction Shoot) ] [ text "Shoot" ]
    , button [ onClick (ChooseAction Block) ] [ text "Block" ]
    , button [ onClick (ChooseAction Charge) ] [ text "Charge" ]
    , button [ onClick (ChooseAction Steal) ] [ text "Steal" ]
    ]
  , div []
    [ button [ onClick LockInAction ] [ text "Lock In" ]
    ]
  ]

findingMatchView: Model -> Html Msg
findingMatchView model =
  div [] [text "finding match..."]

view : Model -> Html Msg
view model =
  if model.currentPlayer.uuid == "" then
    signInView model
  else
    matchView model
