# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class MarkedPlugin extends BasePlugin
		# Plugin name
		name: 'marked'

		# Plugin configuration
		config:
			markedOptions:
				pedantic: false
				gfm: true
				sanitize: false
				highlight: null

		# Render some content
		render: (opts,next) ->
			# Prepare
			config = @config
			{inExtension,outExtension} = opts

			# Check our extensions
			if inExtension in ['md','markdown'] and outExtension in [null,'html']
				# Requires
				marked = require('marked')
				marked.setOptions(config.markedOptions)
				if config.markedRenderer
					renderer = new marked.Renderer()
					Object.keys(config.markedRenderer).forEach (key) ->
						return renderer[key] = config.markedRenderer[key]
					return marked(opts.content, { renderer: renderer }, (err, result) ->
						opts.content = result
						return next(err)
					)

				# Render
				# use async form of marked in case highlight function requires it
				marked opts.content, (err, result) ->
					opts.content = result
					next(err)

			else
				# Done
				next()
