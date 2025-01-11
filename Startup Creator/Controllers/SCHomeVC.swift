//
//  SCHomeVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/3/25.
//

import UIKit

protocol SCHomeDelegate: AnyObject {
    func updateFilter(filter: SCGPTPromptFilter)
}

class SCHomeVC: UIViewController {
    
    weak var listDelegate: SCSavedStartupIdeaListDelegate!
    
    private var titleLabel = UILabel()
    private var lightImageView = UIImageView()
    private var findButton = UIButton(type: .system)
    private var filtersButton = UIButton(type: .system)
    
    //default
    private var filter = SCGPTPromptFilter(industry: nil, type: nil, target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SCColors.background
        configureFindButton()
        configureFilterButton()
        configureLightImageView()
        configureTitleLabel()
    }
    
    private func pushStartupIdeaVC(response: SCGPTResponse){
        //Update UI on the main thread
        DispatchQueue.main.async {
            let content = getSCGPTResponseMessage(response: response) ?? ""
        
            let startupIdeaVC = SCStartupIdeaVC(delegate: self.listDelegate, content: content)
            self.navigationController?.pushViewController(startupIdeaVC, animated: true)
        }
    }
    
    @objc func findButtonPressed(_ sender: UIButton){
        guard filter.industry != nil, filter.type != nil, filter.target != nil else {
            presentAlertOnMainThread(title: "Enter your filters", message: "You must enter filters so we have a general idea of what type of business idea to provide to you.")
            return
        }
        
        let prompt = SCPrompt.createIdeaPrompt(filter: filter, maxTokens: SCNetworkManager.shared.maxTokens)
        SCNetworkManager.shared.makeRequest(prompt: prompt) { [weak self] result in
            guard let self = self else { return }
        
            switch result {
                case .success(let response):
                    pushStartupIdeaVC(response: response)
                
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue)
            }
        }
    }
    
    @objc func filtersButtonPressed(){
        let filtersVC = SCIdeaFiltersVC(delegate: self, currentFilter: self.filter)
        present(filtersVC, animated: true)
    }
    
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Startup Creator"
        titleLabel.tintColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: lightImageView.topAnchor, constant: -15),
        ])
    }
    
    private func configureFilterButton(){
        view.addSubview(filtersButton)
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.setTitle("Filters", for: .normal)
        filtersButton.backgroundColor = .systemGray
        filtersButton.setTitleColor(.white, for: .normal)
        filtersButton.layer.cornerRadius = 8.0
        filtersButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        filtersButton.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
        
        let width = 150.0
        let height = 44.0
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: width),
            filtersButton.heightAnchor.constraint(equalToConstant: height),
            
            filtersButton.bottomAnchor.constraint(equalTo: findButton.topAnchor, constant: -5),
            filtersButton.centerXAnchor.constraint(equalTo: findButton.centerXAnchor)
        ])
    }
    
    private func configureLightImageView(){
        view.addSubview(lightImageView)
        lightImageView.translatesAutoresizingMaskIntoConstraints = false
        lightImageView.image = SCImages.lightbulbYellowImage
        lightImageView.tintColor = .label
        lightImageView.contentMode = .scaleAspectFit
        
        let width = 80.0
        let height = 80.0
        NSLayoutConstraint.activate([
            lightImageView.widthAnchor.constraint(equalToConstant: width),
            lightImageView.heightAnchor.constraint(equalToConstant: height),
            lightImageView.bottomAnchor.constraint(equalTo: filtersButton.topAnchor, constant: -8),
            lightImageView.centerXAnchor.constraint(equalTo: filtersButton.centerXAnchor)
        ])
    }
    
    private func configureFindButton(){
        view.addSubview(findButton)
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.backgroundColor = SCColors.symbol
        findButton.layer.cornerRadius = 12.0
        findButton.setTitle("Search", for: .normal)
        findButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        findButton.titleLabel?.adjustsFontSizeToFitWidth = true
        findButton.titleLabel?.lineBreakMode = .byTruncatingTail
        findButton.setTitleColor(.white, for: .normal)
    
        //Shadow
        findButton.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20).cgColor
        findButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        findButton.layer.shadowOpacity = 1.0
        findButton.layer.shadowRadius = 0.0
        findButton.layer.masksToBounds = false
        
        findButton.addTarget(self, action: #selector(findButtonPressed(_:)), for: .touchUpInside)
        
        let width = 240.0
        let height = 50.0
        NSLayoutConstraint.activate([
            findButton.widthAnchor.constraint(equalToConstant: width),
            findButton.heightAnchor.constraint(equalToConstant: height),
            findButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 45)
        ])
    }
}

extension SCHomeVC: SCHomeDelegate {
    func updateFilter(filter: SCGPTPromptFilter) {
        self.filter = filter
        print(self.filter)
    }
}
