//
//  Delegate.swift
//  WWWebView_ChartJS
//
//  Created by William.Weng on 2025/4/8.
//

import UIKit

// MARK: - WWWebView.ChartJS.Delegate
public extension WWWebView.ChartJS {
    
    protocol Delegate: NSObjectProtocol {
        
        /// 取得表格數據
        /// - Parameter view: WWWebView.ChartJS
        /// - Returns: [ChartValue]
        func chartValues(view: WWWebView.ChartJS) -> [ChartValue]
        
        /// 點到哪一個數據
        /// - Parameters:
        ///   - view: WWWebView.ChartJS
        ///   - indexPath: IndexPath
        func chartView(_ view: WWWebView.ChartJS, didTouched indexPath: IndexPath)
        
        /// 表格狀態
        /// - Parameters:
        ///   - view: WWWebView.ChartJS
        ///   - status: Result<Status, Error>
        func chartView(_ view: WWWebView.ChartJS, status: Result<Status, Error>)
    }
}
