//
//  HomeViewController1.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: - Instances and Properties
    
    var viewModel = HomeViewModel()
    
    /// Bool value for an imageView that updates after user presses sortBy options
    private var isPriceImageRotated: Bool = false
    private var isRankImageRotated: Bool = false
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        populateStackView()
        initializeConstraints()
        configureTableView()
        configureSearchBar()
        startListening()
        addTapGestureRecognizer()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.isHidden = true
        }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
        checkForNegativeOrPositiveValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    private func addSubviews() {
        self.view.addSubview(cryptoListTableView)
        self.view.addSubview(priceAndRefreshStackView)
        self.view.addSubview(searchBar)
        self.view.addSubview(navigationStackView)
        self.view.addSubview(marketInfoStackView)
        self.view.addSubview(sortByRankStackView)
        self.view.addSubview(loadingSpinner)
    }
    
    private func populateStackView() {
        priceAndRefreshStackView.addArrangedSubview(sortByPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(sortingImageForPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(refreshBtn)
        navigationStackView.addArrangedSubview(editPortfolioPageBtn)
        navigationStackView.addArrangedSubview(currentPageTitle)
        navigationStackView.addArrangedSubview(portfolioPageBtn)
        marketInfoStackView.addArrangedSubview(marketCapStackView)
        marketInfoStackView.addArrangedSubview(volume24HStackView)
        marketInfoStackView.addArrangedSubview(btcDominanceStackView)
        marketCapStackView.addArrangedSubview(marketCapLabel)
        marketCapStackView.addArrangedSubview(marketCapValue)
        marketCapStackView.addArrangedSubview(marketCapValueUpdateStackView)
        marketCapValueUpdateStackView.addArrangedSubview(marketCapValueImage)
        marketCapValueUpdateStackView.addArrangedSubview(marketCapValueUpdate)
        volume24HStackView.addArrangedSubview(volume24HLabel)
        volume24HStackView.addArrangedSubview(volume24HLabelValue)
        btcDominanceStackView.addArrangedSubview(btcDominanceLabel)
        btcDominanceStackView.addArrangedSubview(btcDominanceValueLabel)
        sortByRankStackView.addArrangedSubview(sortByRankBtn)
        sortByRankStackView.addArrangedSubview(sortingImageForRankBtn)
    }
    
    private func startListening() {
        viewModel.tableViewNeedsReload.bind { [weak self] _ in
            self?.cryptoListTableView.reloadData()
        }
        viewModel.tableViewIsReloading.bind { [weak self]_ in
            let isTableViewloading = self?.viewModel.isTableViewLoading ?? false
            if isTableViewloading {
                self?.loadingSpinner.startAnimating()
                UIView.animate(withDuration: 0.2) {
                    self?.cryptoListTableView.alpha = 0.0
                }
            } else {
                self?.loadingSpinner.stopAnimating()
                UIView.animate(withDuration: 0.2) {
                    self?.cryptoListTableView.alpha = 1.0
                }
                
            }
        }
        
        viewModel.globalData.bind { [weak self] listener in
            self?.marketCapValue.text = listener?.totalMarketCap
            self?.marketCapValueUpdate.text = listener?.marketCapChangePercentage24HUsd
            self?.volume24HLabelValue.text = listener?.totalVolume
            self?.btcDominanceValueLabel.text = listener?.marketCapPercentage
        }
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        UIView.animate(withDuration: 1) {
            self.sortingImageForPriceBtn.isHidden = true
            self.sortingImageForRankBtn.isHidden = true
        }
       
    }
    
    private func updateFrames() {
        cryptoListTableView.layoutIfNeeded()
        _ = cryptoListTableView.mediumCurve
        loadingSpinner.center = cryptoListTableView.center
    }
    
    // Check for negative or positive value and rotate image/ change it's color accordingly
    private func checkForNegativeOrPositiveValues() {
        
        if marketCapValueUpdate.text?.getFirstChar() == "-" {
            marketCapValueImage.tintColor = .negativeRed
            marketCapValueImage.rotateBy180(true)
        } else {
            marketCapValueImage.tintColor = .positiveGreen
        }
        
    }
    
    // Check for UI changes after sorting buttons are pressed
    private func updateUIAfterInteraction() {
        if viewModel.isAscendingByPrice == true {
            sortingImageForPriceBtn.isHidden = false
            sortingImageForPriceBtn.rotateBy180(true)
            isPriceImageRotated = true
        } else {
            sortingImageForPriceBtn.rotateBy180(false)
            isPriceImageRotated = false
        }
        if viewModel.isAscendingByRank == true {
            sortingImageForRankBtn.isHidden = false
            sortingImageForRankBtn.rotateBy180(true)
            isRankImageRotated = true
        } else {
            sortingImageForRankBtn.rotateBy180(false)
            isRankImageRotated = true
        }
        
    }
    
    
    // MARK: - UI Elements
    
    private let cryptoListTableView: UITableView = {
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
    
    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let marketInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let marketCapValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let marketCapValueImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "triangle_Fill")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let marketCapValueUpdateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let marketCapValueUpdate: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let volume24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let volume24HLabelValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let volume24HStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let btcDominanceLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC Dominance"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let btcDominanceValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let btcDominanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    
    private let currentPageTitle: UILabel = {
        let label = UILabel()
        label.text = "Live Prices"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let portfolioPageBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "next"), for: .normal)
        return button
    }()
    
    private let editPortfolioPageBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "plus"), for: .normal)
        return button
    }()
    
    private let refreshBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.tintColor = .borderColor
        return button
    }()
    
    private let sortByRankBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        button.addTarget(self, action: #selector(reorderDataByRank), for: .touchUpInside)
        button.setTitle("Coin", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let sortByPriceBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        button.addTarget(self, action: #selector(reorderDataByPrice), for: .touchUpInside)
        button.setTitle("Price", for: .normal)
        return button
    }()
    
    private let sortingImageForPriceBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let sortingImageForRankBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = .secondaryColor
        searchBar.searchTextField.textColor = .white
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .borderColor
        return spinner
    }()
    
}

    //MARK: - SearchBar Configuration and Delegate

