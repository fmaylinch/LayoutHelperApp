
/**
 * Bar that displays some progress.
 *
 * It's built with image sections like this: [===----]
 * The number of sections is adjusted depending on the available width,
 * and the number of filled sections depends on the `fillFactor`.
 */

import UIKit

class G4LProgressBar : LinearLayout {

    private static let SectionWidth: CGFloat = 15

    private let fillFactor: Double
    private let availableWidth: CGFloat
    private let sectionImages: [UIImage]
    private var linear : LinearLayout!

    init(fillFactor: Double, availableWidth: CGFloat)
    {
        self.fillFactor = fillFactor
        self.availableWidth = availableWidth
        self.sectionImages = G4LProgressBar.loadSectionImages()
        super.init(orientation: .Horizontal)
        setupViews()
    }

    func setupViews()
    {
        print("G4LProgressBar setup with width \(availableWidth)")

        let info = SectionsInfo(availableWidth: availableWidth, fillFactor: fillFactor)

        // Left edge
        addSection(info.leftEdgeOn ? EDGE_LEFT_ON_IDX : EDGE_LEFT_OFF_IDX)

        // Middle sections on
        if info.numMiddleOn >= 1 {
            for i in 1 ... info.numMiddleOn {
                addSection(MIDDLE_ON_IDX)
            }
        }

        // Middle on-off transition
        if info.includeOnOff {
            addSection(MIDDLE_ON_OFF_IDX)
        }

        // Middle sections off
        if info.numMiddleOff >= 1 {
            for i in 1 ... info.numMiddleOff {
                addSection(MIDDLE_OFF_IDX)
            }
        }

        // Right edge
        addSection(info.rightEdgeOn ? EDGE_RIGHT_ON_IDX : EDGE_RIGHT_OFF_IDX)
    }

    func addSection(sectionIndex: Int)
    {
        let img = UIImageView(image: sectionImages[sectionIndex])

        let width = sectionIndex == MIDDLE_ON_OFF_IDX ? // on-off section has double size
                G4LProgressBar.SectionWidth * 2 : G4LProgressBar.SectionWidth

        appendSubview(img, size: width)
    }

    // Index in sectionImages
    let EDGE_LEFT_OFF_IDX = 0
    let EDGE_LEFT_ON_IDX = 1
    let EDGE_RIGHT_OFF_IDX = 2
    let EDGE_RIGHT_ON_IDX = 3
    let MIDDLE_OFF_IDX = 4
    let MIDDLE_ON_IDX = 5
    let MIDDLE_ON_OFF_IDX = 6

    class func loadSectionImages() -> [UIImage]
    {
        var images = [UIImage]()

        images.append(UIImage(named: "bar_edge_left_off")!)
        images.append(UIImage(named: "bar_edge_left_on")!)
        images.append(UIImage(named: "bar_edge_right_off")!)
        images.append(UIImage(named: "bar_edge_right_on")!)
        images.append(UIImage(named: "bar_middle_off")!)
        images.append(UIImage(named: "bar_middle_on")!)
        images.append(UIImage(named: "bar_middle_on_off")!)

        return images
    }


    /**
     * Info about the sections to be drawn.
     * Note all sections have the same width except for the on-off transition section, that takes twice the space.
     * When there's a partial fill, we always draw the on-off section, and we have to consider it measures 2 sections.
     */
    class SectionsInfo {

        var leftEdgeOn = false
        var rightEdgeOn = false
        var includeOnOff = false
        var numSections = 0
        var numSectionsFilled = 0
        var numMiddleOn = 0
        var numMiddleOff = 0

        init(availableWidth: CGFloat, fillFactor: Double)
        {
            leftEdgeOn = fillFactor > 0
            rightEdgeOn = fillFactor == 1

            numSections = Int( availableWidth / G4LProgressBar.SectionWidth )
            numSectionsFilled = Int( Double(numSections) * fillFactor )

            // When there's a partial fill, always include the on-off section
            includeOnOff = fillFactor > 0 && numSectionsFilled < numSections

            // Case when the fill is very small
            if leftEdgeOn && numSectionsFilled < 2 {
                numSectionsFilled = 2; // Always draw up to the on-off transition
            }

            // Case when the fill is almost complete
            if numSectionsFilled == numSections-1 {
                numSectionsFilled = numSections-2 // Leave last two sections off: one for right edge and another for the right half of on-off section
            }

            // One section will be filled by left edge, and another by left half of on-off or right edge sections
            numMiddleOn = max(0, numSectionsFilled - 2)

            numMiddleOff = numSections - numMiddleOn - 2 // 2 for the edges
            if includeOnOff {
                numMiddleOff -= 2 // 2 for the on-off section
            }
        }
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
