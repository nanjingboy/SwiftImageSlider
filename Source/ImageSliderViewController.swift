import UIKit

public class ImageSliderViewController: UIViewController, ImageSliderViewDelegate {

    let imageSliderView: ImageSliderView
    let displayLabel = UILabel()

    public init(currentIndex: Int, imageUrls: [String]) {
        imageSliderView = ImageSliderView(currntIndex: currentIndex, imageUrls: imageUrls)
        super.init(nibName: nil, bundle: nil)
        imageSliderViewImageSwitch(currentIndex, count: imageUrls.count, imageUrl: imageUrls[currentIndex])
    }

    public required init?(coder aDecoder: NSCoder) {
        imageSliderView = ImageSliderView(currntIndex: 0, imageUrls: [])
        super.init(coder: aDecoder)
        imageSliderViewImageSwitch(0, count: 0, imageUrl: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.blackColor()

        imageSliderView.delegate = self
        imageSliderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageSliderView)
        setImageSliderViewConstraints()

        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.textColor = UIColor.whiteColor()

        view.addSubview(displayLabel)
        setDisplayLabelConstraints()
    }

    public func setImageSliderViewConstraints() {
        let imageSliderViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageSliderView]-0-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["imageSliderView": imageSliderView])
        view.addConstraints(imageSliderViewHConstraints)

        let imageSliderViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageSliderView]-0-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["imageSliderView": imageSliderView])
        view.addConstraints(imageSliderViewVConstraints)
    }

    public func setDisplayLabelConstraints() {
        let constraint = NSLayoutConstraint(item: displayLabel,
                                            attribute: NSLayoutAttribute.CenterX,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: view,
                                            attribute: NSLayoutAttribute.CenterX,
                                            multiplier: 1.0,
                                            constant: 0.0)
        view.addConstraint(constraint)

        let displayLabelVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-20-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["label": displayLabel])
        view.addConstraints(displayLabelVConstraints)
    }

    public func imageSliderViewSingleTap(tap: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    public func imageSliderViewImageSwitch(index: Int, count: Int, imageUrl: String?) {
        displayLabel.text = "\(index + 1) / \(count)"
    }
}