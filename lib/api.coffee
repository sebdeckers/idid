_ = require('lodash')
request = require('request')
config = require('./config')

###*
# @summary Create a done in iDoneThis
# @function
# @protected
#
# @description
# It uses the configured token and team settings
#
# @param {String} message - the done message
# @param {Function} callback - callback (error, done)
#
#	@example
#	api.create 'Hello World from idid!', (error, done) ->
#		throw error if error?
#		console.log("Added: #{done.raw_text}")
###
exports.create = (message, callback) ->

	try
		token = config.getToken()
		team = config.getTeam()
	catch error
		return callback(error)

	if not message? or (_.isString(message) and _.isEmpty(message.trim()))
		return callback(new Error('The message is empty'))

	if not _.isString(message)
		return callback(new Error("The message is not a string: #{message}"))

	# Browse to https://idonethis.com/api/v0.1/dones/
	# for more details about the accepted options
	request
		url: 'https://idonethis.com/api/v0.1/dones/'
		method: 'POST'
		json: true
		body:
			team: team
			raw_text: message
		headers:
			Authorization: "Token #{token}"

	, (error, response, body) ->
		return callback(error) if error?

		if not body.ok

			# Hacky way to convert multiple errors returned by iDoneThis
			# into something readable, although their messages are not
			# as user friendly as we would like anyway.
			errorMessage = "#{body.detail}. #{_.values(body.errors).join(' ')}"

			return callback(new Error(errorMessage.trim()))

		return callback(null, body.result)
