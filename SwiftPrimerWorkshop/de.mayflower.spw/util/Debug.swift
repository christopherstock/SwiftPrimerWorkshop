/**
 *  The debug system for log output.
 */
class Debug
{
    /** Enables or disables the debug mode. */
    static let DEBUG_MODE = true

    /**
     *  Logs the specified debug message in the debug console.
     *  Only if the global debug switch is enabled.
     *
     *  @param msg The message or any debug object to log.
     */
    static func log( _ msg:Any ) -> Void
    {
        if ( Debug.DEBUG_MODE )
        {
            print( msg )
        }
    }
}
