module Session exposing (..)

import Graphql.Http
import RemoteData exposing (RemoteData(..))
import Url


type alias Session =
    { api : Maybe Url.Url
    , token : Maybe String
    }


type alias Token =
    { token : Maybe String }


emptySession : Session
emptySession =
    { api = Nothing, token = Nothing }


apiUrl : Session -> String
apiUrl session =
    case session.api of
        Just url ->
            Url.toString url

        Nothing ->
            "http://localhost:4000/api"


extractToken : RemoteData (Graphql.Http.Error (Maybe Token)) (Maybe Token) -> Maybe String
extractToken response =
    case response of
        NotAsked ->
            Nothing

        Loading ->
            Nothing

        Failure _ ->
            Nothing

        Success (Just token) ->
            token.token

        Success Nothing ->
            Nothing
