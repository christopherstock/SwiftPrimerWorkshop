import UIKit

/**
 *  The View Controller that holds all UI components of the main view.
 */
class ViewController: UIViewController, URLConnectionDelegate
{
    /** The default URL for the URL input field. */
    let DEFAULT_URL :String = "http://christopherstock.de/"

    // MARK: InterfaceBuilder Outlets

    /** The 'Title' label. */
    @IBOutlet weak var titleLabel :UILabel!
    /** The 'URL input' text field. */
    @IBOutlet weak var urlInputField :UITextField!
    /** The 'Crawl it!' button. */
    @IBOutlet weak var crawlButton :UIButton!
    /** The loading indicator. */
    @IBOutlet weak var loadingIndicator :UIActivityIndicatorView!
    /** The 'HTML output' text view. */
    @IBOutlet weak var htmlOutputText :UITextView!

    /** The reference to the text field delegate. TODO remove all redundant type definitions! */
    var textFieldDelegate :TextFieldDelegate = TextFieldDelegate()

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
        urlInputField.delegate = textFieldDelegate
        urlInputField.borderStyle = .none
        urlInputField.text = DEFAULT_URL

        // set round corners for all UI elements
        UI.setRoundCorners( view: urlInputField )
        UI.setRoundCorners( view: titleLabel )
        UI.setRoundCorners( view: crawlButton )
        UI.setRoundCorners( view: loadingIndicator )
        UI.setRoundCorners( view: htmlOutputText )

        // enable user input
        self.setUserInputEnabled( enabled: true )
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
        let insertedUrlText :String = urlInputField.text!

        // create URL and break if invalid
        guard let url:URL = URL( string: insertedUrlText ) else
        {
            // log invalid URL
            print( "The inserted URL [" + insertedUrlText + "] is invalid!" )
            appendHtmlOutputFieldText( msg: "The inserted URl [" + insertedUrlText + "] is invalid!", color: UIColor.red )

            return
        }

        // hide input fields
        self.setUserInputEnabled( enabled: false )

        // log URL to crawl
        Debug.log( "Connect to URL [" + url.description + "]" )
        appendHtmlOutputFieldText( msg: "Connecting to URL [" + url.description + "]", color: UIColor.orange )

        // perform an URL connection
        IO.performUrlConnection( url: url, delegate: self )
    }

    /**
     *  Enabled or disables user input.
     *
     *  @param enabled If the user input elements shall be enabled or disabled.
     */
    func setUserInputEnabled( enabled:Bool ) -> Void
    {
        self.crawlButton.isHidden   = !enabled
        self.urlInputField.isHidden = !enabled

        self.loadingIndicator.isHidden = enabled
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
        let string           :String                           = ( msg + "\n" )
        let attributes       :[ NSAttributedString.Key : Any ] = [ NSAttributedString.Key.foregroundColor: color ]
        let attributesString :NSAttributedString               = NSAttributedString( string: string, attributes: attributes )

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
    // TODO enum return value!
    func receiveUrlCallback( data:Data?, response:URLResponse?, error:Error? ) -> Void
    {
        // check for a connection error
        if let error:Error = error
        {
            self.showResultAndEnableUserInput(
                msg: "Error occured on connecting: [" + error.localizedDescription + "]",
                color: UIColor.red
            )

            return
        }

        // pick text data
        guard let data:Data = data, let htmlString:String = String( data: data, encoding: .utf8 ) else
        {
            // TODO Return enum constants !!
            self.showResultAndEnableUserInput(
                msg: "Error! Data could not be converted to text!",
                color: UIColor.red
            )

            return
        }

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
        let croppedHtmlString  :String = String( htmlString.prefix( 75 ) )
        let replacedHtmlString :String = croppedHtmlString.replacingOccurrences( of: "\n", with: " " )
        print( replacedHtmlString )

        self.showResultAndEnableUserInput(
            msg: "Crawled [" + String( htmlString.count ) + "] bytes",
            color: UIColor.green
        )
    }

    /**
     *  Outputs the result in the HTML output dialog and shows the user input fields.
     *  These operations are performed on the Main Thread.
     *
     *  @param msg   The message to show in the Output Text field.
     *  @param color The color for the message to append in the Output Text field.
     */
    func showResultAndEnableUserInput( msg:String, color:UIColor )
    {
        // run on the main thread
        DispatchQueue.main.async
        {
            // show the error in the HTML output
            self.appendHtmlOutputFieldText( msg: msg, color: color )

            // show the input components again
            self.setUserInputEnabled( enabled: true )
        }
    }
}
