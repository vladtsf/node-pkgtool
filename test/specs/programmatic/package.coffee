describe "Package", ->

  beforeEach ->
    try fs.mkdirSync path.join __tmpDir, "empty"
    try fs.mkdirSync path.join __tmpDir, "successful"
    try fs.mkdirSync path.join __tmpDir, "broken"
    try fs.writeFileSync path.join( __tmpDir, "successful", "package.json" ), fs.readFileSync( __fixturesPaths.successful )
    try fs.writeFileSync path.join( __tmpDir, "broken", "package.json" ), fs.readFileSync( __fixturesPaths.broken )

    try @successful = pkgtool path.join __tmpDir, "successful"
    try @broken = pkgtool path.join __tmpDir, "broken"
    try @empty = pkgtool path.join __tmpDir, "empty"

  afterEach ->
    try fs.unlink path.join __tmpDir, "successful", "package.json"
    try fs.unlink path.join __tmpDir, "broken", "package.json"
    try fs.rmdirSync path.join __tmpDir, "empty"
    try fs.rmdirSync path.join __tmpDir, "successful"
    try fs.rmdirSync path.join __tmpDir, "broken", "package.json"

  describe "@load()", ->

    it "should lookup package.json in specified directory", ( done ) ->
      @successful.load done

    it "should fill @dependencies property", ->
    it "should fill @devDependencies property", ->
    it "should raise an error if package.json not exists", ->
    it "should invoke @create() if package.json not exists but containing directory is present", ->
    it "should raise an error if package.json not valid", ->
    it "should invoke callback", ->

  describe "@save()", ->

    it "should write package.json", ->
    it "should invoke callback", ->

  describe "@create()", ->
    it "should lookup package.json in specified directory", ->
    it "should fill @dependencies property", ->
    it "should fill @devDependencies property", ->

  describe "@update()", ->

    it "should update only specified package if it's name passed", ->
    it "should fetch all the latest versions of dependencies and hold it", ->
    it "should invoke callback", ->

  describe "@expand()", ->

    it "should lookup dependencies which not specified in package.json in node_modules directory", ->
    it "should invoke callback", ->

  describe "@fetch()", ->

    it "should determine the latest version of package", ->
    it "should fetch only specified package if it's name passed", ->
    it "should go to npmjs.org if the force flag passed", ->
    it "should invoke callback", ->