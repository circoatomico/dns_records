module Api
  module V1
    class DnsRecordsController < ApplicationController
      before_action :validate_page, only: :index

      def index
        @ips = Dns::DnsIpAddressesQuery.new(params: dns_params).call
        @hostnames = Dns::DnsHostnamesQuery.new(@ips, dns_params).call

        dns_records = {
          total_records: @ips.size,
          records: @ips,
          related_hostnames: @hostnames
        }

        render json: dns_records, head: :ok
      end

      def create
        dns = Dns::DnsCreateQuery.new(params: create_dns_params).call

        render json: dns.id, status: :created
      rescue => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end

      private

      def validate_page
        render json: { error: 'page is required' }, status: :unprocessable_entity if params[:page].blank?
      end

      def dns_params
        params.permit(:included, :excluded, :page)
      end

      def create_dns_params
        params.require(:dns_records).permit(:dns_records, :ip, hostnames_attributes: [:hostname])
      end
    end
  end
end
