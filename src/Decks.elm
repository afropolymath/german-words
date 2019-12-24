module Decks exposing (getDecks)

import AppTypes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import RemoteData


{-| References

German-English Dictionary JSON
<https://github.com/hathibelagal/German-English-JSON-Dictionary>

Conjunctions Deck
<https://www.clozemaster.com/blog/german-conjunctions/>

-}
url : String
url =
    "http://localhost:8080/data/decks.json"


getDecks : Cmd Msg
getDecks =
    Http.get
        { url = url
        , expect =
            list deckDecoder
                |> Http.expectJson (RemoteData.fromResult >> DecksReceived)
        }


{-| References

Json Decode Pipeline package
<https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/Json-Decode-Pipeline>

-}
deckDecoder : Decoder Deck
deckDecoder =
    Decode.succeed Deck
        |> required "name" string
        |> required "slug" string
        |> optional "tags" (list string) []
        |> required "cards" (list cardDecoder)


cardDecoder : Decoder Card
cardDecoder =
    Decode.succeed Card
        |> required "front" string
        |> required "back" string
        |> hardcoded False
