module State exposing (init, subscriptions, update)

import AppTypes exposing (..)
import Decks exposing (..)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model availableDecks 0 0 True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayDeckList ->
            ( { model | activeDeckId = -1, activeCardId = -1 }, Cmd.none )

        DisplayDeck deckIndex ->
            ( { model | activeDeckId = deckIndex, activeCardId = 0 }, Cmd.none )

        DisplayCard cardIndex ->
            ( { model | activeCardId = cardIndex, cardFrontActive = False }, Cmd.none )

        FlipCard ->
            ( { model | cardFrontActive = not model.cardFrontActive }, Cmd.none )

        MarkCardAsLearnt ->
            let
                updateCardStatus cardIterIndex card =
                    if cardIterIndex == model.activeCardId then
                        { card | learnt = True }

                    else
                        card

                updateDeck deckIterIndex deck =
                    if deckIterIndex == model.activeDeckId then
                        { deck | cards = List.indexedMap updateCardStatus deck.cards }

                    else
                        deck
            in
            ( { model | decks = List.indexedMap updateDeck model.decks }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
