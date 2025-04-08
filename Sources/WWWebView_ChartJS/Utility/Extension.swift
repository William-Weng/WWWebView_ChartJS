//
//  Extension.swift
//  WWWebView_ChartJS
//
//  Created by William.Weng on 2025/4/8.
//

import WebKit

// MARK: - UIColor
public extension UIColor {
    
    /// [取得顏色的RGBA值 => 0% ~ 100%](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
    /// - Returns: Constant.RGBAInformation?
    func _RGBA() -> WWWebView.ChartJS.RGBAInformation? {
        
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
        
        if (colorRGBA.alpha == 1.0) { return String(format: "#%02lX%02lX%02lX", red, green, blue) }
        return String(format: "#%02lX%02lX%02lX%02lX", red, green, blue, alpha)
    }
}

// MARK: - WKWebView
public extension WKWebView {
    
    /// 載入本機HTML檔案
    /// - Parameters:
    ///   - filename: HTML檔案名稱
    ///   - bundle: Bundle位置
    ///   - directory: 資料夾位置
    ///   - readAccessURL: 允許讀取的資料夾位置
    /// - Returns: Result<WKNavigation?, Error>
    func _loadFile(filename: String, bundle: Bundle? = nil, inSubDirectory directory: String? = nil, allowingReadAccessTo readAccessURL: URL? = nil) -> Result<WKNavigation?, Error> {
        
        guard let url = (bundle ?? .main).url(forResource: filename, withExtension: nil, subdirectory: directory) else { return .failure(WWWebView.CustomError.notUrlExists) }
                
        let readAccessURL: URL = readAccessURL ?? url.deletingLastPathComponent()
        
        return .success(loadFileURL(url, allowingReadAccessTo: readAccessURL))
    }
    
    /// [執行JavaScript](https://andyu.me/2020/07/17/js-iife/)
    /// - Parameters:
    ///   - script: [JavaScript文字](https://lance.coderbridge.io/2020/08/05/why-use-IIFE/)
    ///   - result: Result<Any?, Error>
    func _evaluateJavaScript(script: String?, result: @escaping (Result<Any?, Error>) -> Void) {
        
        guard let script = script else { result(.failure(WWWebView.CustomError.isEmpty)); return }
        
        evaluateJavaScript(script) { data, error in
            if let error = error { result(.failure(error)); return }
            result(.success(data))
        }
    }
}
