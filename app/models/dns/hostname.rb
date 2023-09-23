module Dns
  class Hostname < ApplicationRecord
    has_many :ip_hostnames
    has_many :ip_addresses, through: :ip_hostnames

    validates :hostname, presence: true, uniqueness: true
  end
end