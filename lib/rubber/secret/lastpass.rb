require "rubber/secret/lastpass/version"

if defined?(Rails) && defined?(Rails::Railtie)
  require 'rubber/secret/lastpass/railtie'
else
  load "rubber/secret/lastpass/tasks.rake"
end

module Rubber
  module Secret
    module Lastpass
    end
  end
end

