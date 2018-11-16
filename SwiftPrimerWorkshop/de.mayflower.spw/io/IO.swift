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
 *  Specifies all response states of an url connection.
 */
enum UrlConnectionResponse
{
    /** If the URL is empty or invalid. */
    case INVALID_URL
    /** If the URL connection failed. */
    case CONNECTION_ERROR
    /** If the received bytes could not be converted to text. */
    case TEXT_ENCODING_ERROR
    /** If the HTML sourcecoude could be streamed and converted successfully. */
    case SUCCESS
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
