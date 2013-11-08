require "rseed/roo/version"
require "rseed/roo/roo_adapter"
require "rseed/roo/helpers"

module Rseed
  module Roo
    class Railtie < ::Rails::Railtie
      railtie_name :rseed_roo

      rake_tasks do
        load "tasks/rseed-roo.rake"
      end
    end
  end
end
