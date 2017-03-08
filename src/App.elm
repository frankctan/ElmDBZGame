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

        opposingPlayers_ =
          List.foldl
          (\p acc -> if (playerEquatable player p) then player :: acc else acc)
          []
          model.opposingPlayers

        currentPlayer_ =
          -- Special case the scenario in which the current player doesn't have a uuid yet.
          if model.currentPlayer.uuid == "" then player else
            if (playerEquatable player model.currentPlayer)
               then player
               else model.currentPlayer
      in
        ( { model | opposingPlayers = opposingPlayers_, currentPlayer = currentPlayer_ }, Cmd.none )

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
    [ div [] [ text model.currentPlayer.username ]
    , div [] [ text model.matchName ]
    , div [] [ text (toString model.currentPlayer.health) ]
    , div [] [ text model.currentPlayer.uuid ]
    , findingMatch model
    ]

findingMatch: Model -> Html Msg
findingMatch model =
  div [] [text "finding match..."]

view : Model -> Html Msg
view model =
  if model.currentPlayer.uuid == "" then
    signInView model
  else
    matchView model

  -- div []
  --   [ input [ placeholder "Username"
  --           , onInput InputUsername
  --           , value model.currentPlayerUsername
  --           ] []
  --   , div []
  --       [ input [ placeholder "Match Name"
  --               , onInput InputMatchName
  --               , value model.match.name
  --               ] []
  --       , input [ placeholder "uuid"
  --               , value model.uuid
  --               ] []
  --       , button [ onClick FindMatch ] [ text "FindMatch" ]
  --       ]
  --     -- Display player actions here.
  --   , div []
  --       [
  --         button [ onClick (ChooseAction Shoot) ] [ text "Shoot" ]
  --       ]
  --   , div []
  --       [
  --         button [ onClick LockInAction ] [text "Lock In"]
  --       ]
  --   -- , div [] (List.map viewResult model.results)
  --   ]

-- viewResult: String -> Html Msg
-- viewResult result =
--   div [] [ text result ]
