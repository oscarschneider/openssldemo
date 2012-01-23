require 'chef/knife'

class Chef
  class Knife
    class RoleSecretAdd < Knife

      deps do
        require 'openssl'
        require 'base64'
      end
      
      banner "knife role secret add [ROLE] [PLAINTEXT] [ATTRIBUTE]"

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
          @rolename = @name_args[0]
          @plaintext = @name_args[1]
          @attribute = @name_args[2]
        end

        # Build the query
        query = "role:#{@rolename}"
        q = Chef::Search::Query.new

        # @nodes contains the name of all nodes that are of role @rolename
        @nodes = []
        q.search(:node, query).each do |el|
          if el.class == Array
            el.each do |node|
              @nodes << node.name
            end
          end
        end
        
        # We need to encrypt the secret for each of them, since their private key differs
        @nodes.each do |n|

          client = Chef::ApiClient.load(n)
          @encryption_key = OpenSSL::PKey::RSA.new(client.public_key)

          @encrypted_string = Base64.encode64(@encryption_key.public_encrypt(@plaintext))
          @node = Chef::Node.load(n)

          test_command = "@node." + @attribute
          final_command = test_command + "='" + @encrypted_string + "'"
          if config[:dry_run]
           current = eval(test_command)
           output "This would run #{final_command} on node #{n}. Current value for attribute  #{@attribute} is #{current}."
          else
            output "Ciphertext for node #{n} is #{@encrypted_string}." if config[:print_ciphertext]
            eval(final_command)
            @node.save
            output "Successfully set attribute #{@attribute} for node #{n}."
          end
        end        
      end
    end
  end
end

