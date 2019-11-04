module MainView exposing (view)

import AppTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra exposing (..)
import String exposing (join)



{- | References

   Html Attributes package
   https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes

-}


renderDeck : Deck -> Int -> Bool -> Html Msg
renderDeck deck activeCardId cardFrontActive =
    let
        displayNextCard =
            if activeCardId == List.length deck.cards - 1 then
                DisplayCard activeCardId

            else
                DisplayCard (activeCardId + 1)

        displayPreviousCard =
            if activeCardId == 0 then
                DisplayCard activeCardId

            else
                DisplayCard (activeCardId - 1)

        displayText card =
            if cardFrontActive then
                card.front

            else
                card.back

        activeCard =
            case getAt activeCardId deck.cards of
                Just card ->
                    div [ class "active-card", onClick FlipCard ]
                        [ Html.span [ class "control-left", onClick displayPreviousCard ] []
                        , Html.span [ class "control-right", onClick displayNextCard ] []
                        , h1 [ class "card-text" ] [ text (displayText card) ]
                        ]

                Nothing ->
                    div [] [ text "Could not find that card" ]

        deckCardNavItem cardIndex card =
            li [] [ text (String.fromInt (cardIndex + 1)) ]
    in
    div [ class "deck" ]
        [ activeCard
        , ul [ class "deck-card-navigation" ] <|
            List.indexedMap deckCardNavItem deck.cards
        ]



-- Render a single item in the deck list


renderDeckListItem : Int -> Deck -> Html Msg
renderDeckListItem deckId deck =
    let
        learntCards =
            join " " [ "0 out of ", String.fromInt (List.length deck.cards), "cards learnt" ]
    in
    div [ class "deck-list-item", onClick (DisplayDeck deckId) ]
        [ p [ class "deck-name" ] [ text deck.name ]
        , p [ class "deck-stat" ] [ text learntCards ]
        ]



-- Render the list of decks


renderDeckList : List Deck -> Html Msg
renderDeckList decks =
    div [ class "deck-list" ] (List.indexedMap renderDeckListItem decks)



-- Render all the available decks in a list or display selected deck


renderDecks : List Deck -> Int -> Int -> Bool -> Html Msg
renderDecks decks deckId cardId cardFrontActive =
    if deckId < 0 then
        renderDeckList decks

    else
        case getAt deckId decks of
            Just activeDeck ->
                renderDeck activeDeck cardId cardFrontActive

            Nothing ->
                renderDeckList decks


view : Model -> Html Msg
view model =
    div []
        [ section [ class "header" ]
            [ div [ class "container" ]
                [ h1 [ class "logo" ] [ text "German words" ]
                ]
            ]
        , section [ class "main" ]
            [ div [ class "container" ]
                [ renderDecks model.decks model.activeDeckId model.activeCardId model.cardFrontActive
                ]
            ]
        ]
