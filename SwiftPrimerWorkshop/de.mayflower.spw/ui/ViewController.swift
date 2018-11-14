import UIKit

/**
 *  The View Controller that holds all UI components of the main view.
 */
class ViewController: UIViewController, UITextFieldDelegate
{
    /** The default URL for the URL input field. */
    let DEFAULT_URL :String = "http://www.google.de"

    // MARK: InterfaceBuilder Outlets

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

        Debug.log( "ViewController.viewDidLoad()" )

        // set input field's delegate
        urlInputField.delegate = self
        urlInputField.borderStyle = .none
        urlInputField.layer.masksToBounds = true
        urlInputField.layer.cornerRadius = 5
        urlInputField.text = DEFAULT_URL

        // round corners for title label
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5

        // round corners for crawl button
        crawlButton.layer.masksToBounds = true
        crawlButton.layer.cornerRadius = 5

        // round corners for loading circle
        loadingIndicator.layer.masksToBounds = true
        loadingIndicator.layer.cornerRadius = 5

        // round corners for text output field
        htmlOutputText.layer.masksToBounds = true
        htmlOutputText.layer.cornerRadius = 5

        // acclaim
        htmlOutputText.text.append( "Welcome to the Wuzzy Web Crawler." + "\n" )
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
        loadingIndicator.startAnimating()
        // hide input fields
        urlInputField.isHidden = true
        crawlButton.isHidden = true

        // perform an URL connection
        performUrlConnection( url: urlToConnect )
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

    /**
     *  Performs a connection to the specified URL.
     *
     *  @param url The URL to crawl.
     */
    func performUrlConnection( url:String )
    {
        Debug.log( "ViewController.performUrlConnection()" )
        Debug.log( "Connect to URL [" + url + "]" )

        htmlOutputText.text.append( "Connecting to URL [" + url + "]" + "\n" )













    }
}
