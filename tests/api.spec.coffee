chai = require('chai')
expect = chai.expect
sinon = require('sinon')
chai.use(require('sinon-chai'))
nock = require('nock')
api = require('../lib/api')
config = require('../lib/config')

describe 'API:', ->

	# Restoring nock once after all tests run instead of in afteEach
	# as it stops intercepting HTTP requests otherwise for some reason
	after ->
		nock.restore()

	describe '.create()', ->

		describe 'given config.getToken() throws an error', ->

			beforeEach ->
				@configGetTokenStub = sinon.stub(config, 'getToken')
				@configGetTokenStub.throws(new Error('token error'))

				@configGetTeamStub = sinon.stub(config, 'getTeam')
				@configGetTeamStub.returns('Work')

			afterEach ->
				@configGetTokenStub.restore()
				@configGetTeamStub.restore()

			it 'should return the error', (done) ->
				api.create 'Hello World', (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('token error')
					expect(item).to.not.exist
					done()

		describe 'given config.getTeam() throws an error', ->

			beforeEach ->
				@configGetTeamStub = sinon.stub(config, 'getTeam')
				@configGetTeamStub.throws(new Error('team error'))

				@configGetTokenStub = sinon.stub(config, 'getToken')
				@configGetTokenStub.returns('1234')

			afterEach ->
				@configGetTeamStub.restore()
				@configGetTokenStub.restore()

			it 'should return the error', (done) ->
				api.create 'Hello World', (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('team error')
					expect(item).to.not.exist
					done()

		describe 'given there exists a valid token and a team', ->

			beforeEach ->
				@configGetTokenStub = sinon.stub(config, 'getToken')
				@configGetTokenStub.returns('1234')

				@configGetTeamStub = sinon.stub(config, 'getTeam')
				@configGetTeamStub.returns('Work')

			afterEach ->
				@configGetTokenStub.restore()
				@configGetTeamStub.restore()

			it 'should return an error if no message', (done) ->
				api.create null, (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('The message is empty')
					expect(item).to.not.exist
					done()

			it 'should return an error if message is empty', (done) ->
				api.create '', (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('The message is empty')
					expect(item).to.not.exist
					done()

			it 'should return an error if message only contains spaces', (done) ->
				api.create '   ', (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('The message is empty')
					expect(item).to.not.exist
					done()

			it 'should return an error if message is not a string', (done) ->
				api.create 1234, (error, item) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('The message is not a string: 1234')
					expect(item).to.not.exist
					done()

			describe 'given the configured team does not exist', ->

				beforeEach ->
					nock('https://idonethis.com')
						.post('/api/v0.1/dones/')
						.reply 400,
							detail: 'Invalid request data'
							ok: false
							errors:
								team: [ 'No team with that short_name found.' ]

				it 'should return an error', (done) ->
					api.create 'Hello World', (error, item) ->
						expect(error).to.be.an.instanceof(Error)
						expect(error.message).to.equal('Invalid request data. No team with that short_name found.')
						expect(item).to.not.exist
						done()

			describe 'given the configured token is not valid', ->

				beforeEach ->
					nock('https://idonethis.com')
						.post('/api/v0.1/dones/')
						.reply 401,
							detail: 'Invalid token'
							ok: false

				it 'should return an error', (done) ->
					api.create 'Hello World', (error, item) ->
						expect(error).to.be.an.instanceof(Error)
						expect(error.message).to.equal('Invalid token.')
						expect(item).to.not.exist
						done()

			describe 'given the done is created successfully', ->

				beforeEach ->
					@done =
						ok: true
						warnings: []
						result:
							id: 20038504
							created: '2015-05-08T01:41:03.754'
							updated: '2015-05-08T01:41:03.799'
							markedup_text: 'Hello World'
							url: 'https://idonethis.com/api/v0.1/dones/1234/'
							team: 'https://idonethis.com/api/v0.1/teams/work/'
							raw_text: 'Hello World'
							done_date: '2015-05-07'
							team_short_name: 'work'
							owner: 'jviotti'
							tags: []
							likes: []
							comments: []
							meta_data: {}
							permalink: 'https://idonethis.com/done/1234/'
							is_goal: false
							goal_completed: true

					nock('https://idonethis.com')
						.post('/api/v0.1/dones/')
						.reply(201, @done)

				it 'should return the done', (done) ->
					api.create 'Hello World', (error, item) =>
						expect(error).to.not.exist
						expect(item).to.deep.equal(@done.result)
						done()
