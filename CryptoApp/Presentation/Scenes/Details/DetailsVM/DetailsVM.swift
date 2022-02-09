//
//  HomeVM.swift
//  CryptoApp
//
//  Created by aleksandre on 02.02.22.
//

import Charts
import Foundation

class DetailsViewModel {
    
    var marketData: ObservableObject<LineChartData?> = ObservableObject(value: nil)
    
    
    // MARK: - Public
    
    init(coinID: String) {
        self.coinID = coinID
        fetchData()
    }
    
    

    
    
    // MARK: - Private
    
    private var coinID: String
    
    
    private func fetchData() {
        
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.coinData(id: coinID)) { [weak self] (result: Result<CoinDataDTOResponse, Error>) in
            switch result {
            case .success(let response):
                let mappedData = CoinData(response)
                self?.transformIntoChartData(prices: mappedData.sparkLine7D)
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
        set.lineWidth = 3
        set.fill = Fill(color: .borderColor)
        set.fillAlpha = 1
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
