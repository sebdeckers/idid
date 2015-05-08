_ = require('lodash')
userHome = require('user-home')
os = require('os')
path = require('path')
packageJSON = require('../package.json')

###*
# @summary Get the path to the config file
# @function
# @private
#
# @description
# It prefixes the path with . on UNIX and _ on Windows.
#
# @returns {String} The absolute path to the config file
#
# @example
# configPath = config.getConfigPath()
###
exports.getConfigPath = ->
	if os.platform() is 'win32'
		configPrefix = '_'
	else
		configPrefix = '.'

	return path.join(userHome, "#{configPrefix}#{packageJSON.name}.json")

###*
# @summary Read the config file from it's default location
# @function
# @private
#
# @returns {Object} The parsed config file contents
#
# @throws Will throw if the config file does not exist
# @throws Will throw if the config file is not parseable
#
# @example
# parsedConfig = config.read()
###
exports.read = ->
	configPath = exports.getConfigPath()

	try
		return require(configPath)
	catch
		throw new Error("Missing or invalid config file at #{configPath}")

###*
# @summary Get the current configured token
# @function
# @protected
#
# @returns {String} The configured token
#
# @throws Will throw if the token doesn't exist
# @throws Will throw if the token is not a string
# @throws Will throw if the token is an empty string
#
# @example
# token = config.getToken()
###
exports.getToken = ->
	config = exports.read()
	configPath = exports.getConfigPath()

	if not config.token?
		throw new Error("Missing token at #{configPath}. You can find it at https://idonethis.com/api/token/")

	if not _.isString(config.token)
		throw new Error("Looks like the token defined at #{configPath} is not valid: #{config.token}")

	if _.isEmpty(config.token.trim())
		throw new Error("Looks like the token defined at #{configPath} is an empty string")

	return config.token

###*
# @summary Get the current configured team
# @function
# @protected
#
# @returns {String} The configured team
#
# @throws Will throw if the team doesn't exist
# @throws Will throw if the team is not a string
# @throws Will throw if the team is an empty string
#
# @example
# team = config.getTeam()
###
exports.getTeam = ->
	config = exports.read()
	configPath = exports.getConfigPath()

	if not config.team?
		throw new Error("Missing team at #{configPath}")

	if not _.isString(config.team)
		throw new Error("Looks like the team defined at #{configPath} is not valid: #{config.team}")

	if _.isEmpty(config.team.trim())
		throw new Error("Looks like the team defined at #{configPath} is an empty string")

	return config.team
