chalk = require('chalk')
async = require('async')
cli = require('./cli')
api = require('./api')
packageJSON = require('../package.json')

argv = cli.parse(process.argv.slice(2))

if argv.v or argv.version
	console.log(packageJSON.version)
	process.exit(0)

message = cli.getMessage(argv)

async.waterfall [

	(callback) ->
		if not message?
			console.log(cli.getHelp())
			process.exit(1)
		return callback()

	(callback) ->
		api.create(message, callback)

], (error, done) ->
	if error?
		console.error("#{chalk.red.bold('ERROR:')} #{error.message}")
		process.exit(1)

	text = chalk.bold(done.raw_text)
	team = chalk.bold.underline(done.team_short_name)

	console.log("#{chalk.green.bold('ADDED:')} \"#{text}\" to team #{team}!")
