# NPM Package class.
#
class Package

  fs = require "fs"
  util = require "util"
  glob = require "glob"
  path = require "path"

  # Construct a new package.
  #
  # @param [String] @path path to package.json file
  #
  constructor: ( @path ) ->
    # Package's dependencies for production
    @dependencies = {}

    # Package's dependencies for development
    @devDependencies = {}

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
  #     @update "mochq", ( err ) ->
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
    callback(err)

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
      glob ( path.join ( path.dirname @path ), "**", "package.json" ), ( err, files ) =>
        return callback.call( @, err ) if err

        for own file in files
          try
            { name, version } = require file

            # if this package not listed in dependencies, add it
            unless ( name in Object.keys @dependencies ) or ( name in Object.keys @devDependencies )
              @dependencies[ name ] = version

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
  fetch: ( packageName, forceRemote, callback = -> ) ->

    @


module.exports = Package