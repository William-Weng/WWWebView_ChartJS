//
//  ChartJS.swift
//  WWWebView_ChartJS
//
//  Created by William.Weng on 2025/4/8.
//

import UIKit
import WebKit

// MARK: - WWWebView
open class WWWebView {}

// MARK: - [WWWebView.ChartJS](https://cdnjs.com/libraries/Chart.js)
extension WWWebView {
    
    open class ChartJS: UIView {
        
        @IBOutlet var contentView: UIView!
        @IBOutlet weak var webView: WKWebView!
        
        public weak var delegate: Delegate?
        
        public var isScrollEnabled = true { didSet { webView.scrollView.isScrollEnabled = isScrollEnabled }}
        
        private var colorHexString = "#00FFFF66"
        private var chartType: ChartType = .bar
        
        override public init(frame: CGRect) {
            super.init(frame: frame)
            initViewFromXib()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initViewFromXib()
        }
        
        deinit {
            delegate = nil
        }
    }
}

// MARK: - WKNavigationDelegate
extension WWWebView.ChartJS: WKNavigationDelegate {}
public extension WWWebView.ChartJS {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let chartValuesArray = delegate?.valuesArray(chartView: self) else { return }
        initChart(with: webView, chartType: chartType, chartValuesArray: chartValuesArray)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        return await webViewAction(webView, decidePolicyFor: navigationAction)
    }
}

// MARK: - 公開函式
public extension WWWebView.ChartJS {
    
    /// [相關設定](https://www.chartjs.org/docs/latest/getting-started/)
    /// - Parameters:
    ///   - delegate: Delegate?
    ///   - chartType: 圖表樣式
    ///   - defaultColor: 預設顏色
    func configure(delegate: Delegate?, chartType: ChartType = .bar, defaultColor: UIColor? = nil) {
        
        if let defaultColor { colorHexString = defaultColor._hexString() ?? "#00FFFF66" }
        
        self.delegate = delegate
        self.chartType = chartType
        
        loadHTML("index.html")
    }
    
    /// [重新載入資料](https://chartjs.bootcss.com/docs/getting-started/installation.html)
    func reloadData() {
        reloadDataAction(webView: webView)
    }
    
    /// [重新載入網頁](https://www.chartjs.org/docs/latest/charts/doughnut.html)
    func reload() {
        webView.reload()
        delegate?.chartViewStatus(self, result: .success(.reload))
    }
    
    /// 重新設定畫面大小
    func resize() {
        resizeAction(webView: webView)
    }
}

// MARK: - 小工具
private extension WWWebView.ChartJS {
    
    /// [讀取Nib畫面 => 加到View上面](https://blog.twjoin.com/ios-view-更新-從-setneedsdisplay-到-layoutsubviews-2e673359ccac)
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: WWWebView.ChartJS.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// WebView載入HTML
    /// - Parameter filename: HTML檔案名稱
    func loadHTML(_ filename: String) {
        
        let result = webView._loadFile(filename: filename, bundle: .module, inSubDirectory: "HTML")
        
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.isHidden = true
        webView.isOpaque = false
        
        switch result {
        case .failure(let error): delegate?.chartViewStatus(self, result: .failure(error))
        case .success(let action): delegate?.chartViewStatus(self, result: .success(.loadHTML(action)))
        }
    }
    
    /// 初始化圖表
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - chartType: 圖表樣式
    ///   - chartValuesArray: [數值]
    func initChart(with webView: WKWebView, chartType: ChartType, chartValuesArray: [[ChartValue]]) {
        
        let borderWidth: Double
        let isDisplayGrid: Bool

        switch chartType {
        case .bar: borderWidth = 0.0; isDisplayGrid = true
        case .pie(let gap): borderWidth = gap; isDisplayGrid = false
        case .doughnut(let gap): borderWidth = gap; isDisplayGrid = false
        case .line(let width): borderWidth = width; isDisplayGrid = true
        }
        
        initChart(webView: webView, chartType: chartType.value(), chartValuesArray: chartValuesArray, borderWidth: borderWidth, isDisplayGrid: isDisplayGrid)
    }
    
    /// 初始化圖表
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - chartType: 圖表樣式
    ///   - chartValuesArray: [數值]
    ///   - borderWidth: 線寬
    ///   - isDisplayGrid: 是否要顯示坐標線
    func initChart(webView: WKWebView, chartType: String, chartValuesArray: [[ChartValue]], borderWidth: Double, isDisplayGrid: Bool) {
        
        guard let labels = chartValuesArray.first?.map({ (key, _ , _) in return key }) else { return }
        
        let jsCode = """
            window.initChart('\(chartType)', \(labels), \(borderWidth), \(chartValuesArray.count))
            window.displayGrid(\(isDisplayGrid))
        """
        
        webView.isHidden = false
        
        webView._evaluateJavaScript(script: jsCode) { [weak self] result in
            
            guard let this = self else { return }
            
            switch result {
            case .failure(let error): this.delegate?.chartViewStatus(this, result: .failure(error))
            case .success(let value):
                this.delegate?.chartViewStatus(this, result: .success(.initChart(value)))
                this.reloadDataAction(webView: webView)
            }
        }
    }
    
