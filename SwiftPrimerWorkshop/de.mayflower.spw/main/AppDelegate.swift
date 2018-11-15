import UIKit

/**
 *  The App Delegate represents the singleton application instane.
 *
 *  TODO Add colored HTML text?
 *  TODO Add error handling for ALL kind of errors.
 *  TODO Scroll HTML Output to the end on appending text!
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    /** The UI window instance. */
    var window: UIWindow?

    /**
     *  The constructor is being invoked when this application is instanciated.
     */
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        Debug.log( "AppDelegate.application" )

        return true
    }

    /**
     *  Being invoked when the application moves from active to inactive state.
     */
    func applicationWillResignActive( _ application: UIApplication )
    {
        Debug.log( "AppDelegate.applicationWillResignActive" )
    }

    /**
     *  Being invoked when the application enters the background state.
     */
    func applicationDidEnterBackground( _ application: UIApplication )
    {
        Debug.log( "AppDelegate.applicationDidEnterBackground" )
    }

    /**
     *  Being invoked when the application enters the foreground state.
     */
    func applicationWillEnterForeground( _ application: UIApplication )
    {
        Debug.log( "AppDelegate.applicationWillEnterForeground" )
    }

    /**
     *  Being invoked when the application became active (again).
     */
    func applicationDidBecomeActive( _ application: UIApplication )
    {
        Debug.log( "AppDelegate.applicationDidBecomeActive" )
    }

    /**
     *  Being invoked when the application is about to terminate.
     */
    func applicationWillTerminate( _ application: UIApplication )
    {
        Debug.log( "AppDelegate.applicationWillTerminate" )
    }
}
