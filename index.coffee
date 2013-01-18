module.exports = pkgtool = ( path ) ->
  throw new Error( "path not specified" ) unless path?

  new pkgtool.Package path

pkgtool.Package = require "./lib/package"