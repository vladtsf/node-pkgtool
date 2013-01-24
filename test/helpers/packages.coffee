module.exports = class Packages

  @create: ->
    try fs.mkdirSync path.join __tmpDir, "empty"
    try fs.mkdirSync path.join __tmpDir, "successful"
    try fs.mkdirSync path.join __tmpDir, "successful2"
    try fs.mkdirSync path.join __tmpDir, "successful3"
    try fs.mkdirSync path.join __tmpDir, "publish-config"
    try fs.mkdirSync path.join __tmpDir, "broken"
    try fs.writeFileSync path.join( __tmpDir, "successful", "package.json" ), fs.readFileSync( __fixturesPaths.successful )
    try fs.writeFileSync path.join( __tmpDir, "successful2", "package.json" ), fs.readFileSync( __fixturesPaths.successful )
    try fs.writeFileSync path.join( __tmpDir, "successful3", "package.json" ), fs.readFileSync( __fixturesPaths.foo )
    try fs.writeFileSync path.join( __tmpDir, "publish-config", "package.json" ), fs.readFileSync( __fixturesPaths.publishConfig )
    try fs.writeFileSync path.join( __tmpDir, "broken", "package.json" ), fs.readFileSync( __fixturesPaths.broken )
    try wrench.copyDirSyncRecursive __fixturesPaths.nodeModules, path.join( __tmpDir, "successful2", "node_modules" )
    try wrench.copyDirSyncRecursive __fixturesPaths.nodeModules, path.join( __tmpDir, "successful3", "node_modules" )

    try @successful = pkgtool path.join __tmpDir, "successful"
    try @successful2 = pkgtool path.join __tmpDir, "successful2"
    try @successful3 = pkgtool path.join __tmpDir, "successful3"
    try @publishConfig = pkgtool path.join __tmpDir, "publish-config"
    try @broken = pkgtool path.join __tmpDir, "broken"
    try @empty = pkgtool path.join __tmpDir, "empty"
    try @nonexistent = pkgtool path.join __tmpDir, "nonexistent"

  @remove: ->
    try wrench.rmdirSyncRecursive path.join __tmpDir, "empty"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "successful"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "successful2"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "successful3"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "publish-config"
    try wrench.rmdirSyncRecursive path.join __tmpDir, "broken"
