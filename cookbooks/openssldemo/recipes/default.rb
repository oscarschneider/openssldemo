include_recipe 'openssl'

# Include the Opscode::OpenSSL::Secret Module defined in cookbook openssl/libraries/decrypt_secret
::Chef::Recipe.send(:include, Opscode::OpenSSL::Secret)

# Simply call decrypt_secret on an attribute whose content
# was encrypted using knife node secret add NODE PLAINTEXT ATTRIBUTE, e.g.

plaintext = decrypt_secret(node[:openssldemo])

file '/tmp/itworks' do
  content ( plaintext.inspect + "\n" + "Encrypted attribute:\n" + node[:openssldemo].inspect)
end
