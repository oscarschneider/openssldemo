Description
===========

These cookbooks' purpose is to demonstrate decryption of strings that were encrypted with
a nodes/clients public key. 

Moreover the `openssldemo` default recipe now also supports encrypting
stuff for other clients. In the version in this repository it will
encrypt something for the `chef-webui` user. To have your node encrypt
something for you, just exchange `chef-webui` by your client name,
copy the output of the file `/tmp/decryptme` to your workstation and
run the accompanying `./decrypt.rb PATH_TO_YOUR_CLIENT_PRIVATEKEY_FILE
PATH_TO_ENCRYPTED_FILE`.


Requirements
============

You need an encrypted attribute value, which you can create by running 
`knife node secret add NODE PLAINTEXT ATTRIBUTE`.

Of course you need the `node_secret.rb` knife plugin first. Put it in `~/.chef/plugins/knife`.

Attributes
==========

Usage
=====

   `knife node secret add NODE PLAINTEXT openssldemo`
   `knife node show NODE -a openssldemo`
   `knife node run_list add NODE 'recipe[openssldemo]'`
   `ssh NODE chef-client`
   `ssh NODE cat /tmp/itworks`
   `ssh NODE cat /tmp/decryptme > ~/messageforyou`
   `./decrypt.rb PATH_TO_webui.pem ~/messageforyou` 
