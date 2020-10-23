//
// Lofionic © 2019-2020
//

struct Colors {
    //TODO: Rename semantically
    static let black = UIColor.black
    
    static let offWhite = UIColor(white: 0.98, alpha: 1.0)
    static let offBlack = UIColor(white: 0.1, alpha: 1.0)
    
    static let lightGray = UIColor(white: 0.88, alpha: 1.0)
    static let darkGray = UIColor(white: 0.2, alpha: 1.0)
    
    static let red = UIColor.systemRed
}

struct Fonts {
    static let annotation: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        return [
            .font: UIFont(name: "AvenirNext-Regular", size: 12)!,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Colors.offBlack
        ]
    }()
}
