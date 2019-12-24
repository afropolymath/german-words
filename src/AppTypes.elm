module AppTypes exposing (..)

import RemoteData exposing (WebData)



{-
   A Card is a representation of a word that needs to be learnt. A card has a back
   a front and as part of the model, a boolean indicating whether or not this card
   has been learnt
-}


type alias Card =
    { front : String
    , back : String
    , learnt : Bool
    }



-- A Deck can be defined as a list of cards.


type alias Deck =
    { name : String
    , slug : String
    , tags : List String
    , cards : List Card
    }


type alias Model =
    { applicationTitle : String
    , applicationDecks : WebData (List Deck)
    , userDecks : List Deck
    , activeDeckSlug : Maybe String
    , activeCardId : Int
    , cardIsFlipped : Bool
    }


type Msg
    = DisplayDeckList
    | DisplayDeck String
    | DisplayCard Int
    | FlipCard
    | ToggleLearnt
    | GetDecks
    | DecksReceived (WebData (List Deck))
