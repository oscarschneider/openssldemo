#
# Cookbook Name:: openssl
# Library:: decrypt_secret
# Author:: Bastian Neuburger <b.neuburger@gsi.de>
#
# Copyright 2012
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'openssl'
require 'base64'

module Opscode
  module OpenSSL
    module Secret
      def decrypt_secret(ciphertext)
        secret = String.new
        
        private_key = ::OpenSSL::PKey::RSA.new(File.read('/etc/chef/client.pem'))
        secret = private_key.private_decrypt(Base64.decode64(ciphertext))
        
        secret
      end
    end
  end
end
