
/**
 * Use this controller to try your layouts.
 * Override `setupViews` and add your views to `mainView` (not to `view`).
 */

import UIKit

class PreviewController: PreviewBaseController {
    
    override func setupViews() {
        
        // Use mainView instead of view
        mainView.backgroundColor = .whiteColor()
        
        // LinearLayout is a simple adaptation of Android's LinearLayout
        let linear = LinearLayout(orientation: .Vertical)

        linear.marginEnds = 30
        linear.marginSides = 20
        linear.marginBetween = 10

        for i in 1...10 {
            let view = createSampleView("View \(i)")
            linear.appendSubview(view)
        }
        
        // Example of scroll view
        // Note: In your real controller, use LayoutHelper(controller:) normally
        __LayoutHelper(controller: self).fillWithScrollView(.Vertical, contentView:linear)
    }

    /** Example of view configured with LayoutHelper */
    func createSampleView(text: String) -> UIView
    {
        let view = UIView()
        view.backgroundColor = ViewUtil.color(argb: 0x50905070)

        let title = ViewUtil.labelWithSize(50)
        title.text = text
        title.backgroundColor = .whiteColor()

        let subtitle = ViewUtil.labelWithSize(30)
        subtitle.text = "Long text that may not fit"
        subtitle.backgroundColor = .whiteColor()

        let icon = ViewUtil.labelAwesome("\u{f179}", size: 30)
        icon.backgroundColor = .whiteColor()

        LayoutHelper(view: view)
            .addViews(["title":title, "subtitle":subtitle, "icon":icon])
            .addConstraints([
                "H:|-[subtitle]-[icon]-|",
                "V:|-[title]-[subtitle]-|",
                "V:|-[title]-[icon]-|",
                "X:title.centerX == parent.centerX"      // Extra constraint format, supported by LayoutHelper
            ])
            .setWrapContent("icon", axis: .Horizontal)   // icon will take only the space it needs and won't be compressed

        return view
    }
}
