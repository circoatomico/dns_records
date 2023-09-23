module Dns
  class DnsRecordsQuery

    def initialize(params: nil)
      @page = params.fetch(:page, 1)
      @per_page = 10
      @included_hostnames = params[:included]
      @excluded_hostnames = params.fetch(:excluded, [])
    end

    def call

      @dns_records = IpAddress
        .joins(:hostnames)
        .exclude_hostnames(@excluded_hostnames)
        .include_hostnames(@included_hostnames)
        .distinct
        .order(:id)
        .page(@page)
        .per(@per_page)
    end
  end
end