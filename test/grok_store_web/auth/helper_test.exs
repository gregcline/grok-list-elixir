defmodule GrokStoreWeb.Auth.HelperTest do
  use GrokStoreWeb.ConnCase
  alias GrokStoreWeb.Auth.Helper
  alias GrokStore.Accounts
  alias GrokStore.Accounts.User

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "Glorfindel",
        email: "elf-lord@rivendell.io",
        password: "mellon"
      })

    {:ok, user: %User{user | password: nil}}
  end

  describe "login_with_email_pass" do
    test "validates a user with correct credentials", %{user: user} do
      assert {:ok, user} ==
               Helper.login_with_email_pass("elf-lord@rivendell.io", "mellon")
    end

    test "rejects a user with incorrect password", %{user: _user} do
      assert {:error, "invalid password"} ==
               Helper.login_with_email_pass("elf-lord@rivendell.io", "foo")
    end

    test "rejects a non-existent user" do
      assert {:error, "invalid user-identifier"} ==
               Helper.login_with_email_pass("foo@bar.com", "foo")
    end
  end
end
