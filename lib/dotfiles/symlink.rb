module Dotfiles::Symlink
  extend Dotfiles

  # symlink all `.symlink` files.
  def self.link_all
    Dir.glob("#{Dotfiles::PATH}/**/*.symlink") do |file|
      target = File.join ENV["HOME"], '.'+File.basename(file, File.extname(file))
      `rm #{target}` if File.exists? target
      `ln -s #{file} #{target}`
      dot_puts "symlinking:\t #{File.basename(file)}"
    end
  end
end