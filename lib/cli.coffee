_ = require('lodash')
minimist = require('minimist')
config = require('./config')
packageJSON = require('../package.json')

###*
# @summary Parse the cli arguments
# @function
# @protected
#
# @param {String[]} argv - argv
# @returns {Object} The parsed arguments
#
#	@example
#	argv = cli.parse(process.argv)
###
exports.parse = (argv) ->
	return {} if not argv? or _.isEmpty(argv)
	return minimist(argv)

###*
# @summary Get the message from argv
# @function
# @protected
#
# @param {Object[]} args - minimist arguments
# @returns {(String|Undefined)} The message, or undefined
#
#	@example
#	message = cli.getMessage(cli.parse(process.argv))
###
exports.getMessage = (args) ->
	return if not args?._?
	return args._.join(' ').trim() or undefined

###*
# @summary Get a help string
# @function
# @protected
#
# @returns {String} The help message
#
#	@example
#	help = cli.getHelp()
###
exports.getHelp = ->
	return """
		#{packageJSON.description}, v#{packageJSON.version}.

		Usage: #{packageJSON.name} <message...>

		Edit #{config.getConfigPath()} to modify the default token and team.
		Go to #{packageJSON.homepage} for documentation.
	"""
