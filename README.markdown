
# Projectwatch

Projectwatch is a tool for automating various tasks in software projects. Such
as running tests, preprocessing CSS/JS or running code quality checks (eg.
jslint) etc. Tasks are run when a change is detected in the files belonging to
the task.

A task is defined in projectwatch.cfg file that you put somewhere in your
project folder tree structure. You can put several tasks in a one file and you
can have several projectwatch.cfg files in your project. Projectwatch will
search all the projectwatch.cfg files and starts corresponding monitors.

Here's an example file

    [My project Coffees]
    watchdir = ./src
    glob = *.coffee
    cmd = coffee --output js/ src/*

and now command

    projectwatch path/to/my/project

will find it and starts the monitor defined in it.

## Web app

Because shells are intended for a one output only, it gets very messy if you
have several running applications on one shell. That's why Projectwatch comes
with embedded webserver which provides a web app for viewing task statuses. The
app view is updated instantly as your tasks are being run. It works currently
best in Chrome since it has the best support for WebSockets.

Take a look at a screenshot [here](http://i.imgur.com/WuOad.png).

## Error reporting

Commands that exits with non zero exitstatus are considered failing.

Some times tool creator has not thought through scripting use cases and we
cannot detect whether the command succeeded. You can provide your custom
error checker regexp in projectwatch.cfg

Example:

    error.stdout = error [0-9]+

Would match for "error 4" in the stdout of your command. You can similar
define checker for stderr.


## Usage

    projectwatch [dir1[,dir2[,...]]]

Options:
  -p, --port [NUMBER]    Listen on this port (Default is 1234)
  -l, --host [STRING]    Listen to a host (Default is 127.0.0.1)
  -v, --version          Show version
  -h, --help             Display help and usage details

Without parameters projectwatch will start searching from current working directory.

### projectwatch.cfg

projectwatch.cfg is an [ini-style][] configuration file.

    [<monitor name>]
    watchdir = <directory to be monitored>
    glob = <glob matcher for files to be monitored>
    cmd = <command to be executed on changes>
    ; Optional settings
    error.stdout = <regexp>
    error.stderr = <regexp>

projectwatch.cfg files can have several monitors defined in them.  The cmd will
have the directory of projectwatch.cfg as it's current working directory.


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

- Notify about errors using HTML5 desktop notifications

