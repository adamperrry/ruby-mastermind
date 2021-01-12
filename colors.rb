# monkey patch String class to colorize text
class String
  def red
    "\e[91m#{self}\e[0m"
  end

  def green
    "\e[92m#{self}\e[0m"
  end

  def yellow
    "\e[93m#{self}\e[0m"
  end

  def blue
    "\e[94m#{self}\e[0m"
  end

  def purple
    "\e[95m#{self}\e[0m"
  end

  def cyan
    "\e[96m#{self}\e[0m"
  end

  def white
    "\e[97m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end
