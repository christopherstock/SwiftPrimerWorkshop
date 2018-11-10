import UIKit

class ViewController: UIViewController
{
    /** The 'Crawl it!' button. */
    @IBOutlet weak var crawlButton: UIButton!

    /**
     *  Being invoked when the view controller is fully loaded.
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()

        Debug.log( "ViewController.viewDidLoad()" )
    }


    /** Being invoked when the button is pressed. */
    @IBAction func onPressCrawlButton( _ sender: Any )
    {
        Debug.log( "Crawl Button pressed" )


    }
}
