module LoginTests exposing (updateTests, viewTests)

import Expect exposing (Expectation)
import Html.Attributes exposing (placeholder, type_, value)
import Login exposing (..)
import Session exposing (Session, emptySession)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, tag, text)


viewTests : Test
viewTests =
    describe "view"
        [ test "should have an email field" <|
            \_ ->
                emptySession
                    |> init
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "email") ]
                    |> Query.has [ attribute (placeholder "Email") ]
        , test "should have a password field" <|
            \_ ->
                emptySession
                    |> init
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "password") ]
                    |> Query.has [ attribute (placeholder "Password") ]
        , test "should have a submit button" <|
            \_ ->
                emptySession
                    |> init
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ tag "button" ]
                    |> Query.has [ text "Log in" ]
        , test "should have the email value from the model" <|
            \_ ->
                { email = "foo@bar", password = "", session = emptySession }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "email") ]
                    |> Query.has [ attribute (value "foo@bar") ]
        , test "should have the password value from the model" <|
            \_ ->
                { email = "foo@bar", password = "my_pass", session = emptySession }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "password") ]
                    |> Query.has [ attribute (value "my_pass") ]
        , test "should send the EmailUpdate message on input" <|
            \_ ->
                emptySession
                    |> init
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "email") ]
                    |> Event.simulate (Event.input "foo")
                    |> Event.expect (EmailUpdate "foo")
        , test "should send the PasswordUpdate message on input" <|
            \_ ->
                emptySession
                    |> init
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ attribute (type_ "password") ]
                    |> Event.simulate (Event.input "my_pass")
                    |> Event.expect (PasswordUpdate "my_pass")
        ]


updateTests : Test
updateTests =
    describe "update"
        [ test "should set the email when given the EmailUpdate message" <|
            \_ ->
                emptySession
                    |> init
                    |> update (EmailUpdate "foo@bar.com")
                    |> Expect.equal ( { email = "foo@bar.com", password = "", session = emptySession }, Cmd.none )
        , test "should set the password when given the PasswordUpdate message" <|
            \_ ->
                emptySession
                    |> init
                    |> update (PasswordUpdate "my_pass")
                    |> Expect.equal ( { email = "", password = "my_pass", session = emptySession }, Cmd.none )

        -- , test "should send a Login Cmd when Submit is sent" <|
        --     \_ ->
        -- emptySession
        -- |> init
        --             |> update Submit
        --             |> Expect.equal ({ email = "", password = "" }, makeLoginRequest "" "")
        , test "should make no changes when given the NoOp message" <|
            \_ ->
                emptySession
                    |> init
                    |> update NoOp
                    |> Expect.equal ( init emptySession, Cmd.none )
        ]
