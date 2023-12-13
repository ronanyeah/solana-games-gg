module View exposing (view)

import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FlatColors.FlatUIPalette
import Helpers.View exposing (cappedWidth, when, whenAttr)
import Html exposing (Html)
import Html.Attributes
import Img
import Maybe.Extra exposing (unwrap)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view model =
    viewBody model
        |> Element.layoutWith
            { options =
                [ Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            [ width fill
            , height fill
            , Background.color colors.background
            , mainFont
            ]


viewBody model =
    [ viewHeader model
    , viewTable model
    ]
        |> column
            [ centerX
            , cappedWidth 1440
            , padding (fork (model.isMobile || model.isShort) 15 50)
            , height fill
            , spacing (fork (model.isMobile || model.isShort) 10 30)
            ]


viewHeader model =
    [ [ text
            (model.icons
                |> List.head
                |> Maybe.withDefault ""
            )
      , text "SOLANA GAMES ://"
            |> el [ Font.underline, Font.size (fork model.isMobile 17 27) ]
      ]
        |> row
            [ displayFont
            , spacing 14
            , alignTop
            , Font.size 30
            , Font.bold
            , Font.color white
            ]
    , [ para [ Font.bold, Font.size 22, monospaceFont ] "#OPOS - Only playable on Solana"
      , para [ Font.size 17 ] "All the Solana games that can be played on Mainnet right now."
      , [ newTabLink
            [ hover
            , Font.size 17
            , Font.underline
            ]
            { label = text "More resources"
            , url = "https://gist.github.com/ronanyeah/8c3cc143fb6e8ddc73983b8f60ec0a1e"
            }
        , newTabLink
            [ hover
            , Font.size 17
            , Font.underline
            ]
            { label = text "Submit a game"
            , url = "https://github.com/ronanyeah/solana-games-gg"
            }
        ]
            |> row [ spacing 10 ]
      ]
        |> column
            [ spacing 10
            , paddingXY 15 10
            , Background.color white
            , Border.rounded 5
            , Border.color colors.accent1
            , Border.width 4
            , cappedWidth 450
                |> whenAttr (not model.isMobile)
            ]
    ]
        |> fork model.isMobile column row [ spacing 20 ]


viewTable model =
    let
        hdr =
            text >> el [ Font.bold, monospaceFont ]

        cols =
            [ { header = hdr "Name"
              , view =
                    .name
                        >> text
                        >> el [ paddingXY 10 0 ]
                        >> el
                            [ Border.widthEach
                                { bottom = 0
                                , left = 4
                                , right = 0
                                , top = 0
                                }
                            , height fill
                            ]
              , width = fill
              }
            , { header = hdr "Website"
              , view =
                    \game ->
                        [ newTabLink
                            [ hover
                            , Font.size 15
                            , Font.underline
                            , title game.website
                            ]
                            { label =
                                game.website
                                    |> String.replace "https://" ""
                                    |> String.replace "www." ""
                                    |> trim 25
                                    |> text
                            , url = game.website
                            }
                        , newTabLink [ hover, padding 4, Border.width 1 ]
                            { label = Img.x 17
                            , url = "https://x.com/" ++ game.x
                            }
                        ]
                            |> row [ spacing 10 ]
              , width = fill
              }
            , { header = hdr "Description"
              , view =
                    .description
                        >> text
                        >> List.singleton
                        >> paragraph []
              , width = px 250
              }
            , { header = hdr "Genre"
              , view =
                    .genres
                        >> String.join ", "
                        >> text
                        >> el [ Font.italic ]
              , width = fill
              }
            , { header = hdr "NFTs"
              , view =
                    \game ->
                        if List.isEmpty game.nfts then
                            text "-"

                        else
                            game.nfts
                                |> List.map
                                    (\tnsr ->
                                        let
                                            url =
                                                "https://www.tensor.trade/trade/" ++ tnsr
                                        in
                                        newTabLink
                                            [ hover
                                            , Font.size 15
                                            , Font.underline
                                            , Border.rounded 20
                                            , Background.color colors.secondary
                                            , height <| px 40
                                            , width <| px 40
                                            , title url
                                            , Background.image
                                                (Dict.get tnsr model.nftIcons
                                                    |> Maybe.withDefault ""
                                                )
                                            , Border.width 2
                                            ]
                                            { url = url
                                            , label = none
                                            }
                                    )
                                |> row [ spacing 10 ]
              , width = fill
              }
            , { header = hdr "Tokens"
              , view =
                    \game ->
                        if List.isEmpty game.tokens then
                            text "-"

                        else
                            game.tokens
                                |> List.map
                                    (\tk ->
                                        newTabLink
                                            [ hover
                                            , Font.underline
                                            ]
                                            { label = text ("$" ++ tk)
                                            , url =
                                                "https://solscan.io/token/"
                                                    ++ (model.tokens
                                                            |> Dict.get tk
                                                            |> unwrap "???" .pubkey
                                                       )
                                            }
                                    )
                                |> column [ spacing 10 ]
              , width = fill
              }
            ]
    in
    [ if model.isMobile then
        model.games
            |> List.map
                (\game ->
                    cols
                        |> List.map
                            (\col ->
                                [ col.header, col.view game ]
                                    |> column [ spacing 10 ]
                            )
                        |> column [ spacing 20 ]
                )
            |> List.intersperse
                ([ horizRule
                 , model.icons
                    |> List.head
                    |> Maybe.withDefault ""
                    |> text
                    |> el [ centerX, Font.size 25 ]
                 , horizRule
                 ]
                    |> row [ width fill, spacing 10 ]
                )
            |> column [ spacing 40, height fill, scrollbarY ]

      else
        table [ spacing 40, height fill, scrollbarY ]
            { columns = cols
            , data = model.games
            }
    ]
        |> column
            [ Background.color white
            , Border.color colors.accent1
            , Border.width 4
            , height fill
            , width fill
            , Border.rounded 10
            , padding 20
            , scrollbarX
                |> whenAttr (not model.isMobile)
            ]


colors =
    { background = FlatColors.FlatUIPalette.midnightBlue
    , primary = FlatColors.FlatUIPalette.wisteria
    , secondary = FlatColors.FlatUIPalette.belizeHole
    , accent1 = FlatColors.FlatUIPalette.pomegranate
    , accent2 = FlatColors.FlatUIPalette.asbestos
    , text = FlatColors.FlatUIPalette.clouds
    , highlight = FlatColors.FlatUIPalette.amethyst
    }


white : Color
white =
    rgb255 255 255 255


black : Color
black =
    rgb255 0 0 0


monospaceFont =
    Font.family [ Font.monospace ]


mainFont =
    Font.family [ Font.typeface "Roboto" ]


displayFont =
    Font.family [ Font.typeface "Press Start 2P" ]


hover : Attribute msg
hover =
    Element.mouseOver [ fade ]


fade : Element.Attr a b
fade =
    Element.alpha 0.7


title : String -> Attribute msg
title v =
    Html.Attributes.title v
        |> htmlAttribute


trim n str =
    if String.length str > n then
        String.left (n - 3) str ++ "..."

    else
        str


para attrs =
    text >> List.singleton >> paragraph attrs


horizRule =
    el [ height <| px 5, Background.color black, width fill ] none


fork bl a b =
    if bl then
        a

    else
        b
