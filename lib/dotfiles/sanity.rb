require "yaml"

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
    # install each brew in every category
    brews.each do |brew|
      dot_puts "dotfiles are brewing up: #{brew}"
      system "brew install #{brew}"
    end
  end
end