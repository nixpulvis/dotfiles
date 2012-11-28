module Dotfiles::OS
  extend Dotfiles

  def self.is_mac?
    RUBY_PLATFORM.downcase.include?("darwin")
  end

  def self.is_windows?
    RUBY_PLATFORM.downcase.include?("mswin")
  end

  def self.is_linux?
    RUBY_PLATFORM.downcase.include?("linux")
  end

end