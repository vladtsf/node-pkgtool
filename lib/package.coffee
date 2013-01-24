# NPM Package class.
#
class Package

  fs = require "fs"
  rc = require "rc"
  url = require "url"
  util = require "util"
  glob = require "glob"
  path = require "path"
  request = require "request"
  async = require "async"
  colors = require "colors"

  # Construct a new package.
  #
  # @param [String] @path path to package.json file
  #
  constructor: ( @path ) ->
    # Package's dependencies for production
    @dependencies = {}

    # Package's dependencies for development
    @devDependencies = {}

    # Registry override
    @registry = null

  # Log message.
  #
  # @example Just log.
  #   new Package( __dirname ).log "hello, world!"
  #
  # @example Log error.
  #   new Package( __dirname ).log "hello, world!", on
  #
  # @param [String] message message to log
  # @param [Boolean] err is it error?
  # @return [Package] package instance
  #
  log: ( message, err ) ->
    @logger.call( @, err, message ) if typeof @logger is "function"

    @

  # Set logger callback.
  #
  # @example Set logger.
  #   new Package( __dirname ).setLogger ( err, message ) ->
  #     console.log if err then message.red else message.green
  #
  # @param [Function] @logger log callback
  # @return [Package] package instance
  #
  setLogger: ( @logger ) ->
    @

  # Set registry.
  #
  # @example Set registry.
  #   new Package( __dirname ).setRegistry "http://registry.npmjs.org/"
  #
  # @param [String] @registry
  # @return [Package] package instance
  #
  setRegistry: ( @registry ) ->
    @

  # Get package url in registry.
  #
  # @example Get package url.
  #   new Package( __dirname ).load ( err ) ->
  #     console.log @getPackageURL "mocha", "1.1.1"
  #
  # @param [String] @registry
  # @return [Package] package instance
  #
  getPackageURL: ( packageName, version = "latest" ) ->
    # lookup registry url
    registry = @registry ? @pkg.publishConfig?.registry ? @rc.registry

    # parse base registry url
    urlObj = url.parse registry

    # get the path tokens
    tokens = ( token for own token in urlObj.pathname.split( "/" ) when token isnt "" )

    # add package name and version
    tokens.push packageName, version

    # set pathname
    urlObj.pathname = "/#{ tokens.join "/" }"

    # return formatted url
    url.format urlObj

  # Lookup package.json path.
  #
  # @example Lookup package.json
  #   new Package( __dirname ).lokup ( err ) ->
  #     unless err
  #       console.log "package.json placed at #{ @path }"
  #     else
  #       console.log "failed to lookup package.json"
  #
  # @param [Function] callback will be invoked when done
  # @return [Package] package instance
  #
  lookup: ( callback = -> ) ->
    # check file/dir stats
    fs.stat @path, ( err, stats ) =>
      # file/dir not exists
      return callback.call( @, err ) if err

      # it is a path to package.json
      return callback.call( @ ) if stats.isFile()

      # try to load file in specified dir
      @path = path.join @path, "package.json"

      # determine the full path
      fs.realpath @path, ( err, realPath ) =>
        # apply path if it exists
        @path = realPath unless err?

        # invoke the callback of success
        callback.call @

    @

  # Load package.
  #
  # @example Load package
  #   new Package( __dirname ).load ( err ) ->
  #     unless err
  #       console.log "package loaded!"
  #     else
  #       console.log "package loading failed"
  #
  # @param [Function] callback will be invoked when loading finishes
  # @return [Package] package instance
  #
  load: ( callback = -> ) ->
    @lookup ( err ) ->
      # throw error if lookup failed
      return callback.call( @, err ) if err

      # load npmrc configuration
      @rc = rc "npm", registry: "https://registry.npmjs.org/"

      try
        # try to load info from package.json
        @pkg = require @path

        # fill dependencies
        @dependencies = @pkg.dependencies
        @devDependencies = @pkg.devDependencies

        callback.call @
      catch e
        if e.code is "MODULE_NOT_FOUND"
          # if package.json not exists, should initialize dependencies
          @create callback
        else
          # if package.json is broken
          callback.call @, e

    @

  # Create package.
  #
  # @example Create package
  #   new Package( __dirname ).create ( err ) ->
  #     unless err
  #       console.log "package created!"
  #     else
  #       console.log "package creation failed"
  #
  # @param [Function] callback will be invoked when package created
  # @return [Package] package instance
  #
  create: ( callback = -> ) ->
    @pkg =
      dependencies: @dependencies = {}
      devDependencies: @devDependencies = {}

    callback.call @

    @

  # Save package.
  #
  # @example Create and save package
  #   new Package( __dirname ).create ( err ) ->
  #     unless err
  #       @save ( err ) ->
  #         unless ( err ) ->
  #           console.log "package saved"
  #         else
  #           console.log "package saving failed"
  #     else
  #       console.log "package creation failed"
  #
  # @param [Function] callback will be invoked when package saved
  # @return [Package] package instance
  #
  save: ( callback = -> ) ->
    @lookup ( err ) =>
      return callback.call( @, err ) if err

      # save file and invoke successful callback
      fs.writeFile @path, JSON.stringify( @pkg, null, "  " ), "utf8", ( err ) =>
        callback.call @, err

    @

  # Update dependencies.
  #
  # @example Update dependencies
  #   new Package( __dirname ).load ( err ) ->
  #     @update ( err ) ->
  #       unless err
  #         console.log "dependencies updated"
  #       else
  #         console.log "update failed"
  #
  # @example Update specified dependence
  #   new Package( __dirname ).load ( err ) ->
  #     @update "mocha", ( err ) ->
  #       unless err
  #         console.log "mocha version has updated"
  #       else
  #         console.log "update failed"
  #
  # @param [String, Array] packages names of packages to update
  # @param [Function] callback will be invoked when dependencies updated
  # @return [Package] package instance
  #
  update: ( packages, callback = -> ) ->
    # cache dependencies
    dependencies = Object.keys @dependencies ? {}
    devDependencies = Object.keys @devDependencies ? {}

    # if passed only one package
    packages = [ packages ] if typeof packages is "string"

    # if packages argument is missing
    if typeof packages is "function"
      # callback was the first argument if the packages is missing
      callback = packages
      # load all the packages in dependencies
      packages = [ dependencies..., devDependencies... ]

    # load latest packages versions
    async.map packages, ( ( pkg, done ) => @fetch pkg, on, done ), ( err, results ) =>
      # handle errors
      return callback.call( @, err ) if err?

      # list of updated packages
      updated = []

      # save changes
      for own pkg, idx in packages
        if pkg in dependencies
          # track update
          updated.push( pkg ) if @dependencies[ pkg ] isnt results[ idx ]

          @dependencies[ pkg ] = results[ idx ]
        else if pkg in devDependencies
          # track update
          updated.push( pkg ) if @devDependencies[ pkg ] isnt results[ idx ]

          @devDependencies[ pkg ] = results[ idx ]

      if updated.length
        @log "Updated #{ updated.length } package(s)".cyan
        @log "  #{ ( "#{ pkgName }@#{ results[ idx ] }" for own pkgName, idx in updated ).join( "\n  " ).green }"
      else
        @log "Already up-to-date.".green

      # successful callback
      callback.call @

    @

  # Hold dependencies.
  #
  # @example Hold dependencies
  #   new Package( __dirname ).load ( err ) ->
  #     @hold ( err ) ->
  #       unless err
  #         console.log "dependencies holded"
  #       else
  #         console.log "hold failed"
  #
  # @example Hold specified dependence
  #   new Package( __dirname ).load ( err ) ->
  #     @hold "mocha", ( err ) ->
  #       unless err
  #         console.log "mocha version has holded"
  #       else
  #         console.log "hold failed"
  #
  # @param [String, Array] packages names of packages to update
  # @param [Function] callback will be invoked when dependencies updated
  # @return [Package] package instance
  #
  hold: ( packages, callback = -> ) ->
    # cache dependencies
    dependencies = Object.keys @dependencies ? {}
    devDependencies = Object.keys @devDependencies ? {}

    # if passed only one package
    packages = [ packages ] if typeof packages is "string"

    # if packages argument is missing
    if typeof packages is "function"
      # callback was the first argument if the packages is missing
      callback = packages
      # load all the packages in dependencies
      packages = [ dependencies..., devDependencies... ]

    # filter asterisked packages
    packages = ( pkg for own pkg in packages when ( @dependencies[ pkg ] ? @devDependencies[ pkg ] ) is "*" )

    # load latest packages versions
    async.map packages, @fetch.bind( @ ) , ( err, results ) =>
      # handle errors
      return callback.call( @, err ) if err?

      # save changes
      for own pkg, idx in packages
        if pkg in dependencies
          @dependencies[ pkg ] = results[ idx ]
        else if pkg in devDependencies
          @devDependencies[ pkg ] = results[ idx ]

      @log "Holded #{ packages.length } package(s)".cyan
      @log "  #{ ( "#{ pkgName }@#{ results[ idx ] }" for own pkgName, idx in packages ).join( "\n  " ).green }"

      # successful callback
      callback.call @

    @

  # Expand dependencies from node_modules.
  #
  # @example Expand
  #   new Package( __dirname ).load ( err ) ->
  #     @expand ( err ) ->
  #       unless err
  #         console.log "expanded"
  #       else
  #         console.log "expand failed"
  #
  # @param [Function] callback will be invoked when done
  # @return [Package] package instance
  #
  expand: ( callback = -> ) ->
    @lookup ( err ) ->
      return callback.call( @, err ) if err

      # find packages in node_modules
      glob ( path.join ( path.dirname @path ), "node_modules", "*", "package.json" ), ( err, files ) =>
        return callback.call( @, err ) if err

        for own file in files
          try
            { name, version } = require file

            # if this package not listed in dependencies, add it
            unless ( name in Object.keys ( @dependencies ? {} ) ) or ( name in Object.keys ( @devDependencies ? {} ) )
              @dependencies[ name ] = version
              @log "Added ".cyan + "#{ name }@#{ version }".green + " to package.json".cyan

        callback.call @

    @

  # Fetch package version.
  #
  # @example Fetch
  #   new Package( __dirname ).load ( err ) ->
  #     @fetch "mocha", ( err, version ) ->
  #       unless err
  #         console.log "expanded"
  #       else
  #         console.log "expand failed"
  #
  # @param [String] packageName package name
  # @param [Boolean] forceRemote load info from npm registry
  # @param [Function] callback will be invoked when done
  # @return [Package] package instance
  #
  fetch: ( packageName, forceRemote, callback ) ->
    if typeof forceRemote is "function" and not callback
      callback = forceRemote
      forceRemote = off

    ( callback = -> ) unless callback

    if ( not forceRemote ) and fs.existsSync( depPath = path.join ( path.dirname @path ), "node_modules", packageName, "package.json" )
      # try to determine version according from node_modules containment at first
      try
        callback.call @, null, require( depPath ).version
      catch e
        @fetch packageName, on, callback
    else
      # fetch version from npm registry
      request @getPackageURL( packageName, "latest" ), ( err, res ) =>
        # something went wrong
        return callback.call( @, err ) if err?

        # package not found or registry is down
        return callback.call( @, new Error( "Package #{ packageName } not found" ) ) if res.statusCode isnt 200

        try
          # successful callback invocation
          callback.call @, null, JSON.parse( res.body ).version
        catch e
          # if json not valid
          callback.call @, e

    @


module.exports = Package