/**
 * @function initChart
 * @description 初始化圖表
 * @param type - 圖表類型
 * @param labels - 圖表資料項目
 * @param borderWidth - 線寬 / 間隔
 * @param length - 資料數量
*/
function initChart(type, labels, borderWidth, length) {

    let element = document.getElementById('jsChart')
    let datasets = []

    for (let index = 0; index < length; index++) {
        let dataset = { borderWidth: borderWidth, pointRadius: 4, tension: 0.3, hoverOffset: 10 }
        datasets.push(dataset)
    }

    new Chart(element, {
        type: type,
        data: {
            labels: labels,
            datasets: datasets
        },
        options: {
            scales: {
                y: {
                    min: 0
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: (context) => { return _labelTooltip_(context) }
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
                if (items.length > 0) { return _itemTouched_(items[0]) }
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
function reloadData(labels, dataArray, backgroundColorArray) {

    let myChart = Chart.getChart('jsChart')

    myChart.data.labels = labels

    for (let index = 0; index < dataArray.length; index++) {

        if (backgroundColorArray[index] != undefined) {
            myChart.data.datasets[index].backgroundColor = backgroundColorArray[index]
        }

        myChart.data.datasets[index].data = dataArray[index]
    }

    myChart.update()
    return true
}

/**
 * @function displayGrid
 * @description 是否顯示網格線
 * @param isDisplay - 是否顯示
*/
function displayGrid(isDisplay) {

    let myChart = Chart.getChart('jsChart')

    myChart.options.scales = isDisplay ? { y: { min: 0 } } : {}
    myChart.update()
}

/**
 * @function resize
 * @description 重新設定畫面大小
*/
function resize() {
    let myChart = Chart.getChart('jsChart')
    myChart.resize()
}

/**
 * @function _notificationResize_
 * @description 通知畫面尺寸改變
*/
function _notificationResize_() {
    _mobileProtocol_(`app://resize`)
}

/**
 * @function _labelTooltip_
 * @description 標籤提示設定
 * @param context
*/
function _labelTooltip_(context) {

    const datasetIndex = context.datasetIndex;
    const value = context.raw || 0
    const total = context.chart.data.datasets[datasetIndex].data.reduce((a, b) => a + b, 0)
    const percentage = Math.round((value / total) * 100)

    return ` ${percentage}% (${value})`
}

/**
 * @function _mobileProtocol_
 * @description 傳輸自定義的Protocol
 * @param src - 自定義的URL (.src = app://<event>)
*/
function _mobileProtocol_(src) {

    let iframe = document.createElement('iframe')

    iframe.src = src
    iframe.style.display = "none"
    document.body.appendChild(iframe)

    iframe.remove()
}

/**
 * @function _itemTouched_
 * @description 點擊事件回傳至手機端
 * @param item - 項目資料
*/
function _itemTouched_(item) {

    const row = item.index
    const section = item.datasetIndex
    _mobileProtocol_(`app://itemTouched/${section},${row}`)
}

window.onload = () => {

    window.addEventListener('resize', _notificationResize_)

        (function () {
            let style = document.createElement('style')
            style.innerHTML = `*:not(input,textarea),*:focus:not(input,textarea){-webkit-user-select:none;-webkit-touch-callout:none;}`;
            document.head.appendChild(style)
            return true
        }())
}

window.initChart = initChart
window.reloadData = reloadData
window.resize = resize
window.displayGrid = displayGrid
