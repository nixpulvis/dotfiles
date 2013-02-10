module Dotfiles

  # Path to the dotfiles top level directory.
  PATH = File.expand_path File.join(File.dirname(__FILE__), "..")

  # Prefix to be printed before every message.
  PREFIX = ".:."


  # Printing methods: 
  # * inform : info about the build.
  # * warn   : non critical errors.
  # * error  : blocking errors.
  #
  # Use these methods for interacting with STDOUT exclusively,
  # to help keep the build process feel uniform.
  #
  def inform(string)
    puts "#{PREFIX.magenta} #{string}"
  end

  def warn(string)
    puts "#{PREFIX.magenta} WARNING: #{string}".yellow
  end

  def error(string)
    puts "#{PREFIX.magenta} ERROR: #{string}".red
  end

end

require "dotfiles/ext"
require "dotfiles/symlink"
require "dotfiles/version"

# Add Dotfiles into main :)
include Dotfiles