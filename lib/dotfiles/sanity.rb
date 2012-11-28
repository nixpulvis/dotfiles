require "yaml"
require "tempfile"

module Dotfiles::Sanity
  extend Dotfiles

  def self.has_brew?
    `which brew`
    return $?.success?
  end

  # Returns a merged array of all brews from `.brew` files.
  def self.brews
    arr = []
    Dir.glob("#{Dotfiles::PATH}/**/*.brew") do |file|
      arr = arr.concat IO.readlines(file).map { |l| l.gsub("\n","") }
    end
    return arr.uniq
  end

  def self.brew_all

    # update brew
    dot_puts "updating brew"
    `brew update`

    # install each brew in every category
    brews.each do |brew|
      dot_puts "brewing up:\t #{brew}"

      # create tempfile for output of brew install
      stdout = Tempfile.new('STDOUT')
      system "brew install #{brew} > #{stdout.path} 2>&1"
      stdout = File.open(stdout.path, "r").read
      unless stdout =~ /already installed/
        puts stdout.red
      end
    end
  end
end