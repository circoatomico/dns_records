module Dns
  class IpAddress < ApplicationRecord
    has_many :ip_hostnames, dependent: :destroy
    has_many :hostnames, through: :ip_hostnames, dependent: :destroy

    accepts_nested_attributes_for :hostnames

    scope :exclude_hostnames, ->(excluded_hostname) {
      return if excluded_hostname.blank?

      where.not(hostnames: { hostname: excluded_hostname.split(',') })
    }

    scope :include_hostnames, ->(included_hostnames) {

      included_hostnames = included_hostnames.split(',')

      where(hostnames: { hostname: included_hostnames })
    }
  end
end