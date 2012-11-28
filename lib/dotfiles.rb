module Dotfiles

  PATH = File.expand_path File.join(File.dirname(__FILE__), "..")

  def dot_puts( s )
    puts ".:. ".magenta + s
  end

  def dot_warning( s )
    dot_puts "WARNING: #{s}".yellow
  end

  def dot_error( s )
    dot_puts "ERROR: #{s}".red
  end

end

require 'dotfiles/colorize'
require 'dotfiles/os'
require 'dotfiles/symlink'
require 'dotfiles/sanity'