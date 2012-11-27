class String

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black; self.colorize(30); end
  def red; self.colorize(31); end
  def green; self.colorize(32); end
  def yellow; self.colorize(33); end
  def blue; self.colorize(34); end
  def magenta; self.colorize(35); end
  def cyan; self.colorize(36); end
  def white; self.colorize(37); end

end