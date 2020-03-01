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

German words
<https://www.learnalanguage.com/learn-german/german-words/>
<https://www.germanpod101.com/german-word-lists/>
<https://1000mostcommonwords.com/1000-most-common-german-words/>

German course
<https://www.deutsch-lernen.com/learn-german-online/e_dc.php>

-}
url : String
url =
    "data/decks.json"


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
