/**
 * @function initChart
 * @description 初始化圖表
 * @param type - 圖表類型
 * @param labels - 圖表資料項目
 * @param isUseGrid - 是否使用背景框線
*/
function initChart(type, labels) {

    let element = document.getElementById('jsChart');
    
    new Chart(element, {
        type: type,
        data: {
            labels: labels,
            datasets: [{
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: (context) => {
                            const value = context.raw || 0
                            const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0)
                            const percentage = Math.round((value / total) * 100)
                            return ` ${percentage}% (${value})`
                        }
                    }
                }
            },
            layout: {
                padding: {
                    top: 10,
                    right: 10,
                    bottom: 10,
                    left: 10
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

    const jsChart = Chart.getChart('jsChart')

    jsChart.data.labels = labels
    jsChart.data.datasets[0].data = data
    
    if (backgroundColor != undefined) { jsChart.data.datasets[0].backgroundColor = backgroundColor }
    jsChart.update()
}

/**
 * @function resize
 * @description 重新設定畫面大小
*/
function resize() {
    const jsChart = Chart.getChart('jsChart')
    jsChart.resize()
}

/**
 * @function notificationResize
 * @description 通知畫面尺寸改變
*/
function notificationResize() {
    mobileProtocol(`app://resize`)
}

/**
 * @function mobileProtocol
 * @description 傳輸自定義的Protocol
 * @param src - 自定義的URL (.src = app://downloadFile)
*/
function mobileProtocol(src) {

    const iframe = document.createElement('iframe')

    iframe.src = src
    iframe.style.display = "none"
    document.body.appendChild(iframe)
    
    iframe.remove()
}

window.onload = () => {
    
    window.addEventListener('resize', notificationResize)

    (function() {
        let style = document.createElement('style')
        style.innerHTML = `*:not(input,textarea),*:focus:not(input,textarea){-webkit-user-select:none;-webkit-touch-callout:none;}`;
        document.head.appendChild(style)
        return true
    }())
}

window.initChart = initChart
window.reloadData = reloadData
window.resize = resize
