describe "CLI Interface", ->
  require "./specs/cli/expand"
  require "./specs/cli/hold"
  require "./specs/cli/update"

describe "Programmatic API", ->
  require "./specs/programmatic/pkgtool"

  before ->
    try fs.mkdirSync __tmpDir

  after ->
    try fs.rmdirSync __tmpDir
