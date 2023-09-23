module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index

        @dns_records = Dns::DnsRecordsQuery.new(params: get_dns_params).call

        included_param = get_dns_params.fetch(:included, Dns::Hostname.all.pluck(:hostname) )
        excluded_param = get_dns_params.fetch(:excluded, [] )

        # considerar todos, inclusive os que não estao na paginação, talvez
        @related_hostnames =
          Dns::Hostname
            .joins(:ip_addresses)
            .where(ip_addresses: {id: @dns_records.pluck(:id)})
            .where(hostname: included_param.split(','))
            .where.not(hostname: excluded_param )
            .group(:hostname, 'hostnames.id')
            .select('hostname, COUNT(*) as count')
            .order('hostnames.id asc')

        response_data = {
          total_records: @dns_records.count,
          records: @dns_records.map { |ip| { id: ip.id, ip_address: ip.ip } },
          related_hostnames: @related_hostnames.map { |hostname| { hostname: hostname.hostname, count: hostname.count } }
        }

        render json: response_data
      end

      # POST /dns_records
      def create

        ip_params = params.require(:dns_records).permit(:ip, hostnames_attributes: [:hostname])

        ip = Dns::IpAddress.find_or_initialize_by(ip: ip_params[:ip])

        ip_params[:hostnames_attributes].each do |hostname|
          ip.hostnames << Dns::Hostname.find_or_create_by(hostname: hostname[:hostname])
        end

        if ip.save
          render json: ip.id, status: :created
        else
          render json: { errors: ip.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def get_dns_params
        params.permit(:included, :excluded, :page)
      end

      def dns_record_params
        params.require(:dns_record).permit(:ip, hostnames_attributes: [:hostname])
      end
    end
  end
end
