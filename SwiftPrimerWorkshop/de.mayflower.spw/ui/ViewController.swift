import UIKit

class ViewController: UIViewController
{
    // MARK: InterfaceBuilder Outlets

    /** The 'URL input' text field. */
    @IBOutlet weak var urlInputField  :UITextField!
    /** The 'Crawl it!' button. */
    @IBOutlet weak var crawlButton    :UIButton!
    /** The 'HTML output' text view. */
    @IBOutlet weak var htmlOutputText :UITextView!

    /**
     *  Being invoked when the view controller is fully loaded.
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()

        Debug.log( "ViewController.viewDidLoad()" )
    }

    // MARK: InterfaceBuilder Actions

    /** Being invoked when the 'Crawl it!' button is pressed. */
    @IBAction func onPressCrawlButton( _ sender: UIButton )
    {
        Debug.log( "Crawl Button pressed" )

        htmlOutputText.text = (
            "Button pressed at "
            + DateFormatter().description
            + "\n"
            + "Input field text is:\n"
            + urlInputField.text!
        )





    }
}
