module Dotfiles

  SYMLINK_PATH = File.join PATH, "src", "symlink"

  def symlink(source, target, opts={})
    # Only support symlinking to a single file / folder
    unless target.is_a? String
      raise ArgumentError.new("target must be a string")
    end

    # Support symlinking an array of files.
    if source.is_a? Array
      source.each {|f| symlink f, target, opts }
    else
      flags = "-s" # the method is called symlink afterall.
      flags += "f" if opts[:force]
      flags += "v" if opts[:verbose]

      # source file must exist.
      unless File.exists? File.expand_path(source)
        raise Errno::ENOENT.new(source)
      end

      # target directory must exist.
      unless File.exists? File.dirname(target)
        raise Errno::ENOENT.new(File.dirname(target))
      end

      # if linking fails at this point it's because the file exists
      # and :force wasn't provided.
      quite_opts = { out: "/dev/null", err: "/dev/null" }
      unless system "ln #{flags} #{source} #{target}", quite_opts
        raise Errno::EEXIST.new(target)
      end
    end
  end

end