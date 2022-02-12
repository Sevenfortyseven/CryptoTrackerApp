//
//  SearchBarModule.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation
import UIKit

class SearchbarModule: UIView {
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initialize() {
        self.addSubview(searchBar)
        self.translatesAutoresizingMaskIntoConstraints = false
        initializeConstraints()
    }
    
    // MARK: - UI Elements
    
    
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = .secondaryColor
        searchBar.searchTextField.textColor = .white
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
    
    // MARK: - Constraints
    
    private func initializeConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(searchBar.topAnchor.constraint(equalTo: self.topAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
