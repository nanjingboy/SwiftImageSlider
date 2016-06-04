import UIKit
import SwiftImageSlider

class ViewController: UIViewController {

    @IBAction func showImageSlider(sender: AnyObject) {
        let imageUrls = [
            "http://img.bimg.126.net/photo/qwLaXLhl3boN0bUPMGRPiA==/5704653352996391616.jpg",
            "http://img1.cache.netease.com/catchpic/5/5C/5C02C05BD566B31FDF6F4A0D16E5C260.jpg",
            "http://imgsrc.baidu.com/forum/w%3D580/sign=20af00b006087bf47dec57e1c2d2575e/bd291cd162d9f2d36a161b14adec8a136227cc27.jpg",
            "http://tw.bid.yimg.com/pimg1/77/8c/p080324724868-item-2640xf1x0490x0395-m.jpg"
        ]
        let controller = ImageSliderViewController(currentIndex: 0, imageUrls: imageUrls)
        presentViewController(controller, animated: true, completion: nil)
    }
}

