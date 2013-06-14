# generator-foundation-ext [![Build Status](https://secure.travis-ci.org/jamesakers/generator-foundation-ext.png?branch=master)](https://travis-ci.org/jamesakers/generator-foundation-ext)

Author: James Akers

## About
This project is a Yeoman generator for [Foundation by Zurb (version 4)](http://foundation.zurb.com) that builds a skeleton app that is ready to run in the browser.

## Features
- is bootstrapped with [CoffeeScript](http://coffeescript.org/), Gruntfile (default - optional)
- includes [Foundation Templates](http://foundation.zurb.com/templates.php)
- bower installation of Foundation
- includes coffeescript, livereload, compass, watch
- is `grunt build` ready right out of the box

## Requirements
###Node Packages:

- [Yo](https://github.com/yeoman/yo): `npm install -g yo`

###Ruby Gems:

- compass `[sudo] gem install compass`

## Installation
###Global
- `npm install -g generator-foundation-ext`

###Local
- `mkdir [/some/directory]`
- `cd [/some/directory]`
- `npm install generator-foundation-ext`

## Getting Started
### Create a project
* `mkdir /path/to/[project name]`
* `cd /path/to/[project name]`
* Run: `yo foundation-ext`
* `> Enter site name:` [Site Name]
* `> Gruntfile as CoffeeScript ☕ ?: (Y/n):`
* `> Choose Foundation Template - [http://foundation.zurb.com/templates.php banded|banner|bare|blog|boxy|contact|feed|grid|marketing|orbit|realty|sidebar|store|welcome|workspace]: (welcome)`
* Run: `grunt server`

## Grunt Tasks
### Server 
- Run: `grunt server`
- Defaultly runs with [livereload](http://livereload.com/) at `http://localhost:9000`

### Build
- Run: `grunt build` or just `grunt`
- Creates a minified ditributable project in the `dist` directory of your project

## Todo
- Don't have bower import everything from Foundation repo
- Allow previous versions of Foundation
- Add additional generators for add-ons

## License
[BSD License](http://opensource.org/licenses/bsd-license.php)
