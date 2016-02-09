require 'rubber/secret/lastpass'
require 'rails'

class Rubber::Secret::Lastpass::Railtie < Rails::Railtie
  rake_tasks do
    load 'rubber/secret/lastpass/tasks.rake'
  end
end

