
# Projectwatch

As CSS and Javascript pre-processors have gained popularity, need for various
file change watcher processes has increased. You may now have watchers for Sass,
CoffeeScript, lints, tests etc. Projectwatch aims to be one language
independent solution for all of those.

You use it by defining a projectwatch.cfg file(s) to your project directories.
In the file you define what files should be monitored and what command should
be executed if a change is detected.

Here's an example file

    [My project Coffees]
    watchdir = ./src
    glob = *.coffee
    cmd = coffee --output js/ src/*

Command

    projectwatch path/to/my/project

will go through every directory of your project looking for projectwatch.cfg
files and will start monitors defined in those.


## Synopsis

    projectwatch [dir1[,dir2[,...]]]

Without parameters projectwatch will start searching from current working directory.

### projectwatch.cfg

projectwatch.cfg is an [ini-style][] configuration file.

    [<monitor name>]
    watchdir = <directory to be monitored>
    glob = <glob matcher for files to be monitored>
    cmd = <command to be executed on changes>

projectwatch.cfg files can have several monitors defined in them.


## Installation

Install [Node.js][] and [NPM][] and run

    npm install -g projectwatch


[Node.js]: http://nodejs.org/
[NPM]: http://npmjs.org/
[ini-style]: http://en.wikipedia.org/wiki/INI_file


## Hacking

Remove previous installation

    npm uninstall -g projectwatch

Get the code

    git clone git@github.com:epeli/Projectwatch.git

Link install it

    cd Projectwatch
    npm link

Now projectwatch -command should use your code in the Projectwatch -directory.
Now hack and send some cool pull requests via Github :)

## Licence

GNU GENERAL PUBLIC LICENSE Version 3. See LICENCE.txt.


