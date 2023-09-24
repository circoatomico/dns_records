module Dns
  class DnsIpAddressesQuery

    def initialize(params:)
      @page = params[:page] || 1
      @per_page = 10
      @included = params.fetch(:included, [])
      @excluded = params.fetch(:excluded, [])
    end

    def call
      @ips = IpAddress
        .joins(:hostnames)
        .included_hostnames(@included, @excluded)
        .excluded_hostnames(@excluded)
        .distinct
        .order(:id)
        .page(@page)
        .per(@per_page)

      @ips.map { |ip| { id: ip.id, ip_address: ip.ip } }
    end
  end
end