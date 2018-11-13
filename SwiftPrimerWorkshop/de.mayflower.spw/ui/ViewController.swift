import UIKit

/**
 *  The View Controller that holds all UI components of the main view.
 */
class ViewController: UIViewController, UITextFieldDelegate
{
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
    }

    // MARK: InterfaceBuilder Actions

    /**
     *  Being invoked when the 'Crawl it!' button is pressed.
     */
    @IBAction func onPressCrawlButton( _ sender: UIButton )
    {
        Debug.log( "ViewController.onPressCrawlButton" )

        htmlOutputText.text = (
            "Button pressed at "
            + DateFormatter().description
            + "\n"
            + "Input field text is:\n"
            + urlInputField.text!
        )



        
/*
        urlInputField.isEnabled = false
        crawlButton.isEnabled   = false
*/
        loadingIndicator.startAnimating()




    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn( _ textField: UITextField ) -> Bool
    {
        Debug.log( "ViewController.textFieldShouldReturn" )

        // hide the keyboard.
        textField.resignFirstResponder()

        return true
    }

    /**
     *  Being invoked when the text field
     */
    func textFieldDidEndEditing( _ textField: UITextField ) -> Void
    {
        Debug.log( "ViewController.textFieldDidEndEditing" )
    }
}
