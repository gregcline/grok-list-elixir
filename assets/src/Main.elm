module Main exposing (PageModel(..), Route(..), decodeApiUrl, main, pageBody, pageTitle, parseRoute, setPage)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Login
import Session
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
    , session : Session.Session
    }


type PageModel
    = LoginPage Login.Model
    | UserLists UserLists.Model
    | OtherPage


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

        session =
            { api = apiUrl
            , token = Nothing
            }
    in
    ( { key = key
      , url = url
      , pageModel = url |> parseRoute |> setPage session
      , session = session
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

        ( LoginMsg (Login.CompletedLogin token), LoginPage loginModel ) ->
            let
                sessionToken =
                    Session.extractToken token

                sessionModel =
                    model.session

                session =
                    { sessionModel | token = sessionToken }
            in
            ( { model | session = session }, Cmd.none )

        ( LoginMsg loginMsg, LoginPage loginModel ) ->
            let
                ( newLoginModel, newLoginCmd ) =
                    Login.update loginMsg loginModel
            in
            ( { model | pageModel = LoginPage newLoginModel }, Cmd.map LoginMsg newLoginCmd )

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


setPage : Session.Session -> Route -> PageModel
setPage session route =
    case route of
        LoginRoute ->
            LoginPage (Login.init session)

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
