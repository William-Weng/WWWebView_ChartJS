//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/9/21.
//

import WebKit

extension UIColor {
    
    /// [取得顏色的RGBA值 => 0% ~ 100%](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
    /// - Returns: Constant.RGBAInformation?
    func _RGBA() -> RGBAInformation? {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// RGB => HexString
    /// - (0.0, 1.0, 0.0, 1.0) => (#00FF00FF)
    /// - Returns: String?
    func _hexString() -> String? {
        
        guard let colorRGBA = self._RGBA() else { return nil }
        
        let multiplier = CGFloat(255.999999)
        let red = Int(colorRGBA.red * multiplier)
        let green = Int(colorRGBA.green * multiplier)
        let blue = Int(colorRGBA.blue * multiplier)
        let alpha = Int(colorRGBA.alpha * multiplier)

        print("\(colorRGBA) => \(alpha)")
        
        if (colorRGBA.alpha == 1.0) { return String(format: "#%02lX%02lX%02lX", red, green, blue) }
        return String(format: "#%02lX%02lX%02lX%02lX", red, green, blue, alpha)
    }
}

// MARK: - WKWebView (static function)
extension WKWebView {
    
    /// 產生WKWebView (WKNavigationDelegate & WKUIDelegate)
    /// - Parameters:
    ///   - delegate: WKNavigationDelegate & WKUIDelegate
    ///   - frame: WKWebView的大小
    ///   - canOpenWindows: [window.open(url)](https://www.jianshu.com/p/561307f8aa9e) for  [webView(_:createWebViewWith:for:windowFeatures:)](https://developer.apple.com/documentation/webkit/wkuidelegate/1536907-webview)
    ///   - configuration: WKWebViewConfiguration
    ///   - contentInsetAdjustmentBehavior: scrollView是否為全畫面
    ///   - isInspectable: [開啟Safari的Debug模式](https://peggy-tsai.medium.com/ios-16-4後-safari-開發者無法看到webview-console-325eea83ff6c)
    /// - Returns: WKWebView
    static func _build(delegate: (WKNavigationDelegate & WKUIDelegate)?, frame: CGRect, canOpenWindows: Bool = false, configuration: WKWebViewConfiguration = WKWebViewConfiguration(), isInspectable: Bool, contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never) -> WKWebView {
        
        let webView = WKWebView(frame: frame, configuration: configuration)
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = canOpenWindows
        
        webView.backgroundColor = .white
        webView.navigationDelegate = delegate
        webView.uiDelegate = delegate
        webView.scrollView.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        
        if #available(iOS 16.4, *) { webView.isInspectable = isInspectable }
        
        return webView
    }
}

extension WKWebView {
    
    /// 載入本機HTML檔案
    /// - Parameters:
    ///   - filename: HTML檔案名稱
    ///   - bundle: Bundle位置
    ///   - readAccessURL: 可讀取資料夾的位置
    /// - Returns: Result<WKNavigation?, Error>
    func _loadFile(filename: String, bundle: Bundle? = nil, allowingReadAccessTo readAccessURL: URL? = nil) -> Result<WKNavigation?, Error> {
        
        let fileBundle: Bundle = bundle ?? .main
        
        guard let url = fileBundle.url(forResource: filename, withExtension: nil) else { return .failure(CustomError.notUrlExists) }
        
        let readAccessURL: URL = readAccessURL ?? url.deletingLastPathComponent()
        return .success(loadFileURL(url, allowingReadAccessTo: readAccessURL))
    }
    
    /// [執行JavaScript](https://andyu.me/2020/07/17/js-iife/)
    /// - Parameters:
    ///   - script: [JavaScript文字](https://lance.coderbridge.io/2020/08/05/why-use-IIFE/)
    ///   - result: Result<Any?, Error>
    func _evaluateJavaScript(script: String?, result: @escaping (Result<Any?, Error>) -> Void) {
        
        guard let script = script else { result(.failure(CustomError.isEmpty)); return }
        
        self.evaluateJavaScript(script) { data, error in
            if let error = error { result(.failure(error)); return }
            result(.success(data))
        }
    }

}
