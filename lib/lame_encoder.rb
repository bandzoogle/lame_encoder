require "lame_encoder/version"

module Lame
  code_path = File.join(File.dirname(__FILE__))
  require "#{code_path}/lame_encoder/encoder"
end
