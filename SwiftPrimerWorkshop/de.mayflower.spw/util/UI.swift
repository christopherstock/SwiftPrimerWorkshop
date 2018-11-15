import UIKit

/**
 *  Offers utility UI functionality.
 */
class UI
{
    /**
     *  Rounds the rects of the specified UI element.
     *
     *  @param view The UIView element to round the corners for.
     */
    static func setRoundCorners( view:UIView )
    {
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = 5
    }
}
