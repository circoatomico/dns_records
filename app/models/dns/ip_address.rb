module Dns
  class IpAddress < ApplicationRecord
    has_many :ip_hostnames, dependent: :destroy
    has_many :hostnames, through: :ip_hostnames, dependent: :destroy

    accepts_nested_attributes_for :hostnames

    validates :ip, format: { with: /\A(?:\d{1,3}\.){3}\d{1,3}\z/, message: 'Must be a valid IPV4' }

    scope :included_hostnames, -> (included, excluded) {
      return if included.blank?

      included = included.split(',')
      excluded = excluded.split(',')

      where.not(hostnames: {hostname: excluded})
      .where(hostnames: {hostname: included})
      .group('ip_addresses.id')
      .having('COUNT(DISTINCT hostnames.hostname) = ?', included.count)
    }

    scope :excluded_hostnames, -> (excluded) {
      return if excluded.blank?

      excluded = excluded.split(',')

      where.not(id: IpAddress.joins(:hostnames).where(hostnames: {hostname: excluded}).pluck(:id))
    }
  end
end