module Main exposing (main)

import Browser
import Dict
import Random
import Random.List
import Time
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { icons =
            [ "🎮"
            , "🏅"
            , "🎲"
            , "🏈"
            , "🧟"
            , "🎰"
            , "🎱"
            , "🏆"
            , "🕹️"
            , "🔫"
            , "⛳"
            , "♟️"
            , "🎨"
            , "🎯"
            ]
      , tokens = Dict.fromList flags.tokens
      , screen = flags.screen
      , isMobile = flags.screen.width < 1225 || flags.screen.height < 632
      , isShort = flags.screen.height < 800
      , nftIcons = Dict.fromList flags.icons
      , games =
            flags.time
                |> Random.initialSeed
                |> Random.step (Random.List.shuffle flags.games)
                |> Tuple.first
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 500 (always RotateIcons)
