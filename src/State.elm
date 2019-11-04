module State exposing (init, subscriptions, update, updateWithStorage)

import AppTypes exposing (..)
import Decks exposing (..)
import Ports exposing (..)


init : Maybe (List Deck) -> ( Model, Cmd Msg )
init flags =
    let
        decks =
            case flags of
                Just cachedDecks ->
                    cachedDecks

                Nothing ->
                    availableDecks
    in
    ( Model decks 2 0 False
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


updateWithStorage msg model =
    let
        ( newModel, commands ) =
            update msg model

        decks =
            newModel.decks
    in
    ( newModel, Cmd.batch [ commands, cacheDecks decks ] )


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
