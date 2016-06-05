import UIKit

protocol ImageSliderViewDelegate {

    func imageSliderViewSingleTap(tap: UITapGestureRecognizer)

    func imageSliderViewImageSwitch(index: Int, count: Int, imageUrl: String?)
}