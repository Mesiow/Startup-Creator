//
//  UIColor+Ext.swift
//  Startup Creator
//
//  Created by Chris W on 1/4/25.
//

import UIKit

extension UIColor {
    static func getUpdatedColor(color: UIColor) -> UIColor {
        return color.resolvedColor(with: .current)
    }
}
