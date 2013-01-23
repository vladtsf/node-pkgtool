program = require "commander"
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


pkgInstance = pkgtool packagePath

done = ( err ) ->
  @save() unless err

pkgInstance.load ( err ) ->
  # routing
  @[ command ] [ program.args..., done ]...