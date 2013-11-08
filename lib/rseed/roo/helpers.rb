require 'colorize'

module Rseed
  def from_excel(file, options = {})
    options[:adapter] = :roo
    from_file(file, options)
  end

  module_function :from_excel
end