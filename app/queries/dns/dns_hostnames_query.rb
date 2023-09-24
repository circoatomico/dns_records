module Dns
  class DnsHostnamesQuery

    def initialize(ips, params)
      @ips = ips
      @excluded = params.fetch(:excluded, [])
    end

    def call
      valid_hostnames = IpAddress.joins(:hostnames).where(id: @ips.pluck(:id)).pluck(:hostname)

      @hostnames = Hostname
        .joins(:ip_addresses)
        .where(ip_addresses: {id: @ips.pluck(:id)})
        .where(hostname: valid_hostnames)
        .where.not(hostname: @excluded )
        .group(:hostname, 'hostnames.id')
        .select('hostname, COUNT(DISTINCT ip_addresses.id) as count')

      @hostnames.map { |hostname| { hostname: hostname.hostname, count: hostname.count } }
    end
  end
end