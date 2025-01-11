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
    private var businessTypeFilterButton = UIButton(type: .system)
    private var businessTargetFilterButton = UIButton(type: .system)
    private var filter = SCGPTPromptFilter(industry: nil, type: nil, target: nil)
    
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
        if filter.type != nil { businessTypeFilterButton.setTitle(filter.type!.rawValue, for: .normal)}
        if filter.target != nil { businessTargetFilterButton.setTitle(filter.target!.rawValue, for: .normal)}
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
    
    private func createFilterMenuBusinessType() -> UIMenu {
         let action1 = UIAction(title: BusinessType.saas.rawValue, handler: { [weak self] action in
             guard let self = self else { return }
             self.filter.type = .saas
             self.businessTypeFilterButton.setTitle(action.title, for: .normal)
         })
         let action2 = UIAction(title: BusinessType.physical.rawValue, handler: { [weak self] action in
             guard let self = self else { return }
             self.filter.type = .physical
             self.businessTypeFilterButton.setTitle(action.title, for: .normal)
         })
         let menu = UIMenu(title: "Business Type", options: .displayInline, children: [action1, action2])
         return menu
     }
     
     private func createFilterMenuBusinessTarget() -> UIMenu {
         let action1 = UIAction(title: BusinessTarget.b2c.rawValue, handler: { [weak self] action in
             guard let self = self else { return }
             self.filter.target = .b2c
             self.businessTargetFilterButton.setTitle(action.title, for: .normal)
         })
         let action2 = UIAction(title: BusinessTarget.b2b.rawValue, handler: { [weak self] action in
             guard let self = self else { return }
             self.filter.target = .b2b
             self.businessTargetFilterButton.setTitle(action.title, for: .normal)
         })
         let menu = UIMenu(title: "Business Model", options: .displayInline, children: [action1, action2])
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
        businessTypeFilterButton.setTitle("Business Type", for: .normal)
        businessTargetFilterButton.setTitle("Business Model", for: .normal)
        
        configureFilterButton(industryTypeFilterButton)
        configureFilterButton(businessTypeFilterButton)
        configureFilterButton(businessTargetFilterButton)
        
        industryTypeFilterButton.menu = createFilterMenuIndustry()
        businessTypeFilterButton.menu = createFilterMenuBusinessType()
        businessTargetFilterButton.menu = createFilterMenuBusinessTarget()
        
        let width = 180.0
        let height = 44.0
        NSLayoutConstraint.activate([
            
            industryTypeFilterButton.widthAnchor.constraint(equalToConstant: width),
            industryTypeFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            businessTargetFilterButton.widthAnchor.constraint(equalToConstant: width),
            businessTargetFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            businessTypeFilterButton.widthAnchor.constraint(equalToConstant: width),
            businessTypeFilterButton.heightAnchor.constraint(equalToConstant: height),
            
            
            industryTypeFilterButton.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 5),
            industryTypeFilterButton.centerXAnchor.constraint(equalTo: filtersView.centerXAnchor),
            
            businessTypeFilterButton.topAnchor.constraint(equalTo: industryTypeFilterButton.bottomAnchor, constant: 5),
            businessTypeFilterButton.centerXAnchor.constraint(equalTo: industryTypeFilterButton.centerXAnchor),
            
            businessTargetFilterButton.topAnchor.constraint(equalTo: businessTypeFilterButton.bottomAnchor, constant: 5),
            businessTargetFilterButton.centerXAnchor.constraint(equalTo: businessTypeFilterButton.centerXAnchor)
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
