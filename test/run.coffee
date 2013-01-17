describe "Pkg Tool", ->

  before ( done ) ->
    request "https://registry.npmjs.org/mocha/latest/", ( err, res ) =>
      @latestMochaVersion = JSON.parse( res.body ).version
      try fs.mkdirSync __tmpDir

      done()


  after ->
    try wrench.rmdirSyncRecursive path.join __tmpDir

  beforeEach ->
    helpers.Packages.create.call @

  afterEach ->
    helpers.Packages.remove.call @

  describe "CLI Interface", ->

    require "./specs/cli/expand"
    require "./specs/cli/hold"
    require "./specs/cli/update"

  describe "Programmatic API", ->
    require "./specs/programmatic/pkgtool"