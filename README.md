# Elm DBZ Game

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

# ElmDBZ

![ElmDBZgif](http://i.imgur.com/NGYNlYA.gif)

## Overview

DBZ is a [Dragon Ball Z](https://en.wikipedia.org/wiki/Dragon_Ball_Z) themed rhythmic hand game. Gameplay can be thought of as an expanded [rock-paper-scissors](https://en.wikipedia.org/wiki/Rock%E2%80%93paper%E2%80%93scissors). RPS players chant "rock paper scissors" or some variation and then simulateously reveal one of three moves; based on the chosen move, a winner is determined. DBZ is essentially multiple RPS rounds strung together with an expanded set of rules and possible moves.

## Rules

Each player begins with a pool of health and zero charges. Charges act as ammo which can be used to shoot the opponent and decrease the opponent's health. 

Where RPS players can only choose one of three options (rock, paper, scissors), DBZ players can choose from one of multiple (shoot, block, charge, steal). Each player performs one action per round.

- __Charge__ - +1 charge if the opponent does not perform the __steal__ action in the same round
- __Steal__ - +1 charge if the opponent performs the __charge__ action in the same round
- __Shoot__ - Expend one charge to shoot the opponent. Opponent loses one health if the opponent does not perform the __block__ action in the same round
- __Block__ - If the opponent performs the __shoot__ action in the same round, negate the opponent's shot. No health is lost by either player.

A victor is declared when a player's health runs out. The above are the base set of actions and the only ones available in ElmDBZ. Variations include reflect - if the opponent shoots in the same turn, the shot is reflected causing the opponent to lose life, and spirit bomb - consumes 5 charges to shoot an unblockable (but reflectable) shot.

## Technical Inspiration

I've spent a lot of time in iOS recently and wanted to explore something unfamiliar. I felt this project was a great introduction into a number of different programming topics. The front end is written in [Elm](http://elm-lang.org/). The backend is written with Swift and the [Vapor server framework](https://vapor.codes/). Communication is performed via websockets.

### Thoughts on Elm

After reading [_Learn You a Haskell_](http://learnyouahaskell.com/) I was eager to practice programming functionally. Elm seemed like a good choice because of the detailed documentation and straight forward web applications.

Elm program logic is "Model Update View," which sounds similar to traditional MVC. Of course, I found that there are a number of significant differences. 

Elm's architectural components don't store state. `View` is not a set of traditional MVC objects; instead `View` is a method with  `Model -> Html Msg` type signature. In lieu of view controllers, `update` is a method with `Msg -> Model -> (Model, Cmd Msg)` type signature. Practically, I found this structure liberating. The only purpose of `Model` is to store data. Typical OOP model methods, like encoding / decoding into / from JSON, are handled in update. This means that views simply transform the model into HTML.

`Update` handles external input in the form of subscriptions. When timers are triggered or a new websockets message is received, `update` is called to transform the model and view. Coding in Elm feels very clean.


###  Thoughts on Vapor Swift

[Vapor Swift](https://vapor.codes/) is one of the first back end server swift solutions. I chose to write the backend in Swift to limit the scope of the project. I chose vapor because they seemed to have the best documentation and easiest to use API. According to the internet, the tradeoff seems to be in performance.

Practically, I think I under estimated how long it would take to feel comfortable in Elm, and ended up punting a lot of the game logic over to the object oriented server, where I was more comfortable.

### Overall Technical Thoughts

In retrospect, I would've liked to plan the server to front end mapping more carefully. I was consumed with learning and experimenting with the frameworks and should've spent more time focused on the overall structure.
