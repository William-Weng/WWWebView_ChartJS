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
    
    /// 表格樣式
    enum ChartType {
        
        case bar                                    // 柱狀圖
        case pie(_ gap: Double)                     // 圓餅圖
        case doughnut(_ gap: Double)                // 甜甜圈圖
        case line(_ borderWidth: Double)            // 折線圖
        
        func value() -> String {
            
            switch self {
            case .bar: return "bar"
            case .pie: return "pie"
            case .doughnut: return "doughnut"
            case .line: return "line"
            }
        }
    }
    
    /// 自定義的狀態名稱
    enum Status {
        case loadHTML(_ action: WKNavigation?)      // 載入HTML文件
        case initChart(_ value: Any?)               // 初始化表格
        case reloadData(_ value: Any?)              // 更新數據資料
        case reload                                 // 重新載入HTML
        case resize                                 // 更新尺寸
    }
    
    /// 自定義的事件名稱 => app://<event>/<value>
    enum Event {
        case itemTouched(_ indexPath: IndexPath)    // 圖表項目被點 => app://itemTouched/${section},${row}
        case resize(_ isLandscape: Bool)            // 手機尺寸改變 => app://resize
    }
    
    /// 自定義功能代號 => app://<event>/<value>
    enum CustomUrlScheme: String {
        case app
    }
    
    /// 自定義的事件名稱 => app://<event>/<value>
    enum CustomUrlHost: String {
        case itemTouched
        case resize
    }
}
