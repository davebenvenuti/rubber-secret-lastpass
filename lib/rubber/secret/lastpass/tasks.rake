require 'rubber/secret/lastpass/cli'
require 'highline/import'
require 'rake'
require 'yaml'
require 'fileutils'

namespace :rubber do
  namespace :credentials do
    include Rubber::Secret::Lastpass::Cli

    task :fetch do
      contents = YAML.load(show(note_name, "notes"))

      save_rubber_secret contents
    end

    task :put do
      edit_from_file note_name, "notes", load_rubber_secret_filename

      puts "Updated Lastpass note #{note_name}"
    end

    task :set do
      Rake::Task['rubber:credentials:fetch'].reenable      
      Rake::Task['rubber:credentials:fetch'].invoke
      Rake::Task['rubber:credentials:fetch'].reenable

      rubber_secret_contents = load_rubber_secret

      key = get_env('ATTR')
      value = get_env('VALUE')

      rubber_secret_contents[key] = value

      save_rubber_secret rubber_secret_contents

      Rake::Task['rubber:credentials:put'].reenable
      Rake::Task['rubber:credentials:put'].invoke
      Rake::Task['rubber:credentials:put'].reenable      
    end

    def load_rubber_secret
      rubber_secret_file = load_rubber_secret_filename

      puts "Loading #{rubber_secret_file}"
      
      YAML.load(File.read(rubber_secret_file))
    end

    def save_rubber_secret(contents)
      rubber_secret_file = load_rubber_secret_filename

      puts "Saving #{rubber_secret_file}"

      FileUtils.mkdir_p File.dirname(rubber_secret_file) 
      File.open(rubber_secret_file, 'w') { |f| f.puts YAML.dump(contents) }
    end

    def load_rubber_secret_filename
      begin
        ENV['RAILS_ENV'] ||= rubber_env

        require 'rubber'
        require 'rails'

        root = Rails.root

        # This sucks
        Object.send :remove_const, :RUBBER_ROOT
        Object.send :remove_const, :RUBBER_ENV
        Object.send :remove_const, :RUBBER_CONFIG
        Object.send :remove_const, :RUBBER_INSTANCES

        Rubber::initialize(root, rubber_env)

        rubber_cfg = Rubber::Configuration.get_configuration(rubber_env)
        scoped_env = rubber_cfg.environment.bind(nil, nil)

        scoped_env.rubber_secret
      rescue LoadError
        rubber_secret_dir = get_env('RUBBER_SECRET_DIR')

        File.expand_path(File.join(rubber_secret_dir, '/rubber-secret.yml'))
      end      
    end

    def app_name
      begin
        ENV['RAILS_ENV'] ||= rubber_env

        require 'rubber'
        require 'rails'

        root = Rails.root

        Rubber::initialize(root, Rubber.env)

        rubber_cfg = Rubber::Configuration.get_configuration(Rubber.env)
        scoped_env = rubber_cfg.environment.bind(nil, nil)

        scoped_env.app_name
      rescue LoadError
        get_env('APP_NAME')
      end
    end
    
    def note_name
      unless defined?(@note_name)        
        @note_name = "#{app_name}-3rd-party-credentials-#{rubber_env}"
      end

      @note_name
    end

    def rubber_env
      get_env('RUBBER_ENV')
    end
    
    def get_env(var, prompt=nil, required=true)
      prompt = prompt || var

      if ENV[var].to_s.length > 0
        ENV[var]
      else
        val = ask "#{prompt}: "

        if var.length > 0
          ENV[var] = val

          val
        else
          $stderr.puts "Value required for #{var}"

          exit 1
        end
      end
    end
  end
end

