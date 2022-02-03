//
//  HomeVM.swift
//  CryptoApp
//
//  Created by aleksandre on 02.02.22.
//

import Charts
import Foundation

class HomeViewModel {
    
    var marketData: ObservableObject<LineChartData?> = ObservableObject(value: nil)
    
    
    // MARK: - Initialization
    
    init() {
        fetchData()
    }
    
    
    private func fetchData() {
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.markets) { [weak self] (result: Result<MarketDTOResponse, Error>) in
            switch result {
            case .success(let response):
                var marketPrices = [Double]()
                let fetchedData = response.map {
                    return MarketData(prices: $0.sparklineIn7D.price)
                }
                for marketData in fetchedData {
                    let prices = marketData.prices
                    marketPrices = prices
                }
                self?.transformIntoChartData(prices: marketPrices)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    ///Transform fetched market prices into chart Data
    private func transformIntoChartData(prices: [Double]) {
        var entries = [ChartDataEntry]()
        var pricesAccending = prices.sorted { $0 < $1 }
        for price in prices {
            if !pricesAccending.isEmpty {
                entries.append(ChartDataEntry(x: pricesAccending.removeFirst(), y: price))
            }
        }
        let set = LineChartDataSet(entries: entries, label: "Weekly Timeline")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 2
//        set.fill = Fill(color: .secondaryColor)
//        set.fillAlpha = 1
        set.drawFilledEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
//        set.highlightColor = .systemRed
        set.colors = ChartColorTemplates.liberty()
        set.highlightEnabled = true
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        self.marketData.value = data
    }
    
}
