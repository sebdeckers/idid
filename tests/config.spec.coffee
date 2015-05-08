chai = require('chai')
expect = chai.expect
sinon = require('sinon')
chai.use(require('sinon-chai'))
os = require('os')
userHome = require('user-home')
path = require('path')
mock = require('mock-fs')
config = require('../lib/config')

describe 'Config:', ->

	describe '.getConfigPath()', ->

		describe 'given platform is win32', ->

			beforeEach ->
				@osPlatformStub = sinon.stub(os, 'platform')
				@osPlatformStub.returns('win32')

			afterEach ->
				@osPlatformStub.restore()

			it 'should use _ as prefix', ->
				configPath = config.getConfigPath()
				expect(configPath).to.equal(path.join(userHome, '_idid.json'))

		describe 'given platform is not win32', ->

			beforeEach ->
				@osPlatformStub = sinon.stub(os, 'platform')
				@osPlatformStub.returns('darwin')

			afterEach ->
				@osPlatformStub.restore()

			it 'should use . as prefix', ->
				configPath = config.getConfigPath()
				expect(configPath).to.equal(path.join(userHome, '.idid.json'))

	describe '.read()', ->

		describe 'given the config file does not exist', ->

			it 'should return an error', ->
				mock()

				expect ->
					config.read()
				.to.throw("Missing or invalid config file at #{config.getConfigPath()}")

				mock.restore()

		describe 'given the config file is not parseable', ->

			it 'should return an error', ->
				filesystem = {}
				filesystem[config.getConfigPath()] = '{1234}'
				mock(filesystem)

				expect ->
					config.read()
				.to.throw("Missing or invalid config file at #{config.getConfigPath()}")

				mock.restore()

		describe 'given a parseable config file', ->

			it 'should return the parsed config file', ->
				filesystem = {}
				filesystem[config.getConfigPath()] = '{"hello":"world"}'
				mock(filesystem)

				result = config.read()
				expect(result).to.deep.equal(hello: 'world')

				mock.restore()

	describe '.getToken()', ->

		describe 'given a config file without a token', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns({})

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getToken()
				.to.throw("Missing token at #{config.getConfigPath()}. You can find it at https://idonethis.com/api/token/")

		describe 'given a config file with a token that is not a string', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(token: 123)

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getToken()
				.to.throw("Looks like the token defined at #{config.getConfigPath()} is not valid: 123")

		describe 'given a config file with an empty string token', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(token: '')

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getToken()
				.to.throw("Looks like the token defined at #{config.getConfigPath()} is an empty string")

		describe 'given a config file with a valid token', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(token: '1234')

			afterEach ->
				@configReadStub.restore()

			it 'should return the token', ->
				token = config.getToken()
				expect(token).to.equal('1234')

	describe '.getTeam()', ->

		describe 'given a config file without a team', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns({})

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getTeam()
				.to.throw("Missing team at #{config.getConfigPath()}")

		describe 'given a config file with a team that is not a string', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(team: 123)

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getTeam()
				.to.throw("Looks like the team defined at #{config.getConfigPath()} is not valid: 123")

		describe 'given a config file with an empty string team', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(team: '')

			afterEach ->
				@configReadStub.restore()

			it 'should throw an error', ->
				expect ->
					config.getTeam()
				.to.throw("Looks like the team defined at #{config.getConfigPath()} is an empty string")

		describe 'given a config file with a valid team', ->

			beforeEach ->
				@configReadStub = sinon.stub(config, 'read')
				@configReadStub.returns(team: 'Work')

			afterEach ->
				@configReadStub.restore()

			it 'should return the team', ->
				team = config.getTeam()
				expect(team).to.equal('Work')
