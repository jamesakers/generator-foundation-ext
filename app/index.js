'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');

var FoundationGenerator = module.exports = function FoundationGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(FoundationGenerator, yeoman.generators.NamedBase);

FoundationGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // welcome message
  var welcome =
  '\n     _-----_' +
  '\n    |       |' +
  '\n    |' + '--(o)--'.red + '|   .--------------------------.' +
  '\n   `---------´  |    ' + 'Welcome to Yeoman,'.yellow.bold + '    |' +
  '\n    ' + '( '.yellow + '_' + '´U`'.yellow + '_' + ' )'.yellow + '   |   ' + 'ladies and gentlemen!'.yellow.bold + '  |' +
  '\n    /___A___\\   \'__________________________\'' +
  '\n     |  ~  |'.yellow +
  '\n   __' + '\'.___.\''.yellow + '__' +
  '\n ´   ' + '`  |'.red + '° ' + '´ Y'.red + ' `\n';

  console.log(welcome);

  //var prompts = [{
    //name: 'someOption',
    //message: 'Would you like to enable this option?',
    //default: 'Y/n',
    //warning: 'Yes: Enabling this will be totally awesome!'
  //}];

  //this.prompt(prompts, function (err, props) {
    //if (err) {
      //return this.emit('error', err);
    //}

    //this.someOption = (/y/i).test(props.someOption);

  //}.bind(this));
  cb();
};

FoundationGenerator.prototype.app = function app() {
  this.mkdir('app');
  this.mkdir('app/components');
  this.mkdir('app/scripts');
  this.mkdir('app/styles');
  this.copy('404.html','app/404.html');
  this.copy('index.html','app/index.html');
};

FoundationGenerator.prototype.gruntfile = function gruntfile() {
  this.template('Gruntfile.coffee');
}

FoundationGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('_component.json', 'component.json');
  this.copy('_package.json', 'package.json');
  this.copy('gitignore', '.gitignore');
  this.copy('gitattributes', '.gitattributes');
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
