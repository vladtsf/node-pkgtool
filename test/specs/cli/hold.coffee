describe "hold", ->

  beforeEach ( done ) ->
    exec "#{ __binaryPath } .tmp/successful2 hold", ( err, stdout, stderr ) =>
      @pkg = require path.join __tmpDir, "successful2", "package.json"
      done()

  it "should hold dependencies from node_modules", ->
    @pkg.dependencies
      .should.have.property "foo", "0.0.1"

  it "should hold only specified package if it's name passed", ( done ) ->
    exec "#{ __binaryPath } .tmp/successful hold mocha", ( err, stdout, stderr ) =>
      pkg = require path.join __tmpDir, "successful", "package.json"

      pkg.devDependencies
        .should.have.property "mocha", "1.8.0"

      pkg.dependencies
        .should.have.property "async", "*"

      done()