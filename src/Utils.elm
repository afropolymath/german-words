module Utils exposing (..)

import AppTypes exposing (..)


findBySlug : String -> List Deck -> Maybe Deck
findBySlug slug deckList =
    List.filter (\deck -> deck.slug == slug) deckList
        |> List.head


replaceBySlug : String -> (Deck -> Deck) -> Deck -> Deck
replaceBySlug slug replacementDeckFn deck =
    if slug == deck.slug then
        replacementDeckFn deck

    else
        deck


isDeckInList : String -> List Deck -> Bool
isDeckInList slug deckList =
    case findBySlug slug deckList of
        Just _ ->
            True

        Nothing ->
            False
