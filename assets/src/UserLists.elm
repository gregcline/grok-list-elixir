module UserLists exposing (..)

import Graphql.Http
import GrokStore.Object exposing (GrokList)
import RemoteData exposing (RemoteData)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , lists : RemoteData (Graphql.Http.Error (List GrokList)) (List GrokList)
    }
