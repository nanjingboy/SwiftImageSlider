import UIKit
import Kingfisher
import Toast_Swift

class ImageSliderCell: UIView, UIScrollViewDelegate {

    var delegate: ImageSliderCellDelegate?
    let imageUrl: String

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()

    override var frame: CGRect {
        didSet {
            if !CGRectEqualToRect(frame, CGRectZero) {
                scrollView.frame = bounds
                resetZoomScale()
                drawImage()
            }
        }
    }

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(frame: CGRectZero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        self.imageUrl = ""
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        imageView.contentMode = UIViewContentMode.ScaleAspectFit

        scrollView.clipsToBounds = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate /= 2
        scrollView.bouncesZoom = true
        scrollView.addSubview(imageView)
        addSubview(scrollView)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(imageSliderCellDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageSliderCellSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.requireGestureRecognizerToFail(doubleTap)
        scrollView.addGestureRecognizer(singleTap)
    }

    func imageSliderCellDoubleTap(tap: UITapGestureRecognizer) {
        let touchPoint = tap.locationInView(self)
        if (scrollView.zoomScale == scrollView.minimumZoomScale) {
            scrollView.zoomToRect(CGRectMake(touchPoint.x, touchPoint.y, 1, 1), animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }

    func imageSliderCellSingleTap(tap: UITapGestureRecognizer) {
        delegate?.imageSliderCellSingleTap(tap)
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        imageView.center = centerOfScrollView(scrollView)
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        UIView.animateWithDuration(0.25) {
            view?.center = self.centerOfScrollView(scrollView)
        }
    }

    func loadImage() {
        if let _ = imageView.image {
            return
        }

        makeToastActivity(.Center)
        scrollView.frame = bounds
        resetZoomScale()
        imageView.kf_setImageWithURL(NSURL(string: imageUrl)!,
                                     placeholderImage: nil,
                                     optionsInfo: nil,
                                     progressBlock: nil,
                                     completionHandler: {(image, error, cacheType, imageURL) -> () in
                                        self.hideToastActivity()
                                        if image == nil || error != nil {
                                            var style = ToastStyle()
                                            style.messageAlignment = NSTextAlignment.Center
                                            self.makeToast("Failed to load the image", duration: 2, position: .Center, style: style)
                                        } else {
                                            self.drawImage()
                                        }
            }
        )
    }

    func resetZoomScale() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
    }

    func drawImage() {
        var scrollViewFrame = scrollView.frame
        if imageView.image == nil {
            scrollViewFrame.origin = CGPointZero
            imageView.frame = scrollViewFrame
            scrollView.contentSize = imageView.frame.size
            resetZoomScale()
        } else {
            var ratio: CGFloat
            let imageSize = imageView.image!.size
            var imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height)
            if scrollViewFrame.size.width <= scrollViewFrame.size.height {
                ratio = scrollViewFrame.size.width / imageFrame.size.width
                imageFrame.size.width = scrollViewFrame.size.width
                imageFrame.size.height = imageFrame.size.height * ratio
            } else {
                ratio = scrollViewFrame.size.height / imageFrame.size.height
                imageFrame.size.width = imageFrame.size.width * ratio
                imageFrame.size.height = scrollViewFrame.size.height
            }
            imageView.frame = imageFrame
            scrollView.contentSize = imageView.frame.size
            imageView.center = centerOfScrollView(scrollView)
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = max(scrollViewFrame.size.width / imageFrame.size.width,
                                              scrollViewFrame.size.height / imageFrame.size.height)
            scrollView.zoomScale = 1.0
        }
        scrollView.contentOffset = CGPointZero
    }

    func centerOfScrollView(scrollView: UIScrollView) -> CGPoint {
        var offsetX: CGFloat
        if scrollView.bounds.size.width > scrollView.bounds.size.height {
            offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5
        } else {
            offsetX = 0.0
        }

        var offsetY: CGFloat
        if scrollView.bounds.size.height > scrollView.contentSize.height {
            offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5
        } else {
            offsetY = 0.0
        }

        return CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                           scrollView.contentSize.height * 0.5 + offsetY)
    }
}