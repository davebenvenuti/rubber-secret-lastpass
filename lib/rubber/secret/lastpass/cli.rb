require 'rubber/secret/lastpass'
require 'cocaine'
require 'open3'

module Rubber::Secret::Lastpass::Cli
  def show(name, field)
    cli true, "show --#{field} #{name}"
  end

  def edit_from_file(name, field, filename)
    edit_cmd = cli false, "edit --non-interactive --#{field} #{name}"

    r, w = IO.pipe
    Open3.pipeline "cat #{filename}", edit_cmd, out: w
    w.close

    output = r.read

    cli true, "sync"

    output
  end

  def login_setup?
    Dir.exists?(File.expand_path('~/.lastpass'))
  end

  protected

  def cli(run, *args)
    begin
      line = Cocaine::CommandLine.new("lpass", *args.join(' '))
      cmd = line.command

      if run
        line.run
      else
        cmd
      end
    rescue Cocaine::CommandNotFoundError
      $stderr.puts "Please install lastpass-cli https://github.com/lastpass/lastpass-cli"

      exit 1
    end
  end
end

