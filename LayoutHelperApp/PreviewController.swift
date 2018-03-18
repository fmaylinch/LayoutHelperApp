
/**
 * Use this controller to try your layouts.
 * In `setupViews` configure your view using the given builder.
 * In your real controller create your LayoutBuilder(controller: self) normally.
 */

import UIKit

class PreviewController: PreviewBaseController {
    
    override func setupViews(builder: LayoutBuilder) {
        
        // builder.view is the view that the builder is configuring
        builder.view.backgroundColor = .white
        
        // LinearLayout is similar to Android's LinearLayout
        let linear = LinearBuilder(axis: .vertical)
            .margins(ends: 30, sides: 20, between: 10)

        for i in 1...10 {
            let view = createSampleView(text: "View \(i)")
            linear.addView(view)
        }
        
        // Example of scroll view
        builder.fillWithScrollView(.vertical, contentView: linear.getView())
    }

    /** Example of view configured with LayoutHelper */
    func createSampleView(text: String) -> UIView
    {
        let view = UIView()
        view.backgroundColor = .lightGray

        let builder = LabelBuilder().backColor(.white)
        
        let title = builder.size(50).text(text).build()
        let subtitle = builder.size(30).text("Text that maybe is too long").build()
        let icon = builder.fontAwesomeSize(30).text("\u{f179}\u{f179}\u{f179}").build()
        
        let subtitleRow = LinearBuilder(axis: .horizontal)
            .margin(between: 5)
            .addViews([subtitle, icon])
            .wrapContent(view: icon) // similar to Android's wrap_content
            .getView()

        LayoutBuilder(view: view)
            .addViews(["title":title, "subTitleRow":subtitleRow])
            .addConstraints([
                "V:|-[title]-[subTitleRow]-|",
                "H:|-[subTitleRow]-|",
                "X:title.centerX == parent.centerX"      // extra constraint format, supported by LayoutBuilder
            ])

        return view
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Detect ambiguities in layout. Use only when debugging.
        if view.hasAmbiguousLayout {
            print("Layout is ambiguous!")
            view.exerciseAmbiguityInLayout()
        } else {
            // print("Layout doesn't have ambiguities")
        }
    }
}
