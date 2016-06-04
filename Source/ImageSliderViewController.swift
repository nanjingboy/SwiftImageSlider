import UIKit

public class ImageSliderViewController: UIViewController, UIScrollViewDelegate, ImageSliderCellDelegate {

    private var currentIndex: Int
    private let imageCount: Int
    private let imageUrls: [String]

    private let displayLabel = UILabel()
    private let scrollView = UIScrollView()

    public init(currentIndex: Int, imageUrls: [String]) {
        self.currentIndex = currentIndex
        self.imageUrls = imageUrls
        self.imageCount = imageUrls.count
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.currentIndex = 0
        self.imageUrls = []
        self.imageCount = 0
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.blackColor()

        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizesSubviews = false
        scrollView.autoresizingMask = UIViewAutoresizing.None
        view.addSubview(scrollView)

        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.textColor = UIColor.whiteColor()
        view.addSubview(displayLabel)
        setDisplayLabelConstraints()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let scrollViewframe = self.view.bounds
        scrollView.frame = scrollViewframe
        scrollView.contentSize = CGSizeMake(scrollViewframe.size.width * CGFloat(imageCount),
                                            scrollViewframe.size.height * CGFloat(imageCount))
        scrollView.contentOffset = CGPointMake(CGFloat(currentIndex) * scrollViewframe.size.width, 0)
        let scrollViewBounds = scrollView.bounds
        for index in 0 ..< imageCount {
            let sliderCell = ImageSliderCell(imageUrl: imageUrls[index])
            sliderCell.frame = CGRectMake(CGRectGetWidth(scrollViewBounds) * CGFloat(index),
                                          CGRectGetMinY(scrollViewBounds),
                                          CGRectGetWidth(scrollViewBounds),
                                          CGRectGetHeight(scrollViewBounds))
            sliderCell.delegate = self
            scrollView.addSubview(sliderCell)
        }

        switchImage(currentIndex)
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

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
        let width = CGRectGetWidth(self.scrollView.frame);
        let index = Int(floor((self.scrollView.contentOffset.x - width / 2) / width) + 1)
        if (currentIndex != index) {
            switchImage(index)
        }
    }

    public func imageSliderCellSingleTap(tap: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func switchImage(index: Int) {
        let sliderCell = scrollView.subviews[index] as! ImageSliderCell
        sliderCell.loadImage()
        currentIndex = index
        displayLabel.text = "\(currentIndex + 1) / \(imageCount)"
    }
}