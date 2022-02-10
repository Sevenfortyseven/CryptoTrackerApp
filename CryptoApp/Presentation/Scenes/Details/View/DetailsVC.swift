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
    
    /// Bool value for readMore button
    var isMorePressed: Bool = false
    
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
        populateStackView()
        initializeConstraints()
        startListening()
        setUpNavBar()
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.layoutIfNeeded()
        updateFrames()
        checkPositiveOrNegativeValues()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func addSubviews() {
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        self.contentView.addSubview(cryptoChart)
        self.contentView.addSubview(chartTimelineLabel)
        self.contentView.addSubview(coingLogo)
        self.contentView.addSubview(coinDescriptionLabel)
        self.contentView.addSubview(loadingSpinner)
        self.contentView.addSubview(coinDescriptionStack)
        self.contentView.addSubview(coinInfoStack)
    }
    
    private func populateStackView() {
        coinDescriptionStack.addArrangedSubview(coinDescriptionTextView)
        coinDescriptionStack.addArrangedSubview(readMoreBtn)
        coinInfoStack.addArrangedSubview(currentPriceAndRankStack)
        coinInfoStack.addArrangedSubview(marketCapAndVolumeStack)
        currentPriceAndRankStack.addArrangedSubview(currentPriceStack)
        currentPriceAndRankStack.addArrangedSubview(rankStack)
        currentPriceStack.addArrangedSubview(currrentPriceLabel)
        currentPriceStack.addArrangedSubview(currentPriceValue)
        currentPriceStack.addArrangedSubview(currentPriceValueUpdateAndImageStack)
        rankStack.addArrangedSubview(rankLabel)
        rankStack.addArrangedSubview(rankValue)
        currentPriceValueUpdateAndImageStack.addArrangedSubview(currentPriceUpdateImage)
        currentPriceValueUpdateAndImageStack.addArrangedSubview(currentPriceValueUpdate)
        marketCapAndVolumeStack.addArrangedSubview(marketCapStack)
        marketCapAndVolumeStack.addArrangedSubview(volumeStack)
        marketCapStack.addArrangedSubview(marketCapLabel)
        marketCapStack.addArrangedSubview(marketCapValue)
        marketCapStack.addArrangedSubview(marketCapUpdateAndImageStack)
        marketCapUpdateAndImageStack.addArrangedSubview(marketCapValueUpdateImage)
        marketCapUpdateAndImageStack.addArrangedSubview(marketCapValueUpdate)
        volumeStack.addArrangedSubview(volumeLabel)
        volumeStack.addArrangedSubview(volumeValue)
    }
    
    
    private func startListening() {
        detailsVM.chartData.bind { [weak self] pricesListener in
            DispatchQueue.main.async {
                self?.cryptoChart.data = pricesListener
            }
        }
        detailsVM.dataLoading.bind { [weak self] _ in
            self?.waitForLoad()
        }
        detailsVM.coinData.bind { [weak self] data in
            /// Get an image from url
            guard let url = data?.imageURL else { return }
            self?.coingLogo.loadImage(urlString: url)
            
            self?.coinDescriptionTextView.text = data?.overview
            self?.currentPriceValue.text = data?.currentPrice
            self?.currentPriceValueUpdate.text = data?.priceChangePercentage24H
            self?.rankValue.text = data?.marketCapRank
            self?.marketCapValue.text = data?.marketCap
            self?.marketCapValueUpdate.text = data?.marketCapChangePercentage24H
            self?.volumeValue.text = data?.totalVolume
            
        }
        /// hide view while vm fetching is in progress
      
        
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func updateFrames() {
        loadingSpinner.center = cryptoChart.center
        _ = coinInfoStack.smallCurve
    }
    
    private func setUpNavBar() {
        self.navigationItem.titleView?.alpha = 1
    
    }
    
    private func waitForLoad() {
        if detailsVM.isFetchingInProgress {
            UIView.animate(withDuration: 0.2) {
                self.cryptoChart.alpha = 0.0
                self.loadingSpinner.startAnimating()
            }
            
        } else {
            UIView.animate(withDuration: 0.2) {
                self.cryptoChart.alpha = 1
                self.loadingSpinner.stopAnimating()
            }
        }
    }
    
    /// Updates value / image color depending on the value data
    private func checkPositiveOrNegativeValues() {
            if currentPriceValueUpdate.text?.getFirstChar() == "-" {
                currentPriceUpdateImage.tintColor = .negativeRed
                currentPriceUpdateImage.rotateBy180(true)
                currentPriceValueUpdate.textColor = .negativeRed
            } else {
                currentPriceUpdateImage.tintColor = .positiveGreen
                currentPriceValueUpdate.textColor = .positiveGreen
            }
            
        if marketCapValueUpdate.text?.getFirstChar() == "-" {
            marketCapValueUpdateImage.tintColor = .negativeRed
            marketCapValueUpdateImage.rotateBy180(true)
            marketCapValueUpdate.textColor = .negativeRed
        } else {
            marketCapValueUpdateImage.tintColor = .positiveGreen
            marketCapValueUpdate.textColor = .positiveGreen
        }
       
    }
    
    // MARK: - UI Elements
    
    
    private let cryptoChart: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        _ = chart.customChartOptions
        chart.clipsToBounds = true
        chart.rightAxis.labelFont = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        chart.rightAxis.labelTextColor = .letterColor
        chart.isUserInteractionEnabled = false
        chart.animate(xAxisDuration: 3.0)
        return chart
    }()
    
    private let chartTimelineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Weekly Timeline"
        label.font = .preferredFont(forTextStyle: .title1 , compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let coingLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let coinDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About"
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        label.textColor = .white
        return label
    }()
    
    private let coinDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondaryColor
        textView.textColor = .letterColor
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 3
        textView.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .unspecified))
        return textView
    }()
    
    private let readMoreBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read more", for: .normal)
        button.tintColor = .borderColor
        button.addTarget(self, action: #selector(expandCoinDetailsTextView), for: .touchUpInside)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    private let coinDescriptionStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 1
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        return stack
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .borderColor
        return spinner
    }()
    
    private let mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryColor
        view.automaticallyAdjustsScrollIndicatorInsets = false
        return view
    }()
    /// ContentView for scrollView
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coinInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 120
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let currentPriceAndRankStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    
    private let currentPriceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fill
        return stack
    }()
    
    private let currentPriceValueUpdateAndImageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let currrentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Price"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let currentPriceValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let currentPriceValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let currentPriceUpdateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "triangle_Fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let marketCapAndVolumeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private let marketCapStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
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
    
    private let marketCapUpdateAndImageStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let marketCapValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapValueUpdateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "triangle_Fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let rankStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Rank"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let rankValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let volumeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        return stack
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let volumeValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    
}

