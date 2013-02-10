require "spec_helper"

describe Dotfiles do
  describe "::VERSION" do

    it "should be a String" do
      Dotfiles::VERSION.should be_a(String)
    end

    it "should have valid version numbers" do
      version = Dotfiles::VERSION.split('.')
      version.each do |part|
        expect { Integer(part) }.to_not raise_error
      end
    end

    it "should only have 3 parts" do
      Dotfiles::VERSION.split('.').should have(3).items
    end

  end
end