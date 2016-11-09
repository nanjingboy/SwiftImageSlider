import UIKit

open class ImageSliderView: UIView, UIScrollViewDelegate, ImageSliderCellDelegate {

    fileprivate var currentIndex: Int
    fileprivate var sliderCells: [ImageSliderCell] = []
    fileprivate var isUpdatingCellFrames = false

    open var delegate: ImageSliderViewDelegate?
    open let scrollView = UIScrollView()

    open override var bounds: CGRect {
        didSet {
            updateCellFrames()
        }
    }

    public init(currntIndex: Int, imageUrls: [String]) {
        self.currentIndex = currntIndex
        super.init(frame: CGRect.zero)
        initialize(imageUrls)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.currentIndex = 0
        super.init(coder: aDecoder)
        initialize([])
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (isUpdatingCellFrames) {
            isUpdatingCellFrames = false
            return
        }
        self.scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        let width = self.scrollView.frame.width
        let index = Int(floor((self.scrollView.contentOffset.x - width / 2) / width) + 1)
        if (currentIndex != index) {
            switchImage(index)
        }
    }

    func initialize(_ imageUrls: [String]) {
        clipsToBounds = false

        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizesSubviews = false
        scrollView.autoresizingMask = UIViewAutoresizing()
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
        scrollView.contentSize = CGSize(width: sliderViewFrame.size.width * CGFloat(pageCount),
                                            height: sliderViewFrame.size.height * CGFloat(pageCount))

        scrollView.contentOffset = CGPoint(x: CGFloat(currentIndex) * sliderViewFrame.size.width, y: 0)
        let scrollViewBounds = scrollView.bounds
        for index in 0 ..< pageCount {
            let sliderCell = sliderCells[index]
            sliderCell.frame = CGRect(x: scrollViewBounds.width * CGFloat(index),
                                          y: scrollViewBounds.minY,
                                          width: scrollViewBounds.width,
                                          height: scrollViewBounds.height)
        }

        switchImage(currentIndex)
    }

    func switchImage(_ index: Int) {
        let sliderCell = sliderCells[index]
        sliderCell.loadImage()
        currentIndex = index
        delegate?.imageSliderViewImageSwitch(index, count: sliderCells.count, imageUrl: sliderCell.imageUrl)
    }

    func imageSliderCellSingleTap(_ tap: UITapGestureRecognizer) {
        delegate?.imageSliderViewSingleTap(tap)
    }
}