// MARK: - Button actions

extension DetailsViewController {
    
    @objc private func expandCoinDetailsTextView() {
        if !isMorePressed {
            coinDescriptionTextView.textContainer.maximumNumberOfLines = 0
            coinDescriptionTextView.invalidateIntrinsicContentSize()
            readMoreBtn.setTitle("Less", for: .normal)
            isMorePressed = true
        } else {
            coinDescriptionTextView.textContainer.maximumNumberOfLines = 3
            coinDescriptionTextView.invalidateIntrinsicContentSize()
            readMoreBtn.setTitle("Read More", for: .normal)
            isMorePressed = false
        }
    }
    
    
    
}




// MARK: - Constraints

extension DetailsViewController {
    
    private func initializeConstraints() {
        let chartHeightMultiplier          = CGFloat(0.2)
        let topPadding                     = CGFloat(25)
        let imagePaddingRight              = CGFloat(-15)
        let leftPadding                    = CGFloat(25)
        let textPaddingLeft                = CGFloat(5)
        let textPaddingRight               = CGFloat(-5)
        let rightPadding                   = CGFloat(-25)
        let paddingBetweenObjects          = CGFloat(20)
        
        var constraints = [NSLayoutConstraint]()
        
        /// Crypto chart
        constraints.append(cryptoChart.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor))
        constraints.append(cryptoChart.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor))
        constraints.append(cryptoChart.topAnchor.constraint(equalTo: chartTimelineLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(cryptoChart.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: chartHeightMultiplier))
        
        /// Coin logo
        constraints.append(coingLogo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: imagePaddingRight))
        constraints.append(coingLogo.centerYAnchor.constraint(equalTo: coinDescriptionLabel.centerYAnchor))
        
        /// Coin name label
        constraints.append(chartTimelineLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(chartTimelineLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topPadding))
    
        
        /// Coin description label
        constraints.append(coinDescriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(coinDescriptionLabel.topAnchor.constraint(equalTo: cryptoChart.bottomAnchor, constant: paddingBetweenObjects))
        
        /// Coin description Stack
        constraints.append(coinDescriptionStack.topAnchor.constraint(equalTo: coinDescriptionLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(coinDescriptionStack.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: textPaddingLeft))
        constraints.append(coinDescriptionStack.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: textPaddingRight))
        
        
        /// ScrollView
        constraints.append(mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor))
        constraints.append(mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        
        /// ContentView
        constraints.append(contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor))
        constraints.append(contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor))
        constraints.append(contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor))
        constraints.append(contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor))
        constraints.append(contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor))
 
        /// Coin Data Stack
        constraints.append(coinInfoStack.topAnchor.constraint(equalTo: coinDescriptionStack.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(coinInfoStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
//        constraints.append(coinInfoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding))
//        constraints.append(coinInfoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding))
        constraints.append(coinInfoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50))
        
        NSLayoutConstraint.activate(constraints)
        
    }
}

