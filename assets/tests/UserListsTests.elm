module UserListsTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import UserLists exposing (..)


testNoOp : Test
testNoOp =
    test "noop" <| \_ -> Expect.equal True True
