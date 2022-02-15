//
//  EditPortfolioVC.swift
//  CryptoApp
//
//  Created by aleksandre on 13.02.22.
//

import Foundation
import UIKit


class MarketplaceViewController: UIViewController, UITextFieldDelegate{
   
   // MARK: - Instances & Properties
   
   private let searchbarModule = SearchbarModule()
   public var viewModel: MarketPlaceViewModel?
   
   
   
   // MARK: - Initialization
   
   init(_ viewModel: MarketPlaceViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      updateUI()
      addSubviews()
      populateStack()
      registerCollectionView()
      initializeConstraints()
      startListening()
      configure()
      addGestureRecognizer()
   }
   
   
   override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      updateFrames()
      
   }
   
   private func addSubviews() {
      self.view.addSubview(pageTitle)
      self.view.addSubview(searchbarModule)
      self.view.addSubview(marketplaceCollectionView)
      self.view.addSubview(leftStack)
      self.view.addSubview(rightStack)
      self.view.addSubview(saveButton)
      self.view.addSubview(checkmarkImage)
      
   }
   
   private func populateStack() {
      leftStack.addArrangedSubview(currentPriceLabel)
      leftStack.addArrangedSubview(amoundHoldingLabel)
      leftStack.addArrangedSubview(currentValueLabel)
      rightStack.addArrangedSubview(currentPriceValue)
      rightStack.addArrangedSubview(amountHoldingTextField)
      rightStack.addArrangedSubview(currentValue)
   }
    
   
   private func startListening() {
      /// reload collectionView when cell VM is updated
      viewModel?.cellVMWasUpdated.bind(listener: { [weak self] _ in
         self?.marketplaceCollectionView.reloadData()
      })
      
      viewModel?.totalPriceValue.bind(listener: { [weak self] listener in
         self?.currentValue.text = listener
      })
      
      
   }
   
   
   // MARK: - UI Configuration
   
   private func updateUI() {
      self.view.backgroundColor = .primaryColor
      marketplaceCollectionView.backgroundColor = .secondaryColor
   }
   
   private func updateFrames() {
      marketplaceCollectionView.layoutIfNeeded()
//      _ = marketplaceCollectionView.mediumCurve
   }
   
   private func showCheckmark() {
      UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.transitionCrossDissolve) {
         self.checkmarkImage.alpha = 1
      } completion: { finished in
         self.checkmarkImage.alpha = 0
      }

   }
   
   
   // MARK: - UI Elements
   
   private let pageTitle: UILabel = {
      let label = UILabel()
      label.text = "Marketplace"
      label.textColor = .white
      label.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: .init(legibilityWeight: .bold))
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let marketplaceCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.layer.borderWidth = 0.2
      collectionView.layer.borderColor = UIColor.borderColor.cgColor
      return collectionView
   }()
   
   private let leftStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.distribution = .fillEqually
      stack.alignment = .fill
      return stack
   }()
   
   private let rightStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.distribution = .fillEqually
      stack.alignment = .trailing
      return stack
   }()
   
   private let currentPriceLabel: UILabel = {
      let label = UILabel()
      label.text = "Current Price:"
      label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
      label.textColor = .white
      return label
   }()
   
   private let amoundHoldingLabel: UILabel = {
      let label = UILabel()
      label.text = "Amound Holding:"
      label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
      label.textColor = .white
      return label
   }()
   
   private let currentValueLabel: UILabel = {
      let label = UILabel()
      label.text = "Current Value:"
      label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
      label.textColor = .white
      return label
   }()
   
   private let currentPriceValue: UILabel = {
      let label = UILabel()
      label.textColor = .white
      label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
      return label
   }()
   
   private let currentValue: UILabel = {
      let label = UILabel()
      label.textColor = .white
      
      label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
      return label
   }()
   
   private let amountHoldingTextField: UITextField = {
      let textField = UITextField()
      textField.textColor = .white
      textField.textAlignment = .right
      textField.autocorrectionType = .no
      textField.keyboardType = .numberPad
      textField.attributedPlaceholder = NSAttributedString(string: "Enter amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.borderColor.withAlphaComponent(0.2)])
      textField.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
      return textField
   }()
   
   private let saveButton: UIButton = {
      let button = UIButton(type: .system)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("Save", for: .normal)
      button.tintColor = .borderColor
      button.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
      button.isHidden = true
      button.titleLabel?.font = .preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
      return button
   }()
   
   private let checkmarkImage: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(systemName: "checkmark")
      imageView.contentMode = .scaleAspectFit
      imageView.alpha = 0
      imageView.tintColor = .borderColor
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
}


// MARK: Searchbar  & Textfield Configuration

extension MarketplaceViewController: UISearchBarDelegate {
   
