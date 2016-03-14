
/** Stats about the clubber rewards */

import UIKit

class RewardsView : LinearLayout {

    let helpBtn = UIView()
    let helpIcon = ViewUtil.labelWithSize(22)

    init()
    {
        super.init(orientation: .Vertical)

        appendSubview( buildHeader() )
    }

    func buildHeader() -> UIView
    {
        let trophy = ViewUtil.imageScaled("rewards_trophy")

        let title = ViewUtil.labelWithSize(28)
        title.text = "GYMFORLESS REWARDS" // TODO: "rewards_info_title".localized.uppercaseString
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true

        let helpBtnSize: Float = 50
        let helpBtn = buildHelpButton(helpBtnSize)
        // TODO: helpBtn.hidden = true (display when we get the RewardsConfig)

        return LayoutHelper()
            .addViews(["trophy":trophy, "title":title, "helpBtn":helpBtn])
            .withMetrics(["ts":80, "hbs": helpBtnSize])
            .addConstraints([
                "H:|[trophy(ts)]-(15)-[title]-[helpBtn(hbs)]|",
                "V:|[trophy(ts)]|", "V:|[title]|",
                "V:[helpBtn(hbs)]",
                "X:helpBtn.centerY == parent.centerY"
            ])
            .view
    }

    /** Button with the "?" character */
    func buildHelpButton(size: Float) -> UIView
    {
        helpIcon.text = "?"
        helpIcon.textAlignment = .Center
        helpIcon.textColor = .whiteColor()
        helpIcon.backgroundColor = ViewUtil.MainColor

        // Padding so clickable area is bigger
        let pad: CGFloat = 10
        return LayoutHelper(view: helpBtn)
            .fillWithView(helpIcon, margins: UIEdgeInsetsMake(pad, pad, pad, pad))
            .view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Make helpIcon circular
        layoutIfNeeded() // so helpIcon.frame is calculated
        helpIcon.layer.cornerRadius = helpIcon.frame.size.height / 2.0
        helpIcon.layer.masksToBounds = true
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
