class ImageSliderUtility: NSObject {

    static func localizedString(key: String) -> String {
        if let bundleUrl = NSBundle(forClass: classForCoder()).URLForResource("SwiftImageSlider", withExtension: "bundle") {
            if let bundle = NSBundle(URL: bundleUrl) {
                return bundle.localizedStringForKey(key, value: key, table: "SwiftImageSlider")
            }
        }

        return key
    }
}