   private func configure() {
      searchbarModule.searchBar.delegate = self
      amountHoldingTextField.delegate = self
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      viewModel?.updateData(searchText)
   }
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      /// Allow to display only digits
      let allowedCharacters = CharacterSet.decimalDigits
      let charSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: charSet)
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      self.currentValue.text = viewModel?.getTotalValue(textField.text)
      UIView.animate(withDuration: 0.5) {
         self.saveButton.isHidden = true
         self.amountHoldingTextField.text = ""
      }
      
   }
   
   func textFieldDidChangeSelection(_ textField: UITextField) {
      self.currentValue.text = viewModel?.getTotalValue(textField.text)
      UIView.animate(withDuration: 0.5) {
         self.saveButton.isHidden = false
      }
      
   }
}



   // MARK: - Actions and Gesture Recognizers

extension MarketplaceViewController {
   
   private func addGestureRecognizer() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tap.cancelsTouchesInView = false
      self.view.addGestureRecognizer(tap)
   }
   ///Dismiss keyboard when the tap is recognized
   @objc private func dismissKeyboard() {
      view.endEditing(true)
   }
   
   @objc private func saveBtnPressed() {
      viewModel?.updateTotalHoldings()
      currentValue.text = ""
      self.showCheckmark()
   }
   
}



    // MARK: - CollectionView Delagate & Datasource

extension MarketplaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
   private func registerCollectionView() {
      marketplaceCollectionView.register(MarketplaceCollectionCell.self, forCellWithReuseIdentifier: MarketplaceCollectionCell.reuseID)
      marketplaceCollectionView.delegate = self
      marketplaceCollectionView.dataSource = self
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return viewModel?.numberOfItems ?? 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = marketplaceCollectionView.dequeueReusableCell(withReuseIdentifier: MarketplaceCollectionCell.reuseID, for: indexPath) as! MarketplaceCollectionCell
      cell.cellVM = viewModel?.getCellVM(indexPath)
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height - 15)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 50
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let cell = collectionView.cellForItem(at: indexPath) {
         cell.layoutIfNeeded()
         cell.contentView.backgroundColor = .primaryColor
         cell.layer.borderWidth = 1
      }
      viewModel?.currentIndex = indexPath
      self.currentPriceValue.text = viewModel?.getCellVM(indexPath).coinPrice
   }
   
   func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      if let cell = collectionView.cellForItem(at: indexPath) {
         cell.contentView.backgroundColor = nil
         cell.layer.borderWidth = 0
      }
   }
    
}




   // MARK: - Constraints

extension MarketplaceViewController {
   
   
   private func initializeConstraints() {
      let paddingBetweenObjects          = CGFloat(20)
      let topPadding                     = CGFloat(25)
      let leftPadding                    = CGFloat(25)
      let rightPadding                   = CGFloat(-25)
      let searchBarWidthMultiplier       = CGFloat(0.9)
      let collectionViewHeightMultiplier = CGFloat(0.15)
      let stackHeightMultiplier          = CGFloat(0.15)
      let stackWidthMultiplier           = CGFloat(0.10)
      let checkMarkImageSize             = CGFloat(30)
      var constraints                    = [NSLayoutConstraint]()
      
      /// Page Title
      constraints.append(pageTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
      constraints.append(pageTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topPadding))
      
      /// Searchbar Module
      constraints.append(searchbarModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
      constraints.append(searchbarModule.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: paddingBetweenObjects))
      constraints.append(searchbarModule.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))
      
      /// CollectionView
      constraints.append(marketplaceCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
      constraints.append(marketplaceCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
      constraints.append(marketplaceCollectionView.topAnchor.constraint(equalTo: searchbarModule.bottomAnchor, constant: paddingBetweenObjects))
      constraints.append(marketplaceCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: collectionViewHeightMultiplier))
      
      /// LeftSide stack
      constraints.append(leftStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
      constraints.append(leftStack.topAnchor.constraint(equalTo: marketplaceCollectionView.bottomAnchor, constant: paddingBetweenObjects))
      constraints.append(leftStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: stackHeightMultiplier))
      
      /// RightSide stack
      constraints.append(rightStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
      constraints.append(rightStack.centerYAnchor.constraint(equalTo: leftStack.centerYAnchor))
      //        constraints.append(rightStack.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: stackWidthMultiplier))
      constraints.append(rightStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: stackHeightMultiplier))
      
      /// Save Button
      constraints.append(saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
      constraints.append(saveButton.centerYAnchor.constraint(equalTo: pageTitle.centerYAnchor))
      
      /// Checkmark image
      constraints.append(checkmarkImage.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor))
      constraints.append(checkmarkImage.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor))
      constraints.append(checkmarkImage.widthAnchor.constraint(equalToConstant: checkMarkImageSize))
      constraints.append(checkmarkImage.heightAnchor.constraint(equalToConstant: checkMarkImageSize))
      
      NSLayoutConstraint.activate(constraints)
   }
   
    
}
