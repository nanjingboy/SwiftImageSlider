import UIKit

public protocol ImageSliderViewDelegate {

    func imageSliderViewSingleTap(_ tap: UITapGestureRecognizer)

    func imageSliderViewImageSwitch(_ index: Int, count: Int, imageUrl: String?)
}
