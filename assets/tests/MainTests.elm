module MainTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Html
import Html.Attributes exposing (placeholder, type_, value)
import Json.Decode as Decode
import Login
import Main exposing (..)
import Session exposing (emptySession)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, tag, text)
import Url


parseRouteTests : Test
parseRouteTests =
    describe "parseRoute"
        [ test "/login returns Login" <|
            \_ ->
                "http://localhost/login"
                    |> Url.fromString
                    |> Maybe.map parseRoute
                    |> Expect.equal (Just LoginRoute)
        , fuzz string "anything else is Other" <|
            \str ->
                "http://localhost/"
                    ++ str
                    |> Url.fromString
                    |> Maybe.map parseRoute
                    |> Expect.equal (Just OtherRoute)
        ]


setPageTests : Test
setPageTests =
    describe "setPage"
        [ test "sets the page model to LoginPage" <|
            \_ ->
                LoginRoute
                    |> setPage emptySession
                    |> Expect.equal (LoginPage (Login.init emptySession))
        , test "sets the page model to OtherPage" <|
            \_ ->
                OtherRoute
                    |> setPage emptySession
                    |> Expect.equal OtherPage
        ]


pageTitleTests : Test
pageTitleTests =
    describe "pageTitle"
        [ test "returns the login title" <|
            \_ ->
                LoginPage (Login.init emptySession)
                    |> pageTitle
                    |> Expect.equal "Grok Store - Login"
        , test "returns the 404 title" <|
            \_ ->
                OtherPage
                    |> pageTitle
                    |> Expect.equal "Grok Store - 404"
        ]


decodeApiUrlTests : Test
decodeApiUrlTests =
    describe "decodeApiUrl"
        [ test "returns a URL if properly formatted" <|
            \_ ->
                "{ \"api\": \"http://localhost:4000/api\"  }"
                    |> Decode.decodeString Decode.value
                    |> Result.andThen decodeApiUrl
                    |> Expect.equal (Ok (Url.fromString "http://localhost:4000/api"))
        , fuzz string "returns an error otherwise" <|
            \jsonStr ->
                jsonStr
                    |> Decode.decodeString Decode.value
                    |> Result.andThen decodeApiUrl
                    |> Expect.err
        ]
