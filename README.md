# WWWebView+ChartJS

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWWebView_ChartJS) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [By loading Chart.js through WebView, the chart function can be quickly implemented.](https://www.chartjs.org/docs/latest/getting-started/)
- [藉由WebView加載Chart.js，來快速實現的圖表功能。](https://chartjs.bootcss.com/docs/getting-started/installation.html)

![](./Example.webp)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWWebView_ChartJS.git", .upToNextMajor(from: "0.5.0"))
]
```

## [Function](https://ezgif.com/video-to-webp)
|函式|功能|
|-|-|
|configure(delegate:chartType:defaultColor:isUseGrid:)|相關設定|
|reloadData()|重新載入資料|

## [Example](https://ezgif.com/video-to-webp)
```swift
import UIKit
import WWWebView_ChartJS

final class ViewController: UIViewController {
        
    private var webView: WWWebView.ChartJS!
    
    private var chartValues: [WWWebView.ChartJS.ChartValue] = [
        (key: "Red", value: 15.0, color: nil),
        (key: "Blue", value: 10.0, color: nil),
        (key: "Yellow", value: 5.5, color: .yellow),
        (key: "Green", value: 8.0, color: .green.withAlphaComponent(0.3)),
        (key: "Purple", value: 12.0, color: .purple.withAlphaComponent(0.5)),
        (key: "Orange", value: 10.4, color: .orange.withAlphaComponent(0.7)),
    ]
    
    @IBAction func initChart(_ sender: UIBarButtonItem) {
        
        webView = WWWebView.ChartJS.init(frame: view.bounds)
        webView.configure(delegate: self)
        view.addSubview(webView)
    }
    
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        
        chartValues = [
            (key: "Red", value: 25.0, color: .red),
            (key: "Blue", value: 10.3, color: .blue),
            (key: "Yellow", value: 8.5, color: .yellow),
            (key: "Purple", value: 13.6, color: .purple),
        ]
        
        webView.reloadData()
    }
}

extension ViewController: WWWebView.ChartJS.Delegate {
    
    func chartValues(view: WWWebView.ChartJS) -> [WWWebView.ChartJS.ChartValue] {
        return chartValues
    }
    
    func chartView(_ view: WWWebView.ChartJS, didTouched indexPath: IndexPath) {
        title = chartValues[indexPath.row].key
    }
    
    func chartView(_ view: WWWebView.ChartJS, status: Result<WWWebView.ChartJS.Status, Error>) {
        print(status)
    }
}
```
