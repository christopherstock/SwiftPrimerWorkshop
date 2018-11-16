import UIKit

/**
 *  Contains the Input URL text field's delegate.
 */
class TextFieldDelegate : ViewController, UITextFieldDelegate
{
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
}
