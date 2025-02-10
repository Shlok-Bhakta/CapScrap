class OauthController < ApplicationController
  allow_unauthenticated_access

  def authorize
    google_url = authorize_client.auth_code.authorize_url(
      redirect_uri: callback_oauth_url,
      scope: "openid email profile",
      access_type: "online",
    )
    redirect_to google_url, allow_other_host: true
  end

  private

  def authorize_client
    @authorize_client ||= OAuth2::Client.new(
      ENV["GOOGLE_CLIENT_ID"],
      ENV["GOOGLE_CLIENT_SECRET"],
      {
        site: "https://accounts.google.com",
        authorize_url: "/o/oauth2/auth",
      }
    )
  end
end