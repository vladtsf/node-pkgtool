describe "Pkg Tool", ->

  before ( done ) ->
    @timeout 15e3

    request "https://registry.npmjs.org/mocha/latest/", ( err, res ) =>
      @latestMochaVersion = JSON.parse( res.body ).version
      try fs.mkdirSync __tmpDir

      done()

  after ->
    @timeout 15e3
    try wrench.rmdirSyncRecursive path.join __tmpDir

  beforeEach ->
    @timeout 15e3
    helpers.Packages.create.call @

  afterEach ->
    @timeout 15e3
    helpers.Packages.remove.call @

  describe "CLI Interface", ->

    @timeout 15e3
    @slow 5e3

    require "./specs/cli/common"
    require "./specs/cli/expand"
    require "./specs/cli/hold"
    require "./specs/cli/update"

  describe "Programmatic API", ->
    require "./specs/programmatic/pkgtool"