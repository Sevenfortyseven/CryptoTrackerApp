//
//  CryptoListTableViewCell.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import UIKit

class CryptoListTableViewCell: UITableViewCell {
    
    private(set) static var reuseID = String(describing: CryptoListTableViewCell.self)
    
    public var cellViewModel: CryptoCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else {
                return
            }
            marketCapRankLabel.text         = cellViewModel.marketCapRank
            currentPriceLabel.text          = cellViewModel.currentPriceAsString
            priceChangePercenrageLabel.text = cellViewModel.priceChangePercentage24H
            symbolLabel.text                = cellViewModel.symbol
            cryptoIconView.loadImage(urlString: cellViewModel.iconURL)
            
            // Change Percentage label textColor according to to given percentage value
            if cellViewModel.priceChangePercentage24H.getFirstChar() ==  "-" {
                priceChangePercenrageLabel.textColor = .negativeRed
            } else {
                priceChangePercenrageLabel.textColor = .positiveGreen
            }
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CryptoListTableViewCell.reuseID)
        updateUI()
        addSubviews()
        populateStackView()
        initializeConstraints()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func addSubviews() {
        self.contentView.addSubview(leftSideStackView)
        self.contentView.addSubview(rightSideStackView)
    }
    
    private func populateStackView() {
        leftSideStackView.addArrangedSubview(marketCapRankLabel)
        leftSideStackView.addArrangedSubview(cryptoIconView)
        leftSideStackView.addArrangedSubview(symbolLabel)
        rightSideStackView.addArrangedSubview(currentPriceLabel)
        rightSideStackView.addArrangedSubview(priceChangePercenrageLabel)
    }
    
    // MARK: - UI Configuration
    private func updateUI() {
        self.clipsToBounds = true
        self.backgroundColor = .clear

    }
    
    
    // MARK: - UI Elements
    
    private let leftSideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.clipsToBounds = false
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rightSideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let marketCapRankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .letterColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cryptoIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .justified
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .letterColor
        return label
    }()
    
    private let priceChangePercenrageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .positiveGreen
        label.textAlignment = .right
        return label
    }()

}
    
    
    // MARK: - Constraints

extension CryptoListTableViewCell {
    
    private func initializeConstraints() {
        let stackViewWidthMultiplier = CGFloat(0.45)
        let imageViewSizeMultiplier = CGFloat(0.8)
        let numerationLabelMultiplier = CGFloat(0.15)
        let topPadding = CGFloat(15)
        let leftPadding = CGFloat(15)
        let rightPadding = CGFloat(-15)
        
        var constraints = [NSLayoutConstraint]()
        
        /// Left side StackVIew
        constraints.append(leftSideStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(leftSideStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topPadding))
        constraints.append(leftSideStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor))
        constraints.append(leftSideStackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: stackViewWidthMultiplier))
        
        /// Right side StackView
        constraints.append(rightSideStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: rightPadding))
        constraints.append(rightSideStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topPadding))
        constraints.append(rightSideStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor))
        
        /// Coin Icon
        constraints.append(cryptoIconView.heightAnchor.constraint(equalTo: leftSideStackView.heightAnchor, multiplier: imageViewSizeMultiplier))
        constraints.append(cryptoIconView.widthAnchor.constraint(equalTo: leftSideStackView.heightAnchor, multiplier: imageViewSizeMultiplier))
        
        /// Numeration label
        constraints.append(marketCapRankLabel.widthAnchor.constraint(equalTo: leftSideStackView.widthAnchor, multiplier: numerationLabelMultiplier))
        
        NSLayoutConstraint.activate(constraints)
    }
}
