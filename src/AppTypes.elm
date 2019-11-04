module AppTypes exposing (..)


type alias Card =
    { front : String
    , back : String
    , learnt : Bool
    }


type alias Deck =
    { name : String, cards : List Card }


type alias Model =
    { decks : List Deck, activeDeckId : Int, activeCardId : Int, cardIsFlipped : Bool }


type Msg
    = DisplayDeckList
    | DisplayDeck Int
    | DisplayCard Int
    | FlipCard
    | MarkCardAsLearnt
