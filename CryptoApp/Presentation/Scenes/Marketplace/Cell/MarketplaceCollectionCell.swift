//
//  MarketplaceCollectionCell.swift
//  CryptoApp
//
//  Created by aleksandre on 13.02.22.
//

import Foundation
import UIKit

class MarketplaceCollectionCell: UICollectionViewCell {
    
    private(set) static var reuseID = String(describing: self)

    public var cellVM: MarketplaceCellViewModel? {
        didSet {
            guard let cellVM = cellVM else { return }
            self.coinImageView.loadImage(urlString: cellVM.imageURL)
            self.coinNameLabel.text = cellVM.coinName
            self.coinIDLabel.text = cellVM.coinID
        }
    }
    
    
    // MARK: - Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        initializeConstraints()
        self.isSelected = true
        self.layer.borderColor = UIColor.borderColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = mediumCurve
    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 0
        self.contentView.backgroundColor = nil
    }
    
    private func addSubviews() {
        
        self.contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(coinImageView)
        contentStack.addArrangedSubview(coinIDLabel)
        contentStack.addArrangedSubview(coinNameLabel)
    }
    
    
    // MARK: - UI Configuration
    
    
    
    
    // MARK: - UI Elements
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .letterColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let coinIDLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    
}


    // MARK: - Constraints

extension MarketplaceCollectionCell {
    
    private func initializeConstraints() {
        let topPadding   = CGFloat(5)
        let botPadding   = CGFloat(-5)
        let leftPadding  = CGFloat(5)
        let rightPadding = CGFloat(-5)
        
        let imageSizeMultiplier = CGFloat(0.6)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(contentStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: botPadding))
        constraints.append(contentStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: rightPadding))
        constraints.append(contentStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topPadding))
        
        constraints.append(coinImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: imageSizeMultiplier))
        constraints.append(coinImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: imageSizeMultiplier))
        
        NSLayoutConstraint.activate(constraints)
    }
}
