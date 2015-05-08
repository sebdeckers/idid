chai = require('chai')
expect = chai.expect
sinon = require('sinon')
chai.use(require('sinon-chai'))
cli = require('../lib/cli')

describe 'CLI:', ->

	describe '.parse()', ->

		it 'should return an empty object if no argv', ->
			expect(cli.parse(null)).to.deep.equal({})

		it 'should return an empty object if empty argv', ->
			expect(cli.parse([])).to.deep.equal({})

		it 'should parse cli arguments', ->
			argv = [ 'Hello', 'World', '-v' ]
			expect(cli.parse(argv)).to.deep.equal
				_: [ 'Hello', 'World' ]
				v: true

	describe '.getMessage()', ->

		it 'should return the message given one argument', ->
			message = cli.getMessage({ _: [ 'Hello World' ] })
			expect(message).to.equal('Hello World')

		it 'should return concatenate the messages given multiple arguments', ->
			message = cli.getMessage({ _: [ 'Hello', 'World' ] })
			expect(message).to.equal('Hello World')

		it 'should return undefined if no arguments', ->
			message = cli.getMessage({})
			expect(message).to.be.undefined

		it 'should return undefined if empty arguments', ->
			message = cli.getMessage({ _: [ '', '  ' ] })
			expect(message).to.be.undefined

		it 'should return undefined if no argv object', ->
			message = cli.getMessage()
			expect(message).to.be.undefined

	describe '.getHelp()', ->

		it 'should return a string', ->
			expect(cli.getHelp()).to.be.a('string')

		it 'should return a non empty string', ->
			expect(cli.getHelp().trim()).to.not.have.length(0)
