//
//  Constant.swift
//  WWWebView_ChartJS
//
//  Created by William.Weng on 2025/4/8.
//

import WebKit

// MARK: - enum
public extension WWWebView {
    
    enum CustomError: Error {
        case notUrlExists
        case isEmpty
    }
}

// MARK: - typealias
public extension WWWebView.ChartJS {
    
    typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias ChartValue = (key: String, value: Double, color: UIColor?)
}

// MARK: - enum
public extension WWWebView.ChartJS {
    
    enum ChartType: String {
        case bar
    }
    
    enum Status {
        case loadHTML(_ action: WKNavigation?)
        case initChart(_ value: Any?)
        case reloadData(_ value: Any?)
    }
    
    enum CustomUrlScheme: String {
        case app            // app://
    }
    
    enum CustomUrlHost: String {
        case itemTouched    // app://itemTouched/${section},${row}
    }
}
