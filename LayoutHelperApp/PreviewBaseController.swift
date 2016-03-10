
/**
 * Controller to preview the layout
 *
 * TODO: make processGenericSetProperty support things like:
 *
 * label.layer.borderColor = UIColor.whiteColor().CGColor
 * label.textAlignment = .Center
 */

import UIKit

class PreviewBaseController: UIViewController, UIGestureRecognizerDelegate {
    
    // This is the view you should use (not the controller view)
    @IBOutlet weak var mainView: UIView!
    
    // Constraints of container view
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    // View that can be dragged to resize the container view
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dragLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragView()
        resetView()
    }
    
    @IBAction func reloadCode(sender: AnyObject) {
        print("Reseting view")
        resetView()
    }
    
    private func resetView() {
        
        for view in mainView.subviews {
            view.removeFromSuperview()
        }
        
        setupViews()
    }
    
    /** Override and add views to mainView */
    func setupViews() { }
    
    /** Convenience func, just not to forget to use LayoutHelper(controller:) in the real app controller */
    func __LayoutHelper(controller controller: UIViewController) -> LayoutHelper
    {
        // Use mainView, not the controller.view
        return LayoutHelper(view: mainView)
    }

    
    // --- Dragging to resize container view ---
    
    /** When dragView is dragged, the container view will be resized through the constraints */
    private func setupDragView()
    {
        dragLabel.text = "\u{f0b2}" // fa-arrows-alt
        dragLabel.font = ViewUtil.fontAwesomeWithSize(30)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("drag:"))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        dragView.addGestureRecognizer(panRecognizer)
    }
    
    private var currentWidth: CGFloat = 0
    private var currentHeight: CGFloat = 0
    
    func drag(panRecognizer: UIPanGestureRecognizer) {
        
        let point = panRecognizer.translationInView(dragView)
        
        if panRecognizer.state == .Began {
            currentWidth = containerWidth.constant
            currentHeight = containerHeight.constant
        }
        
        containerWidth.constant = currentWidth + point.x
        containerHeight.constant = currentHeight + point.y
        
        self.view.setNeedsUpdateConstraints()
    }
    
    
    // -- Buttons for quick resize --
    
    @IBAction func resizeToIPhone4(sender: UIButton) {
        resizeContainerTo(width: 320, height: 416)
    }
    
    @IBAction func resizeToIPhone5(sender: UIButton) {
        resizeContainerTo(width: 320, height: 504)
    }
    
    @IBAction func resizeToIPhone6(sender: UIButton) {
        resizeContainerTo(width: 375, height: 603)
    }
    
    @IBAction func resizeToIPhone6p(sender: UIButton) {
        resizeContainerTo(width: 414, height: 672)
    }
    
    func resizeContainerTo(width width: CGFloat, height: CGFloat)
    {
        self.containerWidth.constant = width
        self.containerHeight.constant = height
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
