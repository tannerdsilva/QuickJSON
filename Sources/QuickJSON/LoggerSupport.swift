// (c) tanner silva 2023. all rights reserved.
import Logging

/// build the default logger for a quickjson subsystem.
/// - parameter label: the label to assign to the logger.
/// - parameter logLevel: the initial log level for the logger.
/// - returns: a configured `Logger`.
internal func makeDefaultLogger(label: String, logLevel: Logger.Level) -> Logger {
	var newLogger = Logger(label: label)
	newLogger.logLevel = logLevel
	newLogger.debug("quickjson logging is active. set the log level to .critical to disable log output at runtime.")
	return newLogger
}

internal extension Logger {
	/// return a copy of this logger with the given log level set.
	func settingLogLevel(_ level: Logger.Level) -> Logger {
		var copy = self
		copy.logLevel = level
		return copy
	}
}
