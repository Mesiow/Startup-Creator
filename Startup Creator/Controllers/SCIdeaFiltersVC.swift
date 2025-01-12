//
//  SCIdeaFiltersVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/8/25.
//

import UIKit

class SCIdeaFiltersVC: UIViewController {
    weak var delegate: SCHomeDelegate!
    
    private var dismissButton = UIButton()
    private var applyButton = UIButton()
    private var filtersView = UIView()
    
    private var industryTypeFilterButton = UIButton(type: .system)
    private var marketTypeFilterButton = UIButton(type: .system)
    private var businessModelFilterButton = UIButton(type: .system)
    private var filter = SCGPTPromptFilter(industry: nil, market: nil, businessModel: nil)
    
    init(delegate: SCHomeDelegate, currentFilter: SCGPTPromptFilter){
        self.delegate = delegate
        self.filter = currentFilter
        
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureFiltersView()
        configureDismissButton()
        configureFilterButtonMenus()
        configureApplyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFilterText()
    }
    
    private func configureViewController(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    private func updateFilterText(){
        if filter.industry != nil { industryTypeFilterButton.setTitle(filter.industry!.rawValue, for: .normal)}
        if filter.market != nil { marketTypeFilterButton.setTitle(filter.market!.rawValue, for: .normal)}
        if filter.businessModel != nil { businessModelFilterButton.setTitle(filter.businessModel!.rawValue, for: .normal)}
    }
    
    private func configureDismissButton(){
        filtersView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(SCImages.xImage, for: .normal)
        dismissButton.tintColor = SCColors.symbol
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            
            dismissButton.topAnchor.constraint(equalTo: filtersView.topAnchor, constant: 5),
            dismissButton.trailingAnchor.constraint(equalTo: filtersView.trailingAnchor, constant: -5)
        ])
    }
    
    @objc func applyButtonPressed(){
        delegate.updateFilter(filter: self.filter)
        dismiss(animated: true)
    }
    
    private func configureApplyButton() {
        filtersView.addSubview(applyButton)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.backgroundColor = SCColors.symbol
        applyButton.layer.cornerRadius = 12.0
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        applyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.addTarget(self, action: #selector(applyButtonPressed), for: .touchUpInside)
        
        let width = 140.0
        let height = 44.0
        NSLayoutConstraint.activate([
            applyButton.widthAnchor.constraint(equalToConstant: width),
            applyButton.heightAnchor.constraint(equalToConstant: height),
            applyButton.bottomAnchor.constraint(equalTo: filtersView.bottomAnchor, constant: -10),
            applyButton.centerXAnchor.constraint(equalTo: filtersView.centerXAnchor)
        ])
    }
    
    private func createFilterMenuMarketType() -> UIMenu {
        var actions: [UIAction] = []
        for type in MarketType.allCases {
            let action = UIAction(title: type.rawValue) { [weak self] action in
                guard let self = self else { return }
                self.filter.market = type
                self.marketTypeFilterButton.setTitle(action.title, for: .normal)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Market", options: .displayInline, children: actions)
        return menu
     }
     
     private func createFilterMenuBusinessModel() -> UIMenu {
         var actions: [UIAction] = []
         for type in BusinessModel.allCases {
             let action = UIAction(title: type.rawValue) { [weak self] action in
                 guard let self = self else { return }
                 self.filter.businessModel = type
                 self.businessModelFilterButton.setTitle(action.title, for: .normal)
             }
             actions.append(action)
         }
         
         let menu = UIMenu(title: "Business Model", options: .displayInline, children: actions)
         return menu
     }
    
    private func createFilterMenuIndustry() -> UIMenu {
        var actions: [UIAction] = []
        for type in Industry.allCases {
            let action = UIAction(title: type.rawValue) { [weak self] action in
                guard let self = self else { return }
                self.filter.industry = type
                self.industryTypeFilterButton.setTitle(action.title, for: .normal)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Industry", options: .displayInline, children: actions)
        return menu
    }
    
    
    private func configureFilterButtonMenus(){
        industryTypeFilterButton.setTitle("Industry", for: .normal)
        marketTypeFilterButton.setTitle("Market", for: .normal)
        businessModelFilterButton.setTitle("Business Model", for: .normal)
        
        configureFilterButton(industryTypeFilterButton)
        configureFilterButton(marketTypeFilterButton)
        configureFilterButton(businessModelFilterButton)
        
        industryTypeFilterButton.menu = createFilterMenuIndustry()
        marketTypeFilterButton.menu = createFilterMenuMarketType()
        businessModelFilterButton.menu = createFilterMenuBusinessModel()
        
        let width = 180.0
        let height = 44.0
        NSLayoutConstraint.activate([
            
            industryTypeFilterButton.widthAnchor.constraint(equalToConstant: width),
            industryTypeFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            businessModelFilterButton.widthAnchor.constraint(equalToConstant: width),
            businessModelFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            marketTypeFilterButton.widthAnchor.constraint(equalToConstant: width),
            marketTypeFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            
            industryTypeFilterButton.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 5),
            industryTypeFilterButton.centerXAnchor.constraint(equalTo: filtersView.centerXAnchor),
            
            marketTypeFilterButton.topAnchor.constraint(equalTo: industryTypeFilterButton.bottomAnchor, constant: 5),
            marketTypeFilterButton.centerXAnchor.constraint(equalTo: industryTypeFilterButton.centerXAnchor),
            
            businessModelFilterButton.topAnchor.constraint(equalTo: marketTypeFilterButton.bottomAnchor, constant: 5),
            businessModelFilterButton.centerXAnchor.constraint(equalTo: marketTypeFilterButton.centerXAnchor)
        ])
    }
    
    private func configureFilterButton(_ button: UIButton){
        filtersView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.showsMenuAsPrimaryAction = true
    }
    
    private func configureFiltersView(){
        view.addSubview(filtersView)
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        filtersView.backgroundColor = SCColors.background
        filtersView.layer.cornerRadius = 4.0
        
        NSLayoutConstraint.activate([
            filtersView.heightAnchor.constraint(equalToConstant: 380),
            filtersView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filtersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            filtersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
}
