module MainView exposing (view)

import AppTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import List.Extra exposing (..)
import RemoteData
import String exposing (join)
import Utils exposing (findBySlug)



{- | References

   Html Attributes package
   https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes

-}
-- Utility methods


alwaysStop : a -> ( a, Bool )
alwaysStop x =
    ( x, True )


stopPropagationOnClick : msg -> Attribute msg
stopPropagationOnClick msg =
    stopPropagationOn "click" (Json.map alwaysStop (Json.succeed msg))


view : Model -> Html Msg
view model =
    div []
        [ section [ class "header" ]
            [ div [ class "container" ]
                [ h1 [ class "logo" ] [ text model.applicationTitle ]
                ]
            ]
        , section [ class "main" ]
            [ div [ class "container" ]
                [ renderDecks model
                ]
            ]
        ]


withDefaultMaybe : Maybe a -> Maybe a -> Maybe a
withDefaultMaybe fallBackMaybe maybe =
    case maybe of
        Just val ->
            Just val

        Nothing ->
            fallBackMaybe



-- Render all the available decks in a list or display selected deck


renderDecks : Model -> Html Msg
renderDecks model =
    case model.applicationDecks of
        RemoteData.Success applicationDecks ->
            case model.activeDeckSlug of
                Just activeDeckSlug ->
                    case withDefaultMaybe (findBySlug activeDeckSlug applicationDecks) (findBySlug activeDeckSlug model.userDecks) of
                        Just activeDeck ->
                            renderDeck model activeDeck

                        Nothing ->
                            renderDeckList model.userDecks applicationDecks

                Nothing ->
                    renderDeckList model.userDecks applicationDecks

        _ ->
            renderDeckList model.userDecks []



-- Render the list of decks


renderDeckList : List Deck -> List Deck -> Html Msg
renderDeckList userDecks applicationDecks =
    let
        classifyBeforeRender deck =
            Maybe.withDefault deck (findBySlug deck.slug userDecks)
    in
    div [ class "deck-list-container" ]
        [ ul [ class "breadcrumb-nav" ] [ li [] [ text ("Showing all " ++ String.fromInt (List.length applicationDecks) ++ " Decks") ] ]
        , div [ class "deck-list" ] (List.map (classifyBeforeRender >> renderDeckListItem) applicationDecks)
        ]



-- Render a single item in the deck list


renderDeckListItem : Deck -> Html Msg
renderDeckListItem deck =
    let
        learntCount =
            List.length (List.filter (\card -> card.learnt) deck.cards)

        learntCards =
            join " " [ String.fromInt learntCount, "/", String.fromInt (List.length deck.cards), "cards learnt" ]
    in
    div [ class "deck-list-item", onClick (DisplayDeck deck.slug) ]
        [ p [ class "deck-name" ] [ text deck.name ]
        , p [ class "deck-stat" ] [ text learntCards ]
        , p
            [ classList
                [ ( "deck-tags", True )
                , ( "is-hidden", List.isEmpty deck.tags )
                ]
            ]
            (List.map (\tag -> Html.span [] [ text tag ]) deck.tags)
        ]



-- Render a the selected deck


renderDeck : Model -> Deck -> Html Msg
renderDeck model deck =
    let
        displayNextCard =
            if model.activeCardId == List.length deck.cards - 1 then
                DisplayCard model.activeCardId

            else
                DisplayCard (model.activeCardId + 1)

        displayPreviousCard =
            if model.activeCardId == 0 then
                DisplayCard model.activeCardId

            else
                DisplayCard (model.activeCardId - 1)

        displayText card =
            if model.cardIsFlipped then
                card.back

            else
                card.front

        activeCard =
            case getAt model.activeCardId deck.cards of
                Just card ->
                    div
                        [ class "active-card"
                        , onClick FlipCard
                        , classList
                            [ ( "is-learnt", card.learnt )
                            ]
                        ]
                        [ Html.span [ class "control-left", stopPropagationOnClick displayPreviousCard ] []
                        , Html.span [ class "control-right", stopPropagationOnClick displayNextCard ] []
                        , h1 [ class "card-text" ] [ text (displayText card) ]
                        , Html.span [ class "mark-learnt", stopPropagationOnClick ToggleLearnt ]
                            [ i [ class "material-icons" ]
                                [ text
                                    (if card.learnt then
                                        "undo"

                                     else
                                        "check"
                                    )
                                ]
                            ]
                        ]

                Nothing ->
                    div [] [ text "Could not find that card" ]

        deckCardNavItem cardIndex card =
            li
                [ classList
                    [ ( "active", cardIndex == model.activeCardId )
                    , ( "learnt", card.learnt )
                    ]
                , onClick (DisplayCard cardIndex)
                ]
                []
    in
    div [ class "deck" ]
        [ ul [ class "breadcrumb-nav" ]
            [ li [ class "active", onClick DisplayDeckList ] [ text "Back to all Decks" ]
            , li [] [ text deck.name ]
            ]
        , activeCard
        , List.indexedMap deckCardNavItem deck.cards
            |> ul [ class "deck-card-navigation" ]
        ]
