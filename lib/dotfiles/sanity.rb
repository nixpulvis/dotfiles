require "yaml"
require "tempfile"

module Dotfiles::Sanity
  extend Dotfiles

  def self.has_brew?
    `which brew`
    return $?.success?
  end

  # Returns a merged array of all brews from `.brews` files.
  def self.brews
    arr = []
    Dir.glob("#{Dotfiles::PATH}/brews/*") do |file|
      arr = arr.concat IO.readlines(file).map { |l| l.gsub("\n","") }
    end
    return arr.uniq
  end

  def self.brew_all
    # update brew
    dot_puts "Updating Brew"
    `brew update`

    dot_puts "Brewing:"
    # install each brew in every category
    brews.each do |brew|
      dot_puts "\t #{brew}"

      # create tempfile for output of brew install
      stdout = Tempfile.new('STDOUT')
      system "brew install #{brew} > #{stdout.path} 2>&1"
      stdout = File.open(stdout.path, "r").read
      unless stdout =~ /already installed/
        puts stdout.red
      end
    end
  end

  def self.has_gem?
    `which gem`
    return $?.success?
  end

  # Returns a merged array of all gems from `.gems` files.
  def self.gems
    arr = []
    Dir.glob("#{Dotfiles::PATH}/gems/*") do |file|
      arr = arr.concat IO.readlines(file).map { |l| l.gsub("\n","") }
    end
    return arr.uniq
  end

  def self.gem_all
    dot_puts "Gem Install:"
    # install each brew in every category
    gems.each do |g|
      dot_puts "\t #{g}"
      system "gem install #{g}"
    end
  end
end