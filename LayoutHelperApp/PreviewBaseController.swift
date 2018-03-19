
/**
 * Controller to preview the layout
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
    
    @IBAction func reloadCode(_ sender: Any) {
        print("Reseting view")
        resetView()
    }
    
    private func resetView() {
        
        for view in mainView.subviews {
            view.removeFromSuperview()
        }
        
        setupViews(builder: LayoutBuilder(view: mainView))
    }
    
    /** Override to configure the view using this builder */
    func setupViews(builder: LayoutBuilder) { }
    
    
    // --- Dragging to resize container view ---
    
    /** When dragView is dragged, the container view will be resized through the constraints */
    private func setupDragView()
    {
        dragLabel.text = "\u{f0b2}" // fa-arrows-alt
        dragLabel.font = ViewUtil.fontAwesomeWithSize(30)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(drag(panRecognizer:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        dragView.addGestureRecognizer(panRecognizer)
    }
    
    private var currentWidth: CGFloat = 0
    private var currentHeight: CGFloat = 0
    
    func drag(panRecognizer: UIPanGestureRecognizer) {
        
        let point = panRecognizer.translation(in: dragView)
        
        if panRecognizer.state == .began {
            currentWidth = containerWidth.constant
            currentHeight = containerHeight.constant
        }
        
        containerWidth.constant = currentWidth + point.x
        containerHeight.constant = currentHeight + point.y
        
        self.view.setNeedsUpdateConstraints()
    }
    
    
    // -- Buttons for quick resize --
    
    @IBAction func resizeToIPhone4(_ sender: Any) {
        resizeContainerTo(width: 320, height: 416)
    }
    
    @IBAction func resizeToIPhone5(_ sender: Any) {
        resizeContainerTo(width: 320, height: 504)
    }
    
    @IBAction func resizeToIPhone6(_ sender: Any) {
        resizeContainerTo(width: 375, height: 603)
    }
    
    @IBAction func resizeToIPhone6p(_ sender: Any) {
        resizeContainerTo(width: 414, height: 672)
    }
    
    func resizeContainerTo(width: CGFloat, height: CGFloat)
    {
        self.containerWidth.constant = width
        self.containerHeight.constant = height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
