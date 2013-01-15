describe "pkgtool", ->

  it "should create instance of pkgtool.Package", ->
    pkgtool( path.join __tmpDir ).should.be.instanceOf pkgtool.Package

  it "should raise exception if the package path didn't passed", ->
    (do pkgtool).should.throw()

  require "./package"