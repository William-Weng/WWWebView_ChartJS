//
//  Delegate.swift
//  WWWebView_ChartJS
//
//  Created by William.Weng on 2025/4/8.
//

import UIKit

public extension WWWebView.ChartJS {
    
    protocol Delegate: NSObjectProtocol {
        
        func chartValues(view: WWWebView.ChartJS) -> [ChartValue]
        
        func chartView(_ view: WWWebView.ChartJS, didTouched indexPath: IndexPath)
        
        func chartView(_ view: WWWebView.ChartJS, status: Result<Status, Error>)
    }
}
