module Dns
  class DnsCreateQuery
    attr_reader :ip

    def initialize(params:)
      @ip = params.fetch(:ip)
      @hostnames_attributes = params.fetch(:hostnames_attributes)
    end

    def call
      ip_address = IpAddress.find_or_initialize_by(ip: @ip)

      @hostnames_attributes.each do |hostname|
        ip_address.hostnames << Hostname.find_or_create_by(hostname: hostname[:hostname])
      end

      ip_address.save!
      ip_address
    end
  end
end