module Dns
  class IpHostname < ApplicationRecord
    belongs_to :ip_address
    belongs_to :hostname
  end
end