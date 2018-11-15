import UIKit

/**
 *  The View Controller that holds all UI components of the main view.
 */
class ViewController: UIViewController, UITextFieldDelegate
{
    /** The default URL for the URL input field. */
    let DEFAULT_URL :String = "http://christopherstock.de/"

    // MARK: InterfaceBuilder Outlets

    // TODO outsource!

    /** The 'Title' label. */
    @IBOutlet weak var titleLabel       :UILabel!
    /** The 'URL input' text field. */
    @IBOutlet weak var urlInputField    :UITextField!
    /** The 'Crawl it!' button. */
    @IBOutlet weak var crawlButton      :UIButton!
    /** The loading indicator. */
    @IBOutlet weak var loadingIndicator :UIActivityIndicatorView!
    /** The 'HTML output' text view. */
    @IBOutlet weak var htmlOutputText   :UITextView!

    /**
     *  Being invoked when the view controller is fully loaded.
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // acclaim console and output field
        Debug.log( "ViewController.viewDidLoad()" )
        appendHtmlOutputFieldText( msg: "Welcome to the Wuzzy Web Crawler." )

        // set input field's delegate
        urlInputField.delegate = self
        urlInputField.borderStyle = .none
        urlInputField.text = DEFAULT_URL

        // set round corners for all UI elements
        setRoundCorners( view: urlInputField    )
        setRoundCorners( view: titleLabel       )
        setRoundCorners( view: crawlButton      )
        setRoundCorners( view: loadingIndicator )
        setRoundCorners( view: htmlOutputText   )

        // hide the loading indicator
        self.loadingIndicator.isHidden = true
    }

    // MARK: InterfaceBuilder Actions

    /**
     *  Being invoked when the 'Crawl it!' button is pressed.
     */
    @IBAction
    func onPressCrawlButton( _ sender: UIButton )
    {
        Debug.log( "ViewController.onPressCrawlButton" )

        // pick the URL from the input field
        let urlToConnect :String = urlInputField.text!

        // show the loading circle
        loadingIndicator.isHidden = false

        // hide input fields
        self.setUserInputEnabled( visible: false )

        // perform an URL connection
        let url:URL = URL( string: urlToConnect )!
        performUrlConnection( url: url )
    }

    // MARK: UITextFieldDelegate

    /**
     *  Being invoked when the text field completed all editing activities.
     *
     *  @param textField The text field that sent this event to the delegate.
     */
    func textFieldShouldReturn( _ textField: UITextField ) -> Bool
    {
        Debug.log( "ViewController.textFieldShouldReturn" )

        // hide the keyboard.
        textField.resignFirstResponder()

        return true
    }

    /**
     *  Being invoked when the text field completed all editing activities.
     *
     *  @param textField The text field that sent this event to the delegate.
     */
    func textFieldDidEndEditing( _ textField: UITextField ) -> Void
    {
        Debug.log( "ViewController.textFieldDidEndEditing" )
    }

    // TODO outsource! - create callback to invoke when done etc.

    /**
     *  Performs a connection to the specified URL.
     *
     *  @param url The URL to crawl.
     */
    func performUrlConnection( url:URL )
    {
        Debug.log( "ViewController.performUrlConnection()" )
        Debug.log( "Connect to URL [" + url.description + "]" )

        appendHtmlOutputFieldText( msg: "Connecting to URL [" + url.description + "]" )

        // TODO guard with output message!

        // specify the URL data task ( performed in bg thread )
        let task:URLSessionDataTask = URLSession.shared.dataTask( with: url )
        {
            ( data:Data?, response:URLResponse?, error:Error? ) in
            self.receiveUrlCallback( data: data, response: response, error: error )
        }

        // run the task
        task.resume()
    }

    /**
     *  Enabled or disables user input.
     *
     *  @param visible If the user input elements shall be enabled or disabled.
     */
    func setUserInputEnabled( visible:Bool )
    {
        self.crawlButton.isHidden   = !visible
        self.urlInputField.isHidden = !visible
    }

    /**
     *  Appends the text in the HTML Output textfield by the specified message.
     *  The message is followed by a line break.
     *
     *  @param msg The message to append to the HTML Output.
     */
    func appendHtmlOutputFieldText( msg:String )
    {
        self.htmlOutputText.text.append( msg + "\n" )
    }

    /**
     *  Sets round corners for the specified UIView element.
     *
     *  @param view The UIView element to round the corners for.
     */
    func setRoundCorners( view:UIView )
    {
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = 5
    }

    /**
     *  Being invoked when the URL callback arrived.
     */
    func receiveUrlCallback( data:Data?, response:URLResponse?, error:Error? ) -> Void
    {
        // TODO implement error handling in case of 404 etc.

        // pick data
        guard let data = data else { return }

        // convert data to HTML
        let htmlString :String = String( data: data, encoding: .utf8 )!

        // handle the HTML
        self.handleReceivedHtml( htmlString: htmlString )
    }

    /**
     *  Handles the received HTML string.
     */
    func handleReceivedHtml( htmlString:String ) -> Void
    {
        // process HTML for output
        let croppedHtmlString   :String = String( htmlString.prefix( 75 ) )
        let replacedHtmlString  :String = croppedHtmlString.replacingOccurrences( of: "\n", with: " " )
        print( replacedHtmlString )

        // run on main thread
        DispatchQueue.main.async
        {
            // show the results in the HTML output
            self.appendHtmlOutputFieldText( msg: "Crawled [" + String( htmlString.count ) + "] bytes" )

            // hide the loading circle
            self.loadingIndicator.isHidden = true

            // show the input components again
            self.setUserInputEnabled( visible: true )
        }
    }
}
