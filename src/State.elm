module State exposing (init, subscriptions, update)

import AppTypes exposing (..)
import Decks exposing (..)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model availableDecks 2 0 False
    , Cmd.none
    )


markCardAsLearnt activeCardId cardIterIndex card =
    if cardIterIndex == activeCardId then
        { card | learnt = True }

    else
        card


toggleLearnt activeCardId cardIterIndex card =
    if cardIterIndex == activeCardId then
        { card | learnt = not card.learnt }

    else
        card


updateDeck activeDeckId func deckIterIndex deck =
    if deckIterIndex == activeDeckId then
        { deck | cards = List.indexedMap func deck.cards }

    else
        deck


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayDeckList ->
            ( { model | activeDeckId = -1, activeCardId = -1 }, Cmd.none )

        DisplayDeck deckIndex ->
            ( { model | activeDeckId = deckIndex, activeCardId = 0 }, Cmd.none )

        DisplayCard cardIndex ->
            ( { model | activeCardId = cardIndex, cardIsFlipped = False }, Cmd.none )

        FlipCard ->
            ( { model | cardIsFlipped = not model.cardIsFlipped }, Cmd.none )

        ToggleLearnt ->
            ( { model | decks = List.indexedMap (updateDeck model.activeDeckId (toggleLearnt model.activeCardId)) model.decks }, Cmd.none )

        MarkCardAsLearnt ->
            ( { model | decks = List.indexedMap (updateDeck model.activeDeckId (markCardAsLearnt model.activeCardId)) model.decks }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
