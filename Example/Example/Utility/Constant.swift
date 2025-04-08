//
//  Constant.swift
//  Example
//
//  Created by William.Weng on 2024/9/21.
//

import UIKit

typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)                                       // [RGBA色彩模式的數值](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)

typealias ChartValue = (key: String, value: Double, color: UIColor?)

enum ChartType: String {
    case bar
    case pie
}

enum CustomUrlScheme: String {
    case app
}

enum CustomUrlHost: String {
    case itemTouched
}

enum CustomError: Error {
    case notUrlExists
    case isEmpty
}