    /// 重新載入資料
    /// - Parameter webView: WKWebView
    func reloadDataAction(webView: WKWebView) {
        
        guard let chartValuesArray = delegate?.valuesArray(chartView: self),
              let labels = chartValuesArray.first?.map({ (key, _ , _) in return key })
        else {
            return
        }

        let itemValue = parseItemValues(chartValuesArray: chartValuesArray)
        let jsCode = """
            window.reloadData(\(labels), [\(itemValue.datasString)], [\(itemValue.colorsString)])
        """
        
        webView._evaluateJavaScript(script: jsCode) { [weak self] result in
            
            guard let this = self else { return }
            
            switch result {
            case .failure(let error): this.delegate?.chartViewStatus(this, result: .failure(error))
            case .success(let value): this.delegate?.chartViewStatus(this, result: .success(.reloadData(value)))
            }
        }
    }
    
    /// 重新設定畫面大小
    /// - Parameter webView: WKWebView
    func resizeAction(webView: WKWebView) {
        
        let jsCode = """
            window.resize()
        """
        
        webView._evaluateJavaScript(script: jsCode) { [weak self] result in
            
            guard let this = self else { return }
            
            switch result {
            case .failure(let error): this.delegate?.chartViewStatus(this, result: .failure(error))
            case .success(let value): this.delegate?.chartViewStatus(this, result: .success(.resize))
            }
        }
    }
}

// MARK: - 圖表功能
private extension WWWebView.ChartJS {
    
    /// 處理自定義事件
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - navigationAction: WKNavigationAction
    /// - Returns: WKNavigationActionPolicy
    func webViewAction(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
                
        guard let url = navigationAction.request.url,
              let urlScheme = url.scheme,
              let urlHost = url.host,
              let scheme = CustomUrlScheme(rawValue: urlScheme),
              let host = CustomUrlHost(rawValue: urlHost)
        else {
            return .allow
        }
        
        switch (scheme, host) {
        case (.app, .itemTouched): return itemTouchedAction(with: url)
        case (.app, .resize): return resizeAction()
        }
        
        return .cancel
    }
    
    /// 項目被點擊的事件處理 => app://itemTouched/${section},${row}
    /// - Parameter url: URL
    /// - Returns: WKNavigationActionPolicy
    func itemTouchedAction(with url: URL) -> WKNavigationActionPolicy {
        
        print(url)
        
        let component = url.lastPathComponent
        let array = component.split(separator: ",")
        
        guard array.count == 2,
              let first = array.first,
              let last = array.last,
              let section = Int(first),
              let row = Int(last)
        else {
            return .cancel
        }
        
        let indexPath = IndexPath(row: row, section: section)
        delegate?.chartViewEvent(self, result: .success(.itemTouched(indexPath)))
        
        return .cancel
    }
    
    /// 畫面尺寸改變事件處理 => app://resize
    func resizeAction() -> WKNavigationActionPolicy {
        
        let isLandscape = UIDevice.current._checkLandscape()
        delegate?.chartViewEvent(self, result: .success(.resize(isLandscape)))
        
        return .cancel
    }
}

// MARK: - 小工具
private extension WWWebView.ChartJS {
    
    /// 將Swift的資料 => Chart.js的參數文字
    /// - Parameter chartValuesArray: [[ChartValue]]
    /// - Returns: (datasString: String, colorsString: String)
    func parseItemValues(chartValuesArray: [[ChartValue]]) -> (datasString: String, colorsString: String) {
        
        let colorsString: String
        let datasString: String

        var colors: [String] = []
        var datas: [String] = []
        
        chartValuesArray.map { chartValues in
            
            let values = chartValues.map { $0.value }
            let _colors = chartValues.map { $0.color?._hexString() ?? colorHexString }
            let _datas = values.map { String($0) }.joined(separator: ", ")
            
            colors.append("\(_colors)")
            datas.append("[\(_datas)]")
        }
        
        colorsString = colors.map { String($0) }.joined(separator: ", ")
        datasString = datas.map { String($0) }.joined(separator: ", ")

        return (datasString: datasString, colorsString: colorsString)
    }
}
