import UIKit

/**
 *  The View Controller that holds all UI components of the main view.
 *
 *  TODO Add error handling for ALL kind of errors.
 */
class ViewController: UIViewController, UITextFieldDelegate, URLConnectionDelegate
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

    /** The mutable attributed string being applied to the HTML Output Textfield. */
    var outputTextContent :NSMutableAttributedString = NSMutableAttributedString()

    /**
     *  Being invoked when the view controller is fully loaded.
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // acclaim console and output field
        Debug.log( "ViewController.viewDidLoad()" )
        appendHtmlOutputFieldText( msg: "Welcome to the Wuzzy Web Crawler.", color: UIColor.orange )

        // set input field's delegate
        urlInputField.delegate = self
        urlInputField.borderStyle = .none
        urlInputField.text = DEFAULT_URL

        // set round corners for all UI elements
        UI.setRoundCorners( view: urlInputField    )
        UI.setRoundCorners( view: titleLabel       )
        UI.setRoundCorners( view: crawlButton      )
        UI.setRoundCorners( view: loadingIndicator )
        UI.setRoundCorners( view: htmlOutputText   )

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

        // create URL to crawl
        let url:URL = URL( string: urlToConnect )!

        // log URL to crawl
        Debug.log( "Connect to URL [" + url.description + "]" )
        appendHtmlOutputFieldText( msg: "Connecting to URL [" + url.description + "]", color: UIColor.orange )

        // perform an URL connection
        IO.performUrlConnection( url: url, delegate: self )
    }

    // MARK: UITextFieldDelegate

    // TODO Outsource Delegate functionality for input text field.

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
     *  @param msg   The message to append to the HTML Output.
     *  @param color The color for the message to appear.
     */
    func appendHtmlOutputFieldText( msg:String, color:UIColor )
    {
        let string           :String                         = ( msg + "\n" )
        let attributes       :[NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: color ]
        let attributesString :NSAttributedString             = NSAttributedString( string: string, attributes: attributes )

        // append stored mutable string
        outputTextContent.append( attributesString )

        // reassign stored mutable string to output field
        htmlOutputText.attributedText = outputTextContent

        // scroll textfield to bottom
        let bottom = NSMakeRange( htmlOutputText.text.count - 1, 1 )
        htmlOutputText.scrollRangeToVisible( bottom )
    }

    // MARK: URLConnectionDelegate

    /**
     *  Being invoked when the URL callback arrived.
     *
     *  @param data     The received data.
     *  @param response The URL response object.
     *  @param error    Any error that occured during URL connection.
     */
    func receiveUrlCallback( data:Data?, response:URLResponse?, error:Error? ) -> Void
    {
        // TODO implement error handling in case of 1. wrong URL, 2. empty field, 3. 404, 4. timeout etc.

        // pick data
        guard let data = data else { return }

        // convert data to HTML
        let htmlString :String = String( data: data, encoding: .utf8 )!

        // handle the HTML
        self.handleReceivedHtml( htmlString: htmlString )
    }

    /**
     *  Handles the received HTML string.
     *  It will be logged to the debug console and its length will be printed in the HTML Output Field.
     *
     *  @param htmlString The HTML string to process.
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
            self.appendHtmlOutputFieldText( msg: "Crawled [" + String( htmlString.count ) + "] bytes", color: UIColor.green )

            // hide the loading circle
            self.loadingIndicator.isHidden = true

            // show the input components again
            self.setUserInputEnabled( visible: true )
        }
    }
}
