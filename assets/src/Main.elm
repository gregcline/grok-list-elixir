module Main exposing (PageModel(..), Route(..), decodeApiUrl, main, pageBody, pageTitle, parseRoute, setPage)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Login
import Url
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string)



-- MAIN


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , pageModel : PageModel
    , session : Session
    }


type PageModel
    = LoginPage Login.Model
    | OtherPage


type alias Session =
    { api : Maybe Url.Url
    , token : Maybe String
    }


init : Decode.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        apiUrl =
            case decodeApiUrl flags of
                Ok decodedApiUrl ->
                    decodedApiUrl

                Err error ->
                    let
                        _ =
                            Debug.log <| Decode.errorToString error
                    in
                    Nothing
    in
    ( { key = key
      , url = url
      , pageModel = url |> parseRoute |> setPage
      , session =
            { api = apiUrl
            , token = Nothing
            }
      }
    , Cmd.none
    )


decodeApiUrl : Decode.Value -> Result Decode.Error (Maybe Url.Url)
decodeApiUrl value =
    value
        |> Decode.decodeValue apiUrlDecoder
        |> Result.map Url.fromString


apiUrlDecoder : Decode.Decoder String
apiUrlDecoder =
    Decode.field "api" Decode.string



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginMsg Login.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageModel ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            ( { model | url = url, pageModel = OtherPage }
            , Cmd.none
            )

        ( LoginMsg loginMsg, LoginPage loginModel ) ->
            ( { model | pageModel = Login.update loginMsg loginModel |> LoginPage }, Cmd.none )

        _ ->
            ( model, Cmd.none )


parseRoute : Url.Url -> Route
parseRoute routeStr =
    parse routeParser routeStr
        |> setRoute


setRoute : Maybe Route -> Route
setRoute parsed =
    Maybe.withDefault OtherRoute parsed


type Route
    = LoginRoute
    | OtherRoute


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map LoginRoute (s "login")
        ]


setPage : Route -> PageModel
setPage route =
    case route of
        LoginRoute ->
            LoginPage Login.init

        OtherRoute ->
            OtherPage



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = pageTitle model.pageModel
    , body = pageBody model.pageModel
    }


pageTitle : PageModel -> String
pageTitle page =
    case page of
        LoginPage _ ->
            "Grok Store - Login"

        OtherPage ->
            "Grok Store - 404"


pageBody : PageModel -> List (Html Msg)
pageBody pageModel =
    case pageModel of
        LoginPage model ->
            [ Html.map LoginMsg (Login.view model) ]

        OtherPage ->
            [ a [ href "/login" ] [ text "Log in" ] ]
