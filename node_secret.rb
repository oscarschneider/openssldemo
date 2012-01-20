require 'chef/knife'

class Chef
  class Knife
    class NodeSecretAdd < Knife

      deps do
        require 'openssl'
        require 'base64'
      end
      
      banner "knife node secret add [NODE] [PLAINTEXT] [ATTRIBUTE]"

      option :print_ciphertext,
      :short => "-p",
      :long => "--print-ciphertext",
      :boolean => true,
      :description => "Also print the ciphertext to STDOUT"

      option :dry_run,
      :short => "-d",
      :long => "--dry-run",
      :boolean => true,
      :description => "Just check what would be done"

      def run
        unless name_args.length == 3
          show_usage
          exit 1
        else
          @nodename = @name_args[0]
          @plaintext = @name_args[1]
          @attribute = @name_args[2]
        end

        # our encryption key is looked up at the client with the same name
        # as the node we want to deal with, since this is the most probable
        # public key for which the corresponding private key is also available
        # on the node

        client = Chef::ApiClient.load(@nodename)
        @encryption_key = OpenSSL::PKey::RSA.new(client.public_key)

        # First we encrypt the secret, then we encode it in base64 to avoid
        # troublesome characters on the Chef server and in CouchDB
        
        @encrypted_string = Base64.encode64(@encryption_key.public_encrypt(@plaintext))
        @node = Chef::Node.load(@nodename)

        test_command = "@node." + @attribute
        final_command = test_command + "='" + @encrypted_string + "'"
	if config[:dry_run]
          current = eval(test_command)
          output "This would run #{final_command} on node #{@nodename}. Current value for attribute  #{@attribute} is #{current}."
        else
          eval(final_command)
          @node.save
          output "Successfully set attribute #{@attribute} on node #{@nodename}."
        end
        
      end
    end
  end
end

