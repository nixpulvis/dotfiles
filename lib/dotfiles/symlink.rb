module Dotfiles::Symlink
  extend Dotfiles

  # add a dot to the front of every file, if needed.
  def self.dottify( file )
    unless file[0..0] == '.' # fucking ruby 1.8.7
      file.insert 0, '.'
    else
      file
    end
  end

  # symlink files.
  def self.link_all
    dot_puts "Symbolic Linking:"
    Dir.glob("#{Dotfiles::PATH}/symlinks/*") do |file|
      target = File.join ENV["HOME"], dottify(File.basename(file))
      `rm #{target}` if File.exists? target
      `ln -s #{file} #{target}`
      dot_puts "\t #{target}"
    end
  end
end