class BaseBlueprint < Blueprinter::Base
  class << self
    private

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
