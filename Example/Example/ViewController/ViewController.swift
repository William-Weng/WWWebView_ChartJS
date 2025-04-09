//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/4/8.
//

import UIKit
import WWWebView_ChartJS

class MyChartJS: WWWebView.ChartJS {}

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var chartView: MyChartJS!
    
    private var chartValues: [WWWebView.ChartJS.ChartValue] = [
        (key: "Red", value: 15.0, color: nil),
        (key: "Blue", value: 10.0, color: nil),
        (key: "Yellow", value: 5.5, color: .yellow),
        (key: "Green", value: 8.0, color: .green.withAlphaComponent(0.3)),
        (key: "Purple", value: 12.0, color: .purple.withAlphaComponent(0.5)),
        (key: "Orange", value: 10.4, color: .orange.withAlphaComponent(0.7)),
    ]
        
    @IBAction func initChart(_ sender: UIBarButtonItem) {
        chartView.configure(delegate: self)
    }
    
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        
        chartValues = [
            (key: "Red", value: 25.0, color: .red),
            (key: "Blue", value: 10.3, color: .blue),
            (key: "Yellow", value: 8.5, color: .yellow),
            (key: "Purple", value: 13.6, color: .purple),
        ]
        
        chartView.reloadData()
    }
}

// MARK: - WWWebView.ChartJS.Delegate
extension ViewController: WWWebView.ChartJS.Delegate {
    
    func chartValues(view: WWWebView.ChartJS) -> [WWWebView.ChartJS.ChartValue] {
        return chartValues
    }
        
    func chartViewStatus(_ view: WWWebView.ChartJS, result: Result<WWWebView.ChartJS.Status, Error>) {
        
        switch result {
        case .failure(let error): print(error)
        case .success(let status): print(status)
        }
    }
    
    func chartViewEvent(_ view: WWWebView.ChartJS, result: Result<WWWebView.ChartJS.Event, any Error>) {
        
        switch result {
        case .failure(let error): print(error)
        case .success(let event):
            switch event {
            case .itemTouched(let indexPath): title = chartValues[indexPath.row].key
            case .orientationChange: view.reload()
            }
        }
    }
}
