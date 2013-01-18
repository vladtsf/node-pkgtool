# NPM Package class.
#
class Package

  # Construct a new package.
  #
  # @param [String] @path path to package.json file
  #
  constructor: ( @path ) ->

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
  load: ( callback ) ->

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
  create: ( callback ) ->

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
  save: ( callback ) ->

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
  update: ( packages, callback ) ->

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
  expand: ( callback ) ->

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