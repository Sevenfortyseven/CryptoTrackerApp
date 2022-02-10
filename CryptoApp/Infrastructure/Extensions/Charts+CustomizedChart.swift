//
//  LineChartData+CustomizedSet.swift
//  CryptoApp
//
//  Created by aleksandre on 09.02.22.
//

import Foundation
import Charts

extension LineChartDataSet {
    
    /// Set custom set parameters to make code a little bit cleaner
    public var customSetOptions: LineChartDataSet? {
        self.mode = .cubicBezier
        self.drawCirclesEnabled = false
        self.lineWidth = 3
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.highlightEnabled = true
        
        return nil
    }
}


extension LineChartView {
    
    /// Set custom set parameters to make code a little bit cleaner
    public var customChartOptions: LineChartView? {
        self.rightAxis.enabled = true
        self.rightAxis.drawGridLinesEnabled = false
        self.leftAxis.enabled = false
        self.xAxis.enabled = false
        self.noDataText = ""
        
        return nil
    }
    
}
