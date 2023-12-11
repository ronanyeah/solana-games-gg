module Types exposing (..)

import Dict exposing (Dict)


type alias Model =
    { icons : List String
    , games : List Game
    , tokens : Dict String Token
    , nftIcons : Dict String String
    , screen : Screen
    , isMobile : Bool
    , isShort : Bool
    }


type alias Flags =
    { screen : Screen
    , games : List Game
    , time : Int
    , tokens : List ( String, Token )
    , icons : List ( String, String )
    }


type Msg
    = RotateIcons


type alias Screen =
    { width : Int
    , height : Int
    }


type alias Token =
    { pubkey : String
    }


type alias Game =
    { name : String
    , description : String
    , website : String
    , x : String
    , nfts : List String
    , tokens : List String
    , genres : List String
    }
