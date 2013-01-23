program = require "commander"
colors = require "colors"
pkgtool = require "../index.coffee"
pkg = require "../package.json"

knownCommands = [ "expand", "hold", "update" ]

program
  .version( pkg.version )
  .usage( "[options] <path> <command>" )
  .option( "-f, --force", "Force fetch latest versions" )
  .parse( process.argv )

# show help unless arguments passed
unless program.args.length
  program.help()

if program.args[ 0 ] in knownCommands
  # default path
  packagePath = process.cwd()
else
  # determine path
  packagePath = program.args.shift()

# determine command
command = program.args.shift()

# unknown command
unless command in knownCommands
  program.help()

toolInstance = pkgtool packagePath

# finish callback
done = ( err ) ->
  if err
    @log err.toString().red
  else
    @save()

# logger
toolInstance.setLogger ( err, message ) ->
  console[ if err then "error" else "log" ] message

toolInstance.load ( err ) ->
  # routing
  if program.args.length
    @[ command ] [ program.args, done ]...
  else
    @[ command ]( done )