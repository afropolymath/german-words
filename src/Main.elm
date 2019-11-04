module Main exposing (main)

import Browser
import MainView exposing (view)
import State exposing (init, subscriptions, updateWithStorage)


main =
    Browser.element { init = init, update = updateWithStorage, subscriptions = subscriptions, view = view }
