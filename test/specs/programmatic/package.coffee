describe "Package", ->

  before ->
    @npmrc = rc "npm", registry: "https://registry.npmjs.org/"

  describe "@lookup()", ->

    it "should lookup package.json in specified directory", ( done ) ->
      @successful.lookup ( err ) ->
        @path.should.equal path.join( fs.realpathSync path.join __tmpDir, "successful", "package.json" ), "package.json"
        done()

  describe "@getPackageURL()", ->

    it "should apply registry overrides", ( done ) ->
      @successful.load ( err ) ->
        @setRegistry "http://foo.com/"
        @getPackageURL( "mocha" ).should.equal "http://foo.com/mocha/latest"
        done()

    it "should apply specified version", ( done ) ->
      @successful.load ( err ) =>
        @successful.getPackageURL( "mocha", "1.0.0" ).should.equal "#{ @npmrc.registry }mocha/1.0.0"
        done()

  describe "@load()", ->

    it "should define registry, which specified in .npmrc", ( done ) ->
      @successful.load ( err ) =>
        @successful.rc.registry.should.equal @npmrc.registry
        done()

    it "should fill @dependencies property", ( done ) ->
      @successful.load ( err ) ->
        @dependencies.should.be.a( "object" )
        @dependencies.should.have.property( "coffee-script" )
        @dependencies.should.have.property( "commander" )
        @dependencies.should.have.property( "async" )

        done()

    it "should fill @devDependencies property", ( done ) ->
      @successful.load ( err ) ->
        @devDependencies.should.be.a( "object" )
        @devDependencies.should.have.property( "mocha" )
        @devDependencies.should.have.property( "sinon" )

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

    it "should fill @dependencies property", ( done ) ->
      @empty.create ( err ) ->
        @dependencies.should.be.a "object"
        done()

    it "should fill @devDependencies property", ( done ) ->
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
    @timeout 10e3
    @slow 3e3

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
          for own dep in [ "coffee-script", "commander", "async", "mocha", "sinon" ]
            fetch.calledWith( dep ).should.be.true

          done()

    it "should fetch all the versions of listed dependencies", ( done ) ->
      fetch = sinon.spy @successful, "fetch"

      @successful.load ( err ) ->
        list = [ "coffee-script", "commander", "mocha" ]

        @update list, ( err ) ->
          for own dep in list
            fetch.calledWith( dep ).should.be.true

          done()

    it "should invoke callback", ( done ) ->
      @successful.load ( err ) ->
        @update "mocha", done

  describe "@expand()", ->

    it "should lookup dependencies which not specified in package.json in node_modules directory", ( done ) ->
      @successful3.load ( err ) ->
        @expand ( err ) ->
          @dependencies.should.have.property "foo", "0.0.1"
          done()

    it "should invoke callback", ( done ) ->
      @successful3.load ( err ) ->
        @expand done

  describe "@hold()", ->
    @timeout 10e3
    @slow 3e3

    it "should lookup used dependencies versions", ( done ) ->
      @successful2.load ( err ) ->
        @hold ( err ) ->
          @dependencies.should.have.property "foo", "0.0.1"
          done()

    it "should hold only specified dependencies if it does", ( done ) ->
      @successful2.load ( err ) ->
        @hold "foo", ( err ) ->
          @dependencies.should.have.property "foo", "0.0.1"
          done()

    it "should hold specified dependencies passed as array", ( done ) ->
      @successful2.load ( err ) ->
        @hold [ "foo" ], ( err ) ->
          @dependencies.should.have.property "foo", "0.0.1"
          done()

    it "should invoke callback", ( done ) ->
      @successful2.load ( err ) ->
        @hold done

  describe "@fetch()", ->
    @timeout 10e3
    @slow 3e3

    it "should determine the latest version of package", ( done ) ->
      latestMochaVersion = @latestMochaVersion

      @successful.load ( err ) ->
        @fetch "mocha", ( err, version ) ->
          version.should.equal latestMochaVersion
          done()

    it "should try to determine version according from node_modules containment at first", ( done ) ->
      @successful2.load ( err ) ->
        @fetch "foo", ( err, version ) ->
          shld.not.exist err
          version.should.equal "0.0.1"
          done()

    it "should go to npmjs.org if the force flag passed", ( done ) ->
      latestMochaVersion = @latestMochaVersion

      @successful.load ( err ) ->
        @fetch "mocha", on, ( err, version ) ->
          version.should.equal latestMochaVersion
          done()

    it "should raise error if package not exists", ( done ) ->
      @successful.load ( err ) ->
        @fetch "undefined", ( err, version ) ->
          shld.exist err
          done()

    it "should invoke callback", ( done ) ->
      @successful.load ( err ) ->
        @fetch "foo", done