extension HomeViewController: UISearchBarDelegate {
    
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        viewModel.searchText = searchText
    }
    
 
}

    //MARK: - Button Actions and Tap Recognizers

extension HomeViewController {
    
    /// Updates VM to refresh Data
    @objc private func refreshData() {
        NotificationCenter.default.post(name: .refreshData, object: nil)
        refreshBtn.rotate()
        updateUI()
    }
    
    /// Updates VM to re-order Coin data by ascending or descending
    @objc private func reorderDataByRank() {
        NotificationCenter.default.post(name: .reorderByRank, object: nil)
        updateUIAfterInteraction()
    }
    
    /// Updates VM to re-order Coin data by price ascending or descending
    @objc private func reorderDataByPrice() {
        NotificationCenter.default.post(name: .reorderByPrice, object: nil)
        updateUIAfterInteraction()
    }
    
    ///Dismiss keyboard when the tap is recognized
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func addTapGestureRecognizer() {
        // Look for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
}


    //MARK: - TableView Configuration, Delegate & Datasource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        cryptoListTableView.register(CryptoListTableViewCell.self, forCellReuseIdentifier: CryptoListTableViewCell.reuseID)
        cryptoListTableView.delegate = self
        cryptoListTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cryptoListTableView.dequeueReusableCell(withIdentifier: CryptoListTableViewCell.reuseID, for: indexPath) as! CryptoListTableViewCell
        cell.cellViewModel = viewModel.getCellVM(at: indexPath)
       return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Navigate to Details Screen and pass appropriate viewModel
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVM  = viewModel.initDetailsVM(for: indexPath) else { return }
        let detailsVC = DetailsViewController(detailsVM)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}




    // MARK: - Constraints

extension HomeViewController {
    
    private func initializeConstraints() {
        let tableViewHeightMultiplier      = CGFloat(0.6)
        let paddingBetweenObjects          = CGFloat(20)
        let paddingBetweenObjectsNegative  = CGFloat(-15)
        let topPadding                     = CGFloat(25)
        let leftPadding                    = CGFloat(25)
        let rightPadding                   = CGFloat(-25)
        let navigationButtonSize           = CGFloat(40)
        let buttonSize                     = CGFloat(20)
        let searchBarWidthMultiplier       = CGFloat(0.9)
        let marketCapIconSize              = CGFloat(15)

        var constraints = [NSLayoutConstraint]()
        
        // TableView
        constraints.append(cryptoListTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: tableViewHeightMultiplier))
        constraints.append(cryptoListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(cryptoListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(cryptoListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        
        // Right-side StackView
        constraints.append(priceAndRefreshStackView.trailingAnchor.constraint(equalTo: cryptoListTableView.trailingAnchor))
        constraints.append(priceAndRefreshStackView.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        constraints.append(priceAndRefreshStackView.centerYAnchor.constraint(equalTo: sortByRankBtn.centerYAnchor))
        
        // Sort by market cap stack
        constraints.append(sortByRankStackView.leadingAnchor.constraint(equalTo: cryptoListTableView.leadingAnchor))
        constraints.append(sortByRankStackView.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        
        // Refresh Button
        constraints.append(refreshBtn.widthAnchor.constraint(equalToConstant: buttonSize))
        constraints.append(refreshBtn.heightAnchor.constraint(equalToConstant: buttonSize))
        
        // Search Bar
        constraints.append(searchBar.searchTextField.leadingAnchor.constraint(equalTo: cryptoListTableView.leadingAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: sortByRankBtn.topAnchor,constant: paddingBetweenObjectsNegative))
        constraints.append(searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))

        
        // Top navigationStack
        constraints.append(navigationStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topPadding))
        constraints.append(navigationStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: leftPadding))
        constraints.append(navigationStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        
        // Navigation Buttons
        constraints.append(portfolioPageBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(editPortfolioPageBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(portfolioPageBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(editPortfolioPageBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        
        // Market Info StackView
        constraints.append(marketInfoStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(marketInfoStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(marketInfoStackView.topAnchor.constraint(equalTo: navigationStackView.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(marketCapValueImage.widthAnchor.constraint(equalToConstant: marketCapIconSize))
        constraints.append(marketCapValueImage.heightAnchor.constraint(equalToConstant: marketCapIconSize))
        
        
        
        NSLayoutConstraint.activate(constraints)
    }
}
