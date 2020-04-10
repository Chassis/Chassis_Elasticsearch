# @summary
#
#   Merges a JVM options with a defaults array, removing any duplicates from the defaults.
#
# Parameter: JVM options array to merge with defaults.
# Parameter: Default JVM options array.
#
Puppet::Functions.create_function(:merge_jvm_options) do
	# @param options The options array to merge with the default.
	# @param defaults The default options array to merge against.
	#
	# @return array of merged options.
	#
	dispatch :merge? do
		param 'Array', :options
		param 'Array', :defaults
		return_type 'Array'
	end

	def merge?(options, defaults)
		# Keys to match JVM option values
		keys = [
			'-Dfile.encoding',
			'-Dio.netty.noKeySetOptimization',
			'-Dio.netty.noUnsafe',
			'-Dio.netty.recycler.maxCapacityPerThread',
			'-Djava.awt.headless',
			'-Djna.nosys',
			'-Dlog4j.shutdownHookEnabled',
			'-Dlog4j2.disable.jmx',
			'AlwaysPreTouch',
			'HeapDumpOnOutOfMemoryError',
			'UseG1GC',
			'OmitStackTraceInFastThrow',
			'CMSInitiatingOccupancyFraction',
			'-Xms',
			'-Xmx',
			'-Xss',
			'server',
			'InitiatingHeapOccupancyPercent',
			'PrintGCApplicationStoppedTime',
			'PrintGCDateStamps',
			'PrintGCDetails',
			'PrintTenuringDistribution',
			'UseCMSInitiatingOccupancyOnly',
			'UseConcMarkSweepGC',
			'UseGCLogFileRotation',
			'GCLogFileSize',
			'NumberOfGCLogFiles',
			'Xloggc'
		]

		# Collect corresponding keys from the options array
		option_keys = options.reduce([]) do |carry, option|
			option.match(/(#{keys.join('|')})/) { |m| carry << m[1] }
			carry
		end

		# Remove matched option keys from the defaults array
		trimmed_defaults = defaults.reduce([]) do |carry, default|
			carry << default if option_keys.empty? or default !~ /(#{option_keys.join('|')})/
			carry
		end

		options + trimmed_defaults
	end
end
