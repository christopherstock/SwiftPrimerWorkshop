import Foundation

/**
 *  Delegates a URL connection.
 */
protocol URLConnectionDelegate
{
    /**
     *  Being invoked when the URL callback arrived.
     *
     *  @param data     The received data.
     *  @param response The URL response object.
     *  @param error    Any error that occured during URL connection.
     */
    func receiveUrlCallback(data:Data?, response:URLResponse?, error:Error?) -> Void
}

/**
 *  Offers IO functionality.
 */
class IO
{
    /**
     *  Performs a connection to the specified URL.
     *
     *  @param url      The URL to crawl.
     *  @param delegate The delegate to invoke when the URL connection has been performed.
     */
    static func performUrlConnection(url:URL, delegate:URLConnectionDelegate)
    {
        let callback = {
            (data:Data?, response:URLResponse?, error:Error?) in
            delegate.receiveUrlCallback(data: data, response: response, error: error)
        }

        // specify the URL data task ( performed in bg thread )
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: callback)

        // run the task
        task.resume()
    }
}
