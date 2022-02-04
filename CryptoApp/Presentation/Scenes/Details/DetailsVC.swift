////
////  ViewController.swift
////  CryptoApp
////
////  Created by aleksandre on 02.02.22.
////
//
//import UIKit
//import Charts
//
//class DetailsViewController: UIViewController {
//
//
//    // MARK: - Properties and Instances
//
//    let homeVM = DetailsViewModel()
//
//
//    // MARK: - Initialization
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateUI()
//        addSubviews()
//        initializeConstraints()
//        configureChart()
////        homeVM.marketData.bind(listener: { [weak self] pricesListener in
////            DispatchQueue.main.async {
////                self?.cryptoChart.data = pricesListener
////            }
////
////        })
//    }
//
//
//    private func addSubviews() {
//        self.view.addSubview(cryptoChart)
//    }
//
//
//    // MARK: - UI Configuration
//
//    private func updateUI() {
//        self.view.backgroundColor = .primaryColor
//    }
//
//
//
//    // MARK: - UI Elements
//
//
//    private let cryptoChart: LineChartView = {
//        let chart = LineChartView()
//        chart.translatesAutoresizingMaskIntoConstraints = false
//        chart.rightAxis.enabled = true
////        chart.xAxis.wor
//        chart.rightAxis.drawGridLinesEnabled = false
//        chart.leftAxis.enabled = false
////        chart.xAxis.labelTextColor = .systemRed
//        chart.xAxis.enabled = false
//        chart.clipsToBounds = true
//        chart.isUserInteractionEnabled = false
//        chart.animate(xAxisDuration: 2.0)
//        return chart
//    }()
//
//
//}
//
//    // MARK: - Chart Configuration and Delegate Methods
//
//extension DetailsViewController: ChartViewDelegate {
//
//    private func configureChart() {
////        let set = LineChartDataSet(entries: entries)
////        set.drawCirclesEnabled = false
////        set.mode = .cubicBezier
////        set.lineWidth = 3
////        set.setColor(.secondaryColor)
////        set.fill = Fill(color: .secondaryColor)
////        set.fillAlpha = 0.7
////        set.drawFilledEnabled = true
////        set.drawHorizontalHighlightIndicatorEnabled = false
////        set.highlightColor = .systemRed
////        set.colors = ChartColorTemplates.liberty()
////        let data = LineChartData(dataSet: set)
////        data.setDrawValues(false)
////        cryptoChart.data = data
////        cryptoChart.delegate = self
//    }
//
//
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
////        print(entry)
//    }
//
//}
//
//
//
//
//
//
//    // MARK: - Constraints
//
//extension DetailsViewController {
//
//    private func initializeConstraints() {
//        let chartHeightMultiplier = CGFloat(0.3)
//        var constraints = [NSLayoutConstraint]()
//
//        /// Crypto chart
//        constraints.append(cryptoChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
//        constraints.append(cryptoChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
//        constraints.append(cryptoChart.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: chartHeightMultiplier))
//        constraints.append(cryptoChart.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
//        constraints.append(cryptoChart.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
//
//        NSLayoutConstraint.activate(constraints)
//
//    }
//}
//
