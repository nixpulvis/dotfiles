module Dotfiles::Symlink
  extend Dotfiles

  # symlink all `.symlink` files.
  def self.link_all
    dot_puts "dotfiles are symlinking all .symlink files"
    Dir.glob("#{Dotfiles::PATH}/**/*.symlink") do |file|
      target = File.join ENV["HOME"], '.'+File.basename(file, File.extname(file))
      `rm #{target}` if File.exists? target
      `ln -s #{file} #{target}`
    end
  end
end