//
//  ViewController.swift
//  CryptoApp
//
//  Created by aleksandre on 02.02.22.
//

import UIKit
import Charts

class DetailsViewController: UIViewController {


    // MARK: - Properties and Instances

    let detailsVM: DetailsViewModel


    // MARK: - Initialization
    
    public init(_ viewModel: DetailsViewModel) {
        self.detailsVM = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        initializeConstraints()
        startListening()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }


    private func addSubviews() {
        self.view.addSubview(cryptoChart)
    }
    
    
    private func startListening() {
        detailsVM.marketData.bind(listener: { [weak self] pricesListener in
            DispatchQueue.main.async {
                self?.cryptoChart.data = pricesListener
            }
        })

    }

    // MARK: - UI Configuration

    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        navigationController?.navigationBar.tintColor = .white
    }



    // MARK: - UI Elements


    private let cryptoChart: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.rightAxis.enabled = true
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.enabled = false
        chart.xAxis.enabled = false
        chart.clipsToBounds = true
        chart.noDataText = ""
        chart.isUserInteractionEnabled = false
        chart.animate(xAxisDuration: 3.0)
        return chart
    }()


}

    // MARK: - Chart Configuration and Delegate Methods

extension DetailsViewController: ChartViewDelegate {


    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }

}






    // MARK: - Constraints

extension DetailsViewController {

    private func initializeConstraints() {
        let chartHeightMultiplier = CGFloat(0.3)
        var constraints = [NSLayoutConstraint]()

        /// Crypto chart
        constraints.append(cryptoChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(cryptoChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        constraints.append(cryptoChart.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: chartHeightMultiplier))
        constraints.append(cryptoChart.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        constraints.append(cryptoChart.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20))

        NSLayoutConstraint.activate(constraints)

    }
}

