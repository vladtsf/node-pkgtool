describe "Package", ->

  beforeEach ->

  describe "@save()", ->

    it "should write package.json to disc", ->
    it "should invoke callback", ->

  describe "@load()", ->

    it "should lookup package.json in specified directory", ->
    it "should fill @dependencies property", ->
    it "should fill @devDependencies property", ->
    it "should raise an error if package.json not exists", ->
    it "should invoke @create() if package.json not exists but containing directory is present", ->
    it "should raise an error if package.json not valid", ->
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