module View exposing ( view )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Msg exposing (..)
import Model exposing (..)

view : Model -> Html Msg
view model =
  if model.currentPlayer.uuid == "" then
    signInView model
  else
    matchView model

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
        -- TODO: Enforce 2 player requirement.
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
