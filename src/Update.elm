module Update exposing (update)

import Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RotateIcons ->
            ( { model
                | icons =
                    (model.icons
                        |> List.drop 1
                    )
                        ++ [ List.head model.icons
                                |> Maybe.withDefault ""
                           ]
              }
            , Cmd.none
            )
