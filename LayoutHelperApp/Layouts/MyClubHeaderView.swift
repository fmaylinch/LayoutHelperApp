
/** Header in My Club screen */

import UIKit

class MyClubHeaderView : UIView {

    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = ViewUtil.color(rgb: 0x4b4b4b)
        
        let shield = ViewUtil.imageScaled("club_shield_pink")

        let title = ViewUtil.labelWithSize(32)
        title.text = "GYMFORLESS\nCLUB PREMIUM"
        title.numberOfLines = 2
        title.textColor = .whiteColor()
        title.adjustsFontSizeToFitWidth = true

        let gymsBtn = button("LE MIE PALESTRE", size:13, img:"menu_gym@3x", action:goToGyms)
        let activitiesBtn = button("LE MIE ATTIVITÀ", size:13, img:"menu_events@3x", action:goToActivities)
        let accessBtn = button("MI ACCESO", size:20, img:"coupon_white_big", action:goToAccess)

        let brand = LayoutHelper()
            .addViews([
                "shield":shield, "title":title,
                "gymsBtn":gymsBtn, "activitiesBtn":activitiesBtn,
                "accessBtn":accessBtn])
            .addConstraints([
                "H:|[shield(90)]-(20)-[title]|",
                "X:title.centerY == shield.centerY",
                "H:|[gymsBtn]-(10)-[activitiesBtn(==gymsBtn)]|",
                "H:|[accessBtn]|",
                "V:[shield(110)]",
                "V:|[shield]-[gymsBtn]-[accessBtn]|",
                "V:|[shield]-[activitiesBtn]-[accessBtn]|"
            ]).view

        LayoutHelper(view: self)
            .fillWithView(brand, margins: UIEdgeInsetsMake(20, 30, 20, 30))
    }
    
    func goToGyms() {
        print("goToGyms")
    }
    
    func goToActivities() {
        print("goToActivities")
    }
    
    func goToAccess() {
        print("goToAccess")
    }
    
    func button(text:String, size:Float, img:String, action:() -> ()) -> UIView
    {
        let textSize = size
        let imageHeight = size * 2
        let imageWidth = imageHeight * 2/3
        
        let label = ViewUtil.labelWithSize(textSize)
        label.text = text
        label.textColor = .whiteColor()

        let image = ViewUtil.imageScaled(img)

        // Layout with image and text
        let content = LayoutHelper()
            .addViews(["label":label, "image":image])
            .withMetrics(["iw":imageWidth, "ih":imageHeight])
            .addConstraints([
                "H:|[image(iw)]-[label]|",
                "V:|[label]|", "V:|[image(ih)]|"
            ])
            .view

        let view = ButtonView()
        
        // Center content in parent
        LayoutHelper(view: view)
            .addViews(["content":content])
            .addConstraints([
                "H:|-(>=3)-[content]-(>=3)-|",
                "X:content.centerX == parent.centerX",
                "V:|-(4)-[content]-(4)-|"
            ])

        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        
        view.onNormal = { $0.backgroundColor = .clearColor() }
        view.onPressed = { $0.backgroundColor = ViewUtil.color(argb: 0x33FFFFFF) }
        view.action = action

        return view
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
