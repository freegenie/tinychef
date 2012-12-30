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


### Run a node

    $ tinychef run username@mynode.example.org 

This command will look for a `mynode.example.org.json` file in nodes folder
and execute the run list on that. Alternatively you can run: 

    $ tinychef run nodes/another\_node.json username@mynode.example.org 

If you want to override the run list defined in the node file, append a
run list sequence: 

    $ tinychef run nodes/another\_node.json username@mynode.example.org "recipe\[mybook::myrecipe]"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
