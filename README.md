Description
===========

This cookbooks purpose is to demonstrate decryption of strings that were encrypted with
a nodes/clients public key. 

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
