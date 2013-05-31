'use strict';
var util   = require('util');
var path   = require('path');
var fs     = require('fs');
var yeoman = require('yeoman-generator');

var Generator = module.exports = function Generator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(Generator, yeoman.generators.NamedBase);

Generator.prototype.getTemplates = function getTemplates() {
  var fs = require('fs');
  var files = fs.readdirSync(path.join(__dirname,'templates','themes'));
  var i, n = files.length; for (i = 0; i < n; ++i) { files[i] = files[i].replace(/\.[^.]+$/g,"").replace(/\_/,""); };
  this.templateList = files.join('|');
}

Generator.prototype.askFor = function askFor() {
  var cb = this.async();

  // welcome message
  var welcome =
  '\n     _-----_' +
  '\n    |       |' +
  '\n    |' + '--(o)--'.red + '|   .----------------------------.' +
  '\n   `---------´  |        ' + 'Yeoman says,'.yellow.bold + '         |' +
  '\n    ' + '( '.yellow + '_' + '´U`'.yellow + '_' + ' )'.yellow + '   | ' + 'enjoy Foundation v4 by Zurb '.yellow.bold + '|' +
  '\n    /___A___\\   \'_____________________________\'' +
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
    message: 'Choose Foundation Template - [http://foundation.zurb.com/templates.php ' + this.templateList + ']: ',
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
  this.copy('404.html','app/404.html');
  this.copy('robots.txt','app/robots.txt');
  this.copy('humans.txt','app/humans.txt');
  this.indexContent = this.read('./themes/_'+ this.templateName +'.html');
  this.template('index.html','app/index.html')
};

Generator.prototype.appSass = function appSass() {
  this.mkdir('app/sass');
  this.copy('sass/app.scss','app/sass/app.scss');
  this.copy('sass/_settings.scss','app/sass/_settings.scss');
};

Generator.prototype.appCss = function appCss() {
  this.mkdir('app/css');
};

Generator.prototype.gruntfile = function gruntfile() {
  if(this.coffeeScript) {
    this.template('Gruntfile.coffee');
  }else{
    this.template('Gruntfile.js');
  }
};

Generator.prototype.projectFiles = function projectFiles() {
  this.template('_bower.json'   , 'bower.json');
  this.template('_package.json' , 'package.json');
};

Generator.prototype.configs = function configs() {
  this.copy('configs/bowerrc'       , '.bowerrc');
  this.copy('configs/gitignore'     , '.gitignore');
  this.copy('configs/gitattributes' , '.gitattributes');
  this.copy('configs/editorconfig'  , '.editorconfig');
  this.copy('configs/jshintrc'      , '.jshintrc');
};
