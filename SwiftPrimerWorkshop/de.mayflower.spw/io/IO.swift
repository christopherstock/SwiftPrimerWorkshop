import Foundation
import UIKit

/**
 *  Delegates a URL connection.
 *  TODO reactivate!
 */
/*
protocol URLConnectionDelegate
{
    /**
     *  Being invoked when the URL callback arrived.
     *
     *  @param data     The received data.
     *  @param response The URL response object.
     *  @param error    Any error that occured during URL connection.
     */
    func receiveUrlCallback(data:Data?, response:URLResponse?, error:Error?, vc:ViewController) -> Void
}
*/

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
     *  @param urlString The URL to crawl.
     *  @param delegate  The delegate to invoke when the URL connection has been performed.
     *  @param vc        The view controller reference.
     */
    func performUrlConnection(urlString:String, vc:ViewController)
    {
        // create URL and break if invalid
        guard let url:URL = URL(string: urlString) else
        {
            print("The inserted URL [" + urlString + "] is invalid!")
            vc.urlCallback(urlResponse: .INVALID_URL)
            return
        }

        let callback = {
            (data:Data?, response:URLResponse?, error:Error?) in
            self.receiveUrlCallback(
                data: data,
                response: response,
                error: error,
                vc: vc
            )
        }

        // specify the URL data task ( performed in bg thread )
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: callback)

        // run the task
        task.resume()
    }

    /**
     *  Being invoked when the URL callback arrived.
     *
     *  @param data     The received data.
     *  @param response The URL response object.
     *  @param error    Any error that occured during URL connection.
     *  @param vc       The view controller reference. TODO prune? > To reference!
     */
    func receiveUrlCallback(data:Data?, response:URLResponse?, error:Error?, vc:ViewController) -> Void
    {
        // check for a connection error
        if let error:Error = error
        {
            vc.urlCallback(urlResponse: UrlConnectionResponse.CONNECTION_ERROR, htmlString: nil, error: error)
            return
        }

        // pick text data
        guard let data:Data = data, let htmlString:String = String(data: data, encoding: .utf8) else
        {
            vc.urlCallback(urlResponse: UrlConnectionResponse.TEXT_ENCODING_ERROR)
            return
        }

        // handle the HTML
        vc.urlCallback(urlResponse: UrlConnectionResponse.SUCCESS, htmlString: htmlString)
    }
}
