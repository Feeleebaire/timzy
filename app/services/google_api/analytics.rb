module GoogleApi
  class Analytics
    require 'google/apis/analytics_v3'

    def initialize(team)
      @service = init_service(team.refresh_token)
    end

    private

    def init_service(refresh_token)
      client = GoogleApi::Connector.new("https://www.googleapis.com/auth/analytics.readonly").reauthorize!(refresh_token)
      service = Google::Apis::AnalyticsV3::AnalyticsService.new
      service.authorization = client
      return service
    end
  end
end
