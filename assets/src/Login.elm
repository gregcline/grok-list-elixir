module Login exposing (Model, Msg(..), init, makeLoginRequest, update, view)

import Graphql.Http
import Graphql.Operation as Operation
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet(..))
import GrokStore.Mutation as Mutation
import GrokStore.Object exposing (Session(..))
import GrokStore.Object.Session as SessionObject
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import RemoteData exposing (RemoteData(..))
import Session exposing (Session, Token, apiUrl, extractToken)
import Url



-- MODEL


type alias Model =
    { email : String
    , password : String
    , session : Session
    }


init : Session -> Model
init session =
    { email = "", password = "", session = session }


login : String -> String -> SelectionSet (Maybe Token) Operation.RootMutation
login email password =
    SelectionSet.map Token SessionObject.token
        |> Mutation.login { email = email, password = password }


makeLoginRequest : String -> String -> String -> Cmd Msg
makeLoginRequest email password url =
    login email password
        |> Graphql.Http.mutationRequest url
        |> Graphql.Http.send (RemoteData.fromResult >> CompletedLogin)



-- UPDATE


type Msg
    = EmailUpdate String
    | PasswordUpdate String
    | Submit
    | CompletedLogin (RemoteData (Graphql.Http.Error (Maybe Token)) (Maybe Token))
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdate email ->
            ( { model | email = email }, Cmd.none )

        PasswordUpdate password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, makeLoginRequest model.email model.password (apiUrl model.session) )

        CompletedLogin response ->
            case response of
                NotAsked ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                Failure err ->
                    ( model, Cmd.none )

                Success token ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Sign in" ]
        , input [ type_ "email", placeholder "Email", value model.email, onInput EmailUpdate ] []
        , input [ type_ "password", placeholder "Password", value model.password, onInput PasswordUpdate ] []
        , button [ onClick Submit ] [ text "Log in" ]
        ]
