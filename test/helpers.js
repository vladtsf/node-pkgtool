global.fs = require( "fs" )
global.path = require( "path" )
global.pkgtool = require( "../index.coffee" )
global.__testsRootDir = __dirname
global.__tmpDir = path.join(fs.realpathSync( path.join( __dirname, ".." ) ), ".tmp")

global.__fixturesPaths = {
  successful: path.join( __testsRootDir, "fixtures", "packages", "successful.json" ),
  broken: path.join( __testsRootDir, "fixtures", "packages", "broken.json" )
}