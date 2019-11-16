module Login exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MODEL


type alias Model =
    { email : String
    , password : String
    }


init : Model
init =
    { email = "", password = "" }



-- UPDATE


type Msg
    = EmailUpdate String
    | PasswordUpdate String
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        EmailUpdate email ->
            { model | email = email }

        PasswordUpdate password ->
            { model | password = password }

        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Sign in" ]
        , input [ type_ "email", placeholder "Email", value model.email, onInput EmailUpdate ] []
        , input [ type_ "password", placeholder "Password", value model.password, onInput PasswordUpdate ] []
        , button [] [ text "Log in" ]
        ]
