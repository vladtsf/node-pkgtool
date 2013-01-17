describe "update", ->

  it "should update all the versions of dependencies", ( done ) ->
    exec "#{ __binaryPath } .tmp/successful update", ( err, stdout, stderr ) =>
      pkg = require path.join __tmpDir, "successful", "package.json"

      pkg.devDependencies
        .should.have.property "mocha", @latestMochaVersion

      done()

  it "should update only specified package if it's name passed", ( done ) ->
    exec "#{ __binaryPath } .tmp/successful update mocha", ( err, stdout, stderr ) =>
      pkg = require path.join __tmpDir, "successful", "package.json"

      pkg.devDependencies
        .should.have.property "mocha", @latestMochaVersion

      pkg.dependencies
        .should.have.property "async", "*"

      done()
