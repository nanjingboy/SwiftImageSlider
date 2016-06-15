import UIKit

public class ImageSliderView: UIView, UIScrollViewDelegate, ImageSliderCellDelegate {

    var delegate: ImageSliderViewDelegate?

    private var currentIndex: Int

    private let scrollView = UIScrollView()
    private var sliderCells: [ImageSliderCell] = []
    private var isUpdatingCellFrames = false

    public override var bounds: CGRect {
        didSet {
            updateCellFrames()
        }
    }

    public init(currntIndex: Int, imageUrls: [String]) {
        self.currentIndex = currntIndex
        super.init(frame: CGRectZero)
        initialize(imageUrls)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.currentIndex = 0
        super.init(coder: aDecoder)
        initialize([])
    }

    func initialize(imageUrls: [String]) {
        clipsToBounds = false

        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizesSubviews = false
        scrollView.autoresizingMask = UIViewAutoresizing.None
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        for imageUrl in imageUrls {
            let sliderCell = ImageSliderCell(imageUrl: imageUrl)
            sliderCell.delegate = self
            sliderCells.append(sliderCell)
            scrollView.addSubview(sliderCell)
        }

        addSubview(scrollView)
    }

    func updateCellFrames() {
        let pageCount = sliderCells.count
        let sliderViewFrame = bounds

        isUpdatingCellFrames = true
        scrollView.frame = sliderViewFrame
        scrollView.contentSize = CGSizeMake(sliderViewFrame.size.width * CGFloat(pageCount),
                                            sliderViewFrame.size.height * CGFloat(pageCount))

        scrollView.contentOffset = CGPointMake(CGFloat(currentIndex) * sliderViewFrame.size.width, 0)
        let scrollViewBounds = scrollView.bounds
        for index in 0 ..< pageCount {
            let sliderCell = sliderCells[index]
            sliderCell.frame = CGRectMake(CGRectGetWidth(scrollViewBounds) * CGFloat(index),
                                          CGRectGetMinY(scrollViewBounds),
                                          CGRectGetWidth(scrollViewBounds),
                                          CGRectGetHeight(scrollViewBounds))
        }

        switchImage(currentIndex)
    }

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if (isUpdatingCellFrames) {
            isUpdatingCellFrames = false
            return
        }
        self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
        let width = CGRectGetWidth(self.scrollView.frame)
        let index = Int(floor((self.scrollView.contentOffset.x - width / 2) / width) + 1)
        if (currentIndex != index) {
            switchImage(index)
        }
    }

    public func switchImage(index: Int) {
        let sliderCell = sliderCells[index]
        sliderCell.loadImage()
        currentIndex = index
        delegate?.imageSliderViewImageSwitch(index, count: sliderCells.count, imageUrl: sliderCell.imageUrl)
    }

    func imageSliderCellSingleTap(tap: UITapGestureRecognizer) {
        delegate?.imageSliderViewSingleTap(tap)
    }
}