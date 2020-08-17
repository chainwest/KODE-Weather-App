//
//  Layer+Shadow.swift

import UIKit

extension CALayer {
    func createShadow() {
        self.masksToBounds = false
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowRadius = 15.0
        self.shadowOpacity = 0.3
    }
}
