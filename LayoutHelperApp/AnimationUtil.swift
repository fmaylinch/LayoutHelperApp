
import UIKit

class AnimationUtil {

    /**
     * Scales view in both dimensions (respecting ratio).
     * For the scale argument, use `d/c` where `d` is the desired ratio and `c` the current ratio (initially 1).
     */
    class func scaleView(view: UIView, scale: Float) {
        view.transform = CGAffineTransformScale(view.transform, CGFloat(scale), CGFloat(scale))
    }
}
