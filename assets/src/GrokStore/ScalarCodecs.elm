-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GrokStore.ScalarCodecs exposing (..)

import GrokStore.Scalar exposing (defaultCodecs)
import Json.Decode as Decode exposing (Decoder)


type alias Id =
    GrokStore.Scalar.Id


codecs : GrokStore.Scalar.Codecs Id
codecs =
    GrokStore.Scalar.defineCodecs
        { codecId = defaultCodecs.codecId
        }
