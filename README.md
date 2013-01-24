# pkgtool [![Build Status](https://travis-ci.org/vtsvang/node-pkgtool.png)](https://travis-ci.org/vtsvang/node-pkgtool)

Tool for managing package's dependencies versions.

## Features

  * Hold dependencies versions
  * Update dependencies versions
  * Expand dependencies versions from node_modules
  * CLI and Programmatical APIs

## Installation

    $ npm install -g pkgtool

## Usage

### Hold

    $ pkgtool hold

or

    $ pkgtool /path/to/package/dir hold

### Update

#### all

    $ pkgtool update

#### update only specified

    $ pkgtool update mocha sinon

### Expand

    $ pkgtool expand


### Programmatically
```coffeescript
pkgtool = require "pkgtool"

pkgtool( "." ).load ( err ) ->
  @expand ( err ) ->
    @save ( err ) ->
      console.log( "Yay!" ) unless err
```

# Development

Add specs for any new or changed functionality.

Runs tests: `npm test`

Generate documentation: `npm run-script generate-doc`

# Changelog

* v0.3.0
  * Registry support
  * Documentation
  * Fixed couple of bugs
* v0.2.2
  * Fixed example in README.md
* v0.2.1
  * README updated
* v0.2.0
  * Logger
* v0.1.0
  * First version
* v0.0.1
  * Initial structure

## License

(The MIT License)

Copyright (c) 2013 Vladimir Tsvang &lt;vtsvang@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.