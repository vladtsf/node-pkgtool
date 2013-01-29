describe "common", ->

  context "when json is broken", ->

    beforeEach ( done ) ->
      @brokenJSONPath = path.join __tmpDir, "broken", "package.json"
      @oldPackage = fs.readFileSync @brokenJSONPath, "utf8"

      exec "#{ __binaryPath } .tmp/broken update", ( @err, @stdout, @stderr ) =>
        done()

    afterEach ->
      delete @brokenJSONPath
      delete @oldPackage
      delete @err
      delete @stdout
      delete @stderr

    it "should not overwrite package.json", ->
      @oldPackage.should.equal fs.readFileSync @brokenJSONPath, "utf8"

    it "should write message to stderr", ->
      @stderr.should.match /Can't parse package.json, \[SyntaxError: Unexpected string\]/
