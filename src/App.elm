module App exposing (..)

import Model exposing (..)
import Msg exposing (..)
import WebSocketsComm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Dict exposing (..)

-- init
init: (Model, Cmd Msg)
init =
  (Model "" "" Block (Match "" [] 0), Cmd.none)

-- update

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    InputUsername str ->
      ( { model | currentPlayerUsername = str }, Cmd.none )

    InputMatchName str ->
      let m = model.match in
        ( { model | match = Match str m.players m.turnNumber }, Cmd.none )

    FindMatch ->
      ( model, wsSendFindMatch model )

    ChooseAction action ->
      ( { model | selectedAction = action }, Cmd.none )

    LockInAction ->
      ( model, wsSendPlayerAction model )

    UpdateModel str ->
      let dict = decodeJsonString str
          uuidStr = case (get "uuid" dict) of
            Just uid -> uid
            Nothing -> "" in
              ( { model | uuid = uuidStr } , Cmd.none )

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
              , value model.currentPlayerUsername
              ] [] ]
    , div []
        [ input [ placeholder "Match Name"
                , onInput InputMatchName
                , value model.match.name
                ] [] ]
    , div []
        [ button [ onClick FindMatch ] [text "Find Match"] ]
    ]

matchFindView: Model -> Html Msg
matchFindView model =
  div []
    [ div [] [ text model.currentPlayerUsername ]
    , div [] [ text model.match.name ]
    , div [] [ text "finding match..." ]
    ]

view : Model -> Html Msg
view model =
  if model.uuid == "" then
    signInView model
  else
    matchFindView model



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
