
# Projectwatch

As CSS and Javascript pre-processors have gained popularity, need for various
file change watcher processes has increased. You may now have watchers for Sass,
CoffeeScript, lints, tests etc. Projectwatch aims to be one language
independent solution for all of those.

You use it by defining a projectwatch.cfg file(s) to your project directories.
In the file you define what files should be monitored and what command should
be executed when a change is detected.

Here's an example file

    [My project Coffees]
    watchdir = ./src
    glob = *.coffee
    cmd = coffee --output js/ src/*

and now command

    projectwatch path/to/my/project

will go through every directory of your project looking for projectwatch.cfg
files and will start monitors defined in those.

## Webserver

Because shells are intended for a one output only it gets very messy if you
have several running applications on one shell. That's why Projectwatch comes
with embedded webserver which provides a HTML based view for your task
outputs. The view is updated instantly as your tasks are being run.

Take a look at a screenshot [here](http://i.imgur.com/WuOad.png).

## Usage

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


## TODOs

Todos before 1.0.0

- Use some nice command line option parser
- Get rid off socket.io logging messages
- Enable custom error detection
- Notify about errors using HTML5 desktop notifications

