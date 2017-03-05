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
  (Model "" Block (Match "" [] 0), Cmd.none)

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
      -- TODO: Update model based on server
      ( model, Cmd.none )

-- subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  wsListen ()

-- view

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Username"
            , onInput InputUsername
            , value model.currentPlayerUsername
            ] []
    , div []
        [ input [ placeholder "Match Name"
                , onInput InputMatchName
                , value model.match.name
                ] []
        , button [onClick FindMatch] [ text "FindMatch" ]
        ]
      -- Display player actions here.
    , div []
        [
          button [ onClick (ChooseAction Shoot) ] [ text "Shoot" ]
        ]
    , div []
        [
          button [ onClick LockInAction ] [text "Lock In"]
        ]
    -- , div [] (List.map viewResult model.results)
    ]

-- viewResult: String -> Html Msg
-- viewResult result =
--   div [] [ text result ]
