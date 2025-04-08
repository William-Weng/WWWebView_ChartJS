/**
 * @function initChart
 * @description 初始化圖表
 * @param type - 圖表類型
 * @param labels - 圖表資料項目
 * @param isUseGrid - 是否使用背景框線
*/
function initChart(type, labels, isUseGrid) {

    let element = document.getElementById('jsChart');
    let gridLineWidth = isUseGrid ? 1.0 : 0.0

    new Chart(element, {
        type: type,
        data: {
            labels: labels,
            datasets: [{
                borderWidth: 0
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        lineWidth: gridLineWidth
                    }
                },
                y: {
                    grid: {
                        lineWidth: gridLineWidth,
                        beginAtZero: true
                    }
                }
            },
            onClick: (event, items) => {
                if (items.length > 0) {
                    let row = items[0].index
                    let section = items[0].datasetIndex
                    mobileProtocol(`app://itemTouched/${section},${row}`)
                }
            }
        }
    })

    return true
}

/**
 * @function reloadData
 * @description 刷新圖表
 * @param labels - 圖表資料項目
 * @param data - 圖表資料
 * @param backgroundColor - 圖表顏色
*/
function reloadData(labels, data, backgroundColor) {

    let jsChart = Chart.getChart('jsChart')

    jsChart.data.labels = labels
    jsChart.data.datasets[0].data = data
    
    if (backgroundColor != undefined) { jsChart.data.datasets[0].backgroundColor = backgroundColor }
    jsChart.update()
}

/**
 * @function mobileProtocol
 * @description 傳輸自定義的Protocol
 * @param src - 自定義的URL (.src = app://downloadFile)
*/
function mobileProtocol(src) {

    let iframe = document.createElement('iframe')

    iframe.src = src
    iframe.style.display = "none"
    document.body.appendChild(iframe)

    iframe.remove()
}

window.initChart = initChart
window.reloadData = reloadData
window.demoChart = demoChart
