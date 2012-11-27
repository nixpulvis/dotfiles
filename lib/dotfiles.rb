module Dotfiles

  PATH = File.expand_path File.join(File.dirname(__FILE__), "..")

  def dot_puts( s )
    puts ".:. ".magenta + s
  end

end

require 'dotfiles/colorize'
require 'dotfiles/symlink'
require 'dotfiles/sanity'