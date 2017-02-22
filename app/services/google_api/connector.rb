module GoogleApi
  class Connector
    require 'signet/oauth_2/client'

    attr_accessor :client

    def initialize(gscope)
      @client = Signet::OAuth2::Client.new(
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
        client_id: ENV['OAUTH_CLIENT_ID'],
        client_secret: ENV['OAUTH_CLIENT_SECRET'],
        scope: gscope,
        redirect_uri: 'http://localhost:3000/oauth2callback'
      )
    end

    def authorization_uri
      @client.authorization_uri.to_s
    end

    def init_refresh_token(authorization_code)
      @client.update!(
        code: authorization_code,
        additional_parameters: {"include_granted_scopes" => "true", "access_type" => "offline"}
      )
      # @client.fetch_access_token!['access_token'] gives you the access token
      return @client.fetch_access_token!['refresh_token']
    end

    def reauthorize!(refresh_token)
      @client.update!(refresh_token: refresh_token, grant_type: :refresh_token)
      access_token = @client.fetch_access_token!['access_token']
      @client.update!(access_token: access_token)
    end
  end
end
