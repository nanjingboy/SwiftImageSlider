import UIKit

open class ImageSliderViewController: UIViewController, ImageSliderViewDelegate {

    open let imageSliderView: ImageSliderView
    open let displayLabel = UILabel()

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

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black

        imageSliderView.delegate = self
        imageSliderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageSliderView)
        setImageSliderViewConstraints()

        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.textColor = UIColor.white

        view.addSubview(displayLabel)
        setDisplayLabelConstraints()
    }

    open func setImageSliderViewConstraints() {
        let imageSliderViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageSliderView]-0-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["imageSliderView": imageSliderView])
        view.addConstraints(imageSliderViewHConstraints)

        let imageSliderViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageSliderView]-0-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["imageSliderView": imageSliderView])
        view.addConstraints(imageSliderViewVConstraints)
    }

    open func setDisplayLabelConstraints() {
        let constraint = NSLayoutConstraint(item: displayLabel,
                                            attribute: NSLayoutAttribute.centerX,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: view,
                                            attribute: NSLayoutAttribute.centerX,
                                            multiplier: 1.0,
                                            constant: 0.0)
        view.addConstraint(constraint)

        let displayLabelVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-20-|",
                                                                                      options: [],
                                                                                      metrics: nil,
                                                                                      views: ["label": displayLabel])
        view.addConstraints(displayLabelVConstraints)
    }

    open func imageSliderViewSingleTap(_ tap: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    open func imageSliderViewImageSwitch(_ index: Int, count: Int, imageUrl: String?) {
        displayLabel.text = "\(index + 1) / \(count)"
    }
}
