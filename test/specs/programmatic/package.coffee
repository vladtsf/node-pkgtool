describe "Package", ->

  beforeEach ->
    try fs.mkdirSync path.join __tmpDir, "empty"
    try fs.mkdirSync path.join __tmpDir, "successful"
    try fs.mkdirSync path.join __tmpDir, "broken"
    try fs.writeFileSync path.join( __tmpDir, "successful", "package.json" ), fs.readFileSync( __fixturesPaths.successful )
    try fs.writeFileSync path.join( __tmpDir, "broken", "package.json" ), fs.readFileSync( __fixturesPaths.broken )
    wrench.copyDirSyncRecursive __fixturesPaths.nodeModules, path.join( __tmpDir, "successful", "node_modules" )

    try @successful = pkgtool path.join __tmpDir, "successful"
    try @broken = pkgtool path.join __tmpDir, "broken"
    try @empty = pkgtool path.join __tmpDir, "empty"
    try @nonexistent = pkgtool path.join __tmpDir, "nonexistent"

  afterEach ->
    try wrench.rmdirSyncRecursive path.join __tmpDir, "empty"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "successful"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "broken"

  describe "@load()", ->

    it "should lookup package.json in specified directory", ( done ) ->
      @successful.load done

    it "should fill @dependencies property", ( done ) ->
      @successful.load ( err ) ->
        @dependencies
          .should.be.a( "object" )
          .and.have.property( "coffee-scrip" )
          .and.have.property( "commander" )
          .and.have.property( "async" )

          done()

    it "should fill @devDependencies property", ( done ) ->
      @successful.load ( err ) ->
        @devDependencies
          .should.be.a( "object" )
          .and.have.property( "mocha" )
          .and.have.property( "should" )
          .and.have.property( "sinon" )

          done()

    it "should raise an error if package.json not exists", ( done ) ->
      @nonexistent.load ( err ) ->
        shld.exist err
        done()

    it "should invoke @create() if package.json not exists but containing directory is present", ( done ) ->
      create = sinon.spy @empty, "create"

      @empty.load ( err ) ->
        create.calledOnce.should.be.true
        done()

    it "should raise an error if package.json not valid", ( done ) ->
      @broken.load ( err ) ->
        shld.exist err
        done()

    it "should invoke callback", ( done ) ->
      @successful.load done

  describe "@create()", ->
    it "should lookup package.json in specified directory", ( done ) ->
      @empty.create ( err ) ->
        @empty.packagePath.should.equal path.join( fs.realpathSync path.join __tmpDir, "empty" ), "package.json"
        done()

    it "should fill @dependencies property", ( done ) ->
      @empty.create ( err ) ->
        @dependencies.should.be.a "object"
        done()

    it "should fill @devDependencies property", ->
      @empty.create ( err ) ->
        @devDependencies.should.be.a "object"
        done()

  describe "@save()", ->

    it "should write package.json", ( done ) ->
      @empty.create ( err ) ->
        @save ( err ) ->
          ( fs.existsSync path.join __tmpDir, "empty", "package.json" ).should.be.true
          done()

    it "should invoke callback", ( done ) ->
      @successful.create ( err ) ->
        @save done

  describe "@update()", ->

    it "should update only specified package if it's name passed", ( done ) ->
      fetch = sinon.spy @successful, "fetch"

      @successful.load ( err ) ->
        @update "mocha", ( err ) ->
          fetch.calledWithExactly "mocha"
          fetch.calledOnce
          done()

    it "should fetch all the latest versions of dependencies", ( done ) ->
      fetch = sinon.spy @successful, "fetch"

      @successful.load ( err ) ->
        @update ( err ) ->
          for own dep in [ "coffee-script", "commander", "async", "mocha", "should", "sinon" ]
            fetch.calledWith( dep ).should.be.true

          done()

    it "should invoke callback", ( done ) ->
      @successful.load ( err ) ->
        @update "mocha", done

  describe "@expand()", ->

    it "should lookup dependencies which not specified in package.json in node_modules directory", ( done ) ->
      @successful.load ( err ) ->
        @expand ( err ) ->
          @dependencies.should.have.property "foo", "0.0.1"
          done()

    it "should invoke callback", ( done ) ->
      @successful.load ( err ) ->
        @expand done

  describe "@fetch()", ->

    it "should determine the latest version of package", ->
    it "should fetch only specified package if it's name passed", ->
    it "should go to npmjs.org if the force flag passed", ->
    it "should invoke callback", ->