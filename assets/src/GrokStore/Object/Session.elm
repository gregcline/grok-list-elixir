-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GrokStore.Object.Session exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import GrokStore.InputObject
import GrokStore.Interface
import GrokStore.Object
import GrokStore.Scalar
import GrokStore.ScalarCodecs
import GrokStore.Union
import Json.Decode as Decode


token : SelectionSet (Maybe String) GrokStore.Object.Session
token =
    Object.selectionForField "(Maybe String)" "token" [] (Decode.string |> Decode.nullable)
