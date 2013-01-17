describe "hold", ->

  beforeEach ( done ) ->
    exec "#{ __binaryPath } .tmp/successful hold", ( err, stdout, stderr ) =>
      @pkg = require path.join __tmpDir, "successful", "package.json"
      done()

  it "should hold dependencies from node_modules", ->
    console.log @pkg.devDependencies
      .should.have.property "foo", "0.0.1"

  it "should hold only specified package if it's name passed", ( done ) ->
    exec "#{ __binaryPath } .tmp/successful2 hold mocha", ( err, stdout, stderr ) =>
      pkg = require path.join __tmpDir, "successful2", "package.json"

      pkg.devDependencies
        .should.have.property "mocha", @latestMochaVersion

      pkg.dependencies
        .should.have.property "async", "*"

      done()


  it "should fetch version from npmjs.org unless it's present in node_modules", ->
    @pkg.devDependencies
      .should.have.property "mocha", @latestMochaVersion