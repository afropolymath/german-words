module Main exposing (main)

import Browser
import Html exposing (..)
import List.Extra exposing (..)


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


type alias Card =
    { front : String
    , back : String
    , learnt : Bool
    }


type alias Deck =
    { name : String, cards : List Card }


type alias Model =
    { decks : List Deck, activeDeck : Int, activeCard : Int, cardFrontActive : Bool }


type Msg
    = DisplayDeckList
    | DisplayDeck Int
    | DisplayCard Int
    | FlipCard
    | MarkCardAsLearnt


businessDeck =
    Deck "Business Deck" [ Card "die Nutzern" "The users" False, Card "Bestätigung" "Confirmation" False ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [ businessDeck ] -1 -1 True
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayDeckList ->
            ( { model | activeDeck = -1, activeCard = -1 }, Cmd.none )

        DisplayDeck deckIndex ->
            ( { model | activeDeck = deckIndex, activeCard = 0 }, Cmd.none )

        DisplayCard cardIndex ->
            ( { model | activeCard = cardIndex }, Cmd.none )

        FlipCard ->
            ( { model | cardFrontActive = not model.cardFrontActive }, Cmd.none )

        MarkCardAsLearnt ->
            let
                updateCardStatus cardIterIndex card =
                    if cardIterIndex == model.activeCard then
                        { card | learnt = True }

                    else
                        card

                updateDeck deckIterIndex deck =
                    if deckIterIndex == model.activeDeck then
                        { deck | cards = List.indexedMap updateCardStatus deck.cards }

                    else
                        deck
            in
            ( { model | decks = List.indexedMap updateDeck model.decks }, Cmd.none )


deckDetails : Deck -> Html Msg
deckDetails deck =
    div []
        [ div []
            [ text "Active card" ]
        , div
            []
            [ text "Card list" ]
        ]


deckItem : Deck -> Html Msg
deckItem deck =
    div []
        [ p [] [ text deck.name ]
        , div
            []
            [ text (String.fromInt (List.length deck.cards) ++ " cards in total") ]
        , div
            []
            [ text "Learnt cards" ]
        ]


deckList : List Deck -> List (Html Msg)
deckList decks =
    List.map deckItem decks


getDeck : List Deck -> Int -> Maybe Deck
getDeck decks deckIndex =
    getAt deckIndex decks


showDeck : List Deck -> Int -> Html Msg
showDeck decks deckId =
    if deckId < 0 then
        div [] (deckList decks)

    else
        case getDeck decks deckId of
            Just activeDeck ->
                div []
                    [ deckDetails activeDeck
                    ]

            Nothing ->
                div [] (deckList decks)


view : Model -> Html Msg
view model =
    div []
        [ showDeck model.decks model.activeDeck ]
