module Main exposing (main)

import Browser
import Html
import Http
import Json.Decode as JD
import RemoteData


type News
    = BadNews
    | GoodNews


type alias Model =
    { news : RemoteData.WebData News
    }


type Msg
    = GotNews (RemoteData.WebData News)


decodeNews =
    JD.succeed BadNews


getNews =
    RemoteData.get
        { url = "https://bbc.co.uk"
        , expect = Http.expectJson (\a -> a) decodeNews
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNews result ->
            ( { model | news = result }, Cmd.none )


view : Model -> Html.Html msg
view model =
    case model.news of
        RemoteData.NotAsked ->
            Html.text "Initialising."

        RemoteData.Loading ->
            Html.text "Loading."

        RemoteData.Failure err ->
            Html.text "Error"

        RemoteData.Success news ->
            viewNews news


viewNews : News -> Html.Html msg
viewNews news =
    case news of
        BadNews ->
            Html.text "bad news"

        GoodNews ->
            Html.text "good news"


main =
    Browser.element
        { init =
            \() ->
                ( { news = RemoteData.NotAsked
                  }
                , getNews
                )
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }
