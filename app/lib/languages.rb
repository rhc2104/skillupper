module Languages
  JAVASCRIPT = 'javascript'
  PYTHON = 'python'
  RUBY = 'ruby'

  def self.values
    constants(false).map{|c| const_get c }.sort
  end
end
