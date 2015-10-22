require 'rubber/secret/lastpass'
require 'rails'

class Rubber::Secret::Lastpass::Railtie < Rails::Railtie
  rake_tasks do
    require 'rubber/secret/lastpass/tasks.rake'
  end
end

