//
//  CellDataSortingModule.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation
import UIKit

class TableViewModule: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        populateStackView()
        initializeConstraints()
    }
    
    
    private func addSubviews(){
        self.addSubview(cryptoListTableView)
        self.addSubview(priceAndRefreshStackView)
        self.addSubview(sortByRankStackView)
        self.addSubview(tableViewLoadingSpinner)
    }
    
    private func populateStackView() {
        priceAndRefreshStackView.addArrangedSubview(sortByPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(sortingImageForPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(refreshBtn)
       
        sortByRankStackView.addArrangedSubview(sortByRankBtn)
        sortByRankStackView.addArrangedSubview(sortingImageForRankBtn)
    }
    
    
    
    // MARK: - UI Elements
    
    public let cryptoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondaryColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.borderWidth = 0.1
        tableView.layer.borderColor = UIColor.borderColor.cgColor
        tableView.bounces = false
        return tableView
    }()
    
    private let priceAndRefreshStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let sortByRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    

    public let refreshBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.tintColor = .borderColor
        return button
    }()
    
    public let sortByRankBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        button.setTitle("Coin", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    public let sortByPriceBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        button.setTitle("Price", for: .normal)
        return button
    }()
    
    public let sortingImageForPriceBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    public let sortingImageForRankBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    public let tableViewLoadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.color = .borderColor
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
    // MARK: - Constraints
    
    private func initializeConstraints() {
        var constraints            = [NSLayoutConstraint]()
        let paddingBetweenObjects  = CGFloat(20)
        let buttonSize             = CGFloat(20)
        
        // left Stack
        constraints.append(sortByRankStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(sortByRankStackView.topAnchor.constraint(equalTo: self.topAnchor))
        
        // Right Stack
        constraints.append(priceAndRefreshStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(priceAndRefreshStackView.topAnchor.constraint(equalTo: self.topAnchor))
        
        // TableView
        constraints.append(cryptoListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(cryptoListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(cryptoListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(cryptoListTableView.topAnchor.constraint(equalTo: sortByRankStackView.bottomAnchor, constant: paddingBetweenObjects))
        
        // Refresh Button
        constraints.append(refreshBtn.widthAnchor.constraint(equalToConstant: buttonSize))
        constraints.append(refreshBtn.heightAnchor.constraint(equalToConstant: buttonSize))
        
        // Activity Indicator
        constraints.append(tableViewLoadingSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(tableViewLoadingSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
