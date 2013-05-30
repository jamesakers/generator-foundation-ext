'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');

var Generator = module.exports = function Generator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(Generator, yeoman.generators.NamedBase);

Generator.prototype.askFor = function askFor() {
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

  var prompts = [{
    name: 'siteName',
    message: 'Enter site name: '
  },{
    name: 'coffeeScript',
    message: 'Gruntfile as CoffeeScript ☕ ?: ',
    default: 'Y/n'
  },{
    name: 'templateName',
    message: 'Choose Foundation Template: ',
    default: 'welcome'
  }];
  this.prompt(prompts, function (err, props) {
    if (err) {
      return this.emit('error', err);
    }
    this.siteName = props.siteName ;
    this.coffeeScript = (/y/i).test(props.coffeeScript);
    this.templateName = props.templateName;
    cb();
  }.bind(this));
};

Generator.prototype.app = function app() {
  this.mkdir('app');
  this.mkdir('app/js');
  this.mkdir('app/sass');
  this.mkdir('app/css');
  this.copy('404.html','app/404.html');
  this.copy('robots.txt','app/robots.txt');
  this.copy('humans.txt','app/humans.txt');
  this.indexContent = this.read('./themes/_'+ this.templateName +'.html');
  this.template('index.html','app/index.html')
};

//Generator.prototype.foundation = function foundation() {
  //this.copy('../../node_modules/foundation/js/*', 'app/js/');
//};

Generator.prototype.gruntfile = function gruntfile() {
  if(this.coffeeScript) {
    this.template('Gruntfile.coffee');
  }else{
    this.template('Gruntfile.js');
  }
};

Generator.prototype.projectfiles = function projectfiles() {
  this.template('_bower.json', 'bower.json');
  this.template('_package.json', 'package.json');
  this.copy('gitignore', '.gitignore');
  this.copy('gitattributes', '.gitattributes');
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
