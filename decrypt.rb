#!/usr/bin/env ruby
# Warning: quick and dirty hack, should do if you have installed the openssl/base64 gems

require 'openssl'
require 'base64'

usage = "./decrypt.rb PATH_TO_PRIVATE_KEY_FILE PATH_TO_ENCRYPTED_FILE"
unless ARGV.length == 2
  puts usage
  exit 1
end

# We read the private key from the file that was the first argument
private_key = ::OpenSSL::PKey::RSA.new(File.read(ARGV[0]))

# And then first Base64 decode the file containing the ciphertext,
# then decrypt it with the private key.
plaintext   = private_key.private_decrypt(Base64.decode64(File.read(ARGV[1])))

puts plaintext
