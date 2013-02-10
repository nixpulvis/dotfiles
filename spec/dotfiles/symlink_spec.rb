require "spec_helper"
require "fileutils"

describe Dotfiles do
  describe "#symlink" do

    before :each do
      @path = "/tmp/dotfiles_spec"
      FileUtils.mkdir @path
      FileUtils.mkdir File.join @path, "src"
      FileUtils.mkdir File.join @path, "target"
      FileUtils.touch File.join @path, "src", "foo"
      FileUtils.touch File.join @path, "src", "bar"
      FileUtils.touch File.join @path, "src", "baz"
      FileUtils.touch File.join @path, "src", "quaz"
      @files = Dir["#{@path}/**/*"].select {|p| File.file? p }
      @file  = @files[0]
    end

    after :each do
      FileUtils.rm_rf @path
    end

    it "should create a symbolic link" do
      link = File.join(@path, "target", "linked")
      symlink @file, link
      File.symlink?(link).should be_true
    end

    it "should handle an array of source files" do
      symlink @files, File.join(@path, "target")
      @files.each do |f|
        File.symlink?(File.join(@path, "target", File.basename(f))).should be_true
      end
    end

    it "should complain if source does not exist" do
      expect { symlink "/this/is/not/a/file", "/tmp/foo" }.to raise_error(Errno::ENOENT)
    end

    it "should not link to a non existent directory" do
      expect { symlink @file, File.join(@path, "nope", @file) }.to raise_error(Errno::ENOENT)
    end

    it "should not overwrite file without :force" do
      expect { symlink @file, @files[1] }.to raise_error(Errno::EEXIST)
    end

    it "should overwrite file with :force" do
      expect { symlink @file, @files[1], force: true }.to_not raise_error(Errno::EEXIST)
    end

  end
end