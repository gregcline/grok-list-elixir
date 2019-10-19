defmodule GrokStoreWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :grok_store,
    error_handler: GrokStoreWeb.Auth.ErrorHandler,
    module: GrokStoreWeb.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
