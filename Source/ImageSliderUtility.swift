class ImageSliderUtility: NSObject {

    static func localizedString(_ key: String) -> String {
        if let bundleUrl = Bundle(for: classForCoder()).url(forResource: "SwiftImageSlider", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleUrl) {
                return bundle.localizedString(forKey: key, value: key, table: "SwiftImageSlider")
            }
        }

        return key
    }
}
