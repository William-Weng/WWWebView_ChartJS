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
                
        /// 表格狀態
        /// - Parameters:
        ///   - view: WWWebView.ChartJS
        ///   - statusResult: Result<Status, Error>
        func chartViewStatus(_ view: WWWebView.ChartJS, result: Result<Status, Error>)
        
        /// 表格事件
        /// - Parameters:
        ///   - view: WWWebView.ChartJS
        ///   - statusResult: Result<Event, Error>
        func chartViewEvent(_ view: WWWebView.ChartJS, result: Result<Event, Error>)
    }
}
