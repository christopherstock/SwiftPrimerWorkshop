import Foundation
import UIKit

/**
 *  Delegates a URL connection.
 */
protocol URLConnectionDelegate
{
    /**
     *  Being invoked when an URL connection request has returned.
     *
     *  @param urlResponse The response state.
     *  @param htmlString  The received HTML string.
     *  @param error       Any error that occurred on connecting.
     */
    func urlCallback(urlResponse: UrlConnectionResponse, htmlString:String?, error:Error?)
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
     *  @param urlString The URL to crawl.
     *  @param delegate  The delegate to invoke when the URL connection has been performed.
     */
    func performUrlConnection(urlString:String, delegate:URLConnectionDelegate)
    {
        // create URL and break if invalid
        guard let url:URL = URL(string: urlString) else
        {
            print("The inserted URL [" + urlString + "] is invalid!")
            delegate.urlCallback(urlResponse: .INVALID_URL, htmlString: nil, error: nil)
            return
        }

        let callback = {
            (data:Data?, response:URLResponse?, error:Error?) in
            self.receiveUrlCallback(
                data: data,
                response: response,
                error: error,
                delegate: delegate
            )
        }

        // specify the URL data task ( performed in bg thread ) and launch it
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: callback)
        task.resume()
    }

    /**
     *  Being invoked when the URL callback arrived.
     *
     *  @param data     The received data.
     *  @param response The URL response object.
     *  @param error    Any error that occured during URL connection.
     *  @param delegate The delegate to invoke when the URL connection has been performed.
     */
    func receiveUrlCallback(data:Data?, response:URLResponse?, error:Error?, delegate:URLConnectionDelegate) -> Void
    {
        // check connection error
        if let error:Error = error
        {
            delegate.urlCallback(urlResponse: .CONNECTION_ERROR, htmlString: nil, error: error)
            return
        }

        // check text encoding error
        guard let data:Data = data, let htmlString:String = String(data: data, encoding: .utf8) else
        {
            delegate.urlCallback(urlResponse: .TEXT_ENCODING_ERROR, htmlString: nil, error: error)
            return
        }

        // callback success
        delegate.urlCallback(urlResponse: .SUCCESS, htmlString: htmlString, error: error)
    }
}
