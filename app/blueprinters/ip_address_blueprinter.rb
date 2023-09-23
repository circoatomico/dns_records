module Api
  module V1
    class IpAddressBlueprinter < Blueprinter::Base
      identifier :id

      fields :ip

      # association :users, blueprint: UserBlueprint

      # view :pagination do
      #   field :total_users do |group, _|
      #     group.users.count
      #   end

      #   association :users, blueprint: UserBlueprint do |group, _|
      #     group.users.limit(3)
      #   end
      # end
    end
  end
end
