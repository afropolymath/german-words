port module Ports exposing (cacheDecks)

import AppTypes exposing (..)


port cacheDecks : List Deck -> Cmd msg
