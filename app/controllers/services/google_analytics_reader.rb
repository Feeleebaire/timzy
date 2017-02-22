class GoogleAnalyticsReader
  require 'google/apis/analyticsreporting_v4'

  def initialize(client)
    @client = client
  end

  private
end
