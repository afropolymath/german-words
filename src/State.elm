module State exposing (init, subscriptions, update, updateWithStorage)

import AppTypes exposing (..)
import Decks exposing (getDecks)
import Ports exposing (cacheDecks)
import RemoteData
import Utils exposing (findBySlug, isDeckInList, replaceBySlug)


init : Maybe (List Deck) -> ( Model, Cmd Msg )
init flags =
    let
        userDecks =
            case flags of
                Just cachedUserDecks ->
                    cachedUserDecks

                Nothing ->
                    []
    in
    ( Model "Seré" RemoteData.NotAsked userDecks Nothing -1 False
    , getDecks
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, commands ) =
            update msg model
    in
    ( newModel, Cmd.batch [ commands, cacheDecks newModel.userDecks ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayDeckList ->
            ( reducerDisplayDeckList model, Cmd.none )

        DisplayDeck deckSlug ->
            ( reducerDisplayDeck model deckSlug, Cmd.none )

        DisplayCard cardIndex ->
            ( reducerDisplayCard model cardIndex, Cmd.none )

        FlipCard ->
            ( reducerFlipCard model, Cmd.none )

        ToggleLearnt ->
            ( reducerUpdateDecks model toggleActiveCardLearnt, Cmd.none )

        GetDecks ->
            ( model, getDecks )

        DecksReceived response ->
            ( reducerUpdateApplicationDecks model response, Cmd.none )


reducerDisplayDeckList : Model -> Model
reducerDisplayDeckList model =
    { model | activeDeckSlug = Nothing, activeCardId = -1 }


reducerDisplayDeck : Model -> String -> Model
reducerDisplayDeck model deckSlug =
    { model | activeDeckSlug = Just deckSlug, activeCardId = 0, userDecks = updatedUserDecks { model | activeDeckSlug = Just deckSlug } True }


reducerDisplayCard : Model -> Int -> Model
reducerDisplayCard model cardIndex =
    { model | activeCardId = cardIndex, cardIsFlipped = False }


reducerFlipCard : Model -> Model
reducerFlipCard model =
    { model
        | userDecks =
            if model.activeCardId > 0 then
                updatedUserDecks model False

            else
                model.userDecks
        , cardIsFlipped = not model.cardIsFlipped
    }


reducerUpdateDecks : Model -> (Card -> Card) -> Model
reducerUpdateDecks model cardUpdateFunc =
    let
        updateCard cardIterIndex card =
            if cardIterIndex == model.activeCardId then
                cardUpdateFunc card

            else
                card

        updateDeck deck =
            case model.activeDeckSlug of
                Just activeDeckSlug ->
                    if deck.slug == activeDeckSlug then
                        { deck | cards = List.indexedMap updateCard deck.cards }

                    else
                        deck

                Nothing ->
                    deck
    in
    { model | userDecks = List.map updateDeck (updatedUserDecks model False) }


reducerUpdateApplicationDecks : Model -> RemoteData.WebData (List Deck) -> Model
reducerUpdateApplicationDecks model response =
    { model | applicationDecks = response }


synchronizeCards : Deck -> Deck -> Deck
synchronizeCards applicationDeck deck =
    let
        deckCardLength =
            List.length deck.cards

        cardsAppendage =
            List.drop deckCardLength applicationDeck.cards

        updatedCards =
            List.map2 (\appDeckCard userDeckCard -> { userDeckCard | front = appDeckCard.front, back = appDeckCard.back }) applicationDeck.cards deck.cards
    in
    { deck | name = applicationDeck.name, tags = applicationDeck.tags, cards = updatedCards ++ cardsAppendage }


updatedUserDecks : Model -> Bool -> List Deck
updatedUserDecks model onlySync =
    case model.applicationDecks of
        RemoteData.Success applicationDecks ->
            case model.activeDeckSlug of
                Just activeDeckSlug ->
                    case findBySlug activeDeckSlug applicationDecks of
                        Just applicationDeck ->
                            if onlySync then
                                List.map (replaceBySlug activeDeckSlug (synchronizeCards applicationDeck)) model.userDecks

                            else if not (isDeckInList activeDeckSlug model.userDecks) then
                                model.userDecks ++ [ applicationDeck ]

                            else
                                model.userDecks

                        Nothing ->
                            model.userDecks

                Nothing ->
                    model.userDecks

        _ ->
            model.userDecks


toggleActiveCardLearnt : Card -> Card
toggleActiveCardLearnt card =
    { card | learnt = not card.learnt }
