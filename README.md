# Tinychef

This is a simple tool to manage Chef Solo recipe without having to deal with
`knife` command line tool. Tinychef is basically few lines of Ruby code
wrapping shell scripts I used to run my chef recipes.

It aims to be just enough to: 

* automate node boostrapping just a little bit
* run recipes on nodes, overriding the run list if necessary 
* make it easy to work with encrypted data bags

## Installation

    $ gem install tinychef

## Usage

To create a tinychef compatible directory:

    $ tinychef new [dirname]

This will create a new *dirname* folder with the following structure:

    ├── cookbooks
    ├── data_bags
    ├── imported_cookbooks
    ├── nodes
    ├── roles
    └── vendor
    └── solo.rb

### Bootstrap a node

Node bootstrapping is up to you. You have to prepare your own script file for
bootstrapping and put it in `boot.sh`. You can then let tinychef run it:

    $ tinychef boot newnode.example.org

### Run a node

    $ tinychef run username@mynode.example.org 

This command will look for a `mynode.example.org.json` file in nodes folder
and execute the run list on that. Alternatively you can run: 

    $ tinychef run nodes/another_node.json username@mynode.example.org 

If you want to override the run list defined in the node file, append a
run list sequence: 

    $ tinychef run nodes/another_node.json username@mynode.example.org "recipe[mybook::myrecipe]"

If this command does not encounter problems, all files are removed from the
remote host when it completes. If any error occurs, files from the remote host
are not removed, you'll have to clean everything up.

### Working with data bags

Tinychef assumes you will only work with encrypted data bags. In order to
work with encrypted databags you have to create a secret.key file in your
tinychef root folder.

    $ tinychef key:generate

This command will generate a `secret.key` file. Keep it secure.

Databags must be placed under `data_bags` directory organized in folders
reflecting the name of the recipe where the databag is used. You work on databags as
plain ruby hash files, and then encrypt them when it's time to run the recipe
or push everything to the remote.

    $ tinychef bag:create myrecipe bag_name

This command will crete a file named `data_bags/myrecipe/bag_name.rb`. When
you are done editing this file you can encrypt it.

    $ tinychef bag:encrypt myrecipe bag_name

Encryption command will generate a `json` representation of the hash file.
This json file is the one that will be moved to the remote host when running recipes.

### Keeping data safe

In order to keep your working copy clean and secure, tinychef provides a
couple of commands to password protect you `secret.key` file:

    $ tinychef key:lock

will ask for a password and encrypt you key an `secret.key.aes` file. The
reverse command is:

    $ tinychef key:unlock

It's a good idea to leave your working copy safe by removing all plain
hashes version of data\_bags. You'll be always able to restore the ruby hash
version of an encrypted data bag with the command:

    $ tinychef bag:decrypt myrecipe bag_name

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
