//
//  SCSavedStartupIdeaVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/7/25.
//

import UIKit

//View that presents an already saved idea
class SCSavedStartupIdeaVC: UIViewController {
    private var idea: Idea!
    private var contentView = UIView()
    private var contentTextView = UITextView()
    
    private var scaleButton = UIButton(type: .system)
    private var entryButton = UIButton(type: .system)
    
    init(idea: Idea) {
        self.idea = idea
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureContentView()
        configureButtons()
        configureContentTextView()
    }
    
    @objc func deleteButtonPressed(){
        print("pressed")
    }
    
    private func configureViewController(){
        view.backgroundColor = SCColors.background
        title = "Idea"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc func scaleButtonPressed(){
        let contentCleaned = parseMarkdownToPlainText(markdown: idea.content!) ?? ""
        let scalePrompt = SCPrompt.createIdeaScalePrompt(content: contentCleaned, maxTokens: SCNetworkManager.shared.maxTokens)
        print(scalePrompt)
        
        SCNetworkManager.shared.makeRequest(prompt: scalePrompt) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        let content = getSCGPTResponseMessage(response: response) ?? ""
                        let ideaQuestionVC = SCIdeaQuestionVC(title: "How to Scale?", content: content)
                        self.present(ideaQuestionVC, animated: true)
                    }
                
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue)
            }
        }
       
    }
    
    @objc func entryButtonPressed(){
        let contentCleaned = parseMarkdownToPlainText(markdown: idea.content!) ?? ""
        let entryPrompt = SCPrompt.createIdeaEntryPrompt(content: contentCleaned, maxTokens: SCNetworkManager.shared.maxTokens)
        print(entryPrompt)
        
        SCNetworkManager.shared.makeRequest(prompt: entryPrompt) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        let content = getSCGPTResponseMessage(response: response) ?? ""
                        let ideaQuestionVC = SCIdeaQuestionVC(title: "Entry Difficulty", content: content)
                        self.present(ideaQuestionVC, animated: true)
                    }
                
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue)
            }
        }
    }
    
    private func configureButtons(){
        configureButton(scaleButton, text: "How to scale?")
        configureButton(entryButton, text: "Is entry difficult?")
        
        scaleButton.addTarget(self, action: #selector(scaleButtonPressed), for: .touchUpInside)
        entryButton.addTarget(self, action: #selector(entryButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scaleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scaleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            entryButton.bottomAnchor.constraint(equalTo: scaleButton.bottomAnchor),
            entryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureButton(_ button: UIButton, text: String){
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = SCColors.symbol
        button.layer.cornerRadius = 8.0
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        //button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(.white, for: .normal)
        
        let width = 110.0
        let height = 60.0
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func configureContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 8.0
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                if self.traitCollection.userInterfaceStyle == .light {
                    self.contentView.layer.borderColor = UIColor.black.cgColor
                } else {
                    self.contentView.layer.borderColor = UIColor.white.cgColor
                }
            })
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureContentTextView() {
        contentView.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.backgroundColor = .clear
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.borderColor = UIColor.label.cgColor
        contentTextView.layer.cornerRadius = 4.0
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
    
        contentTextView.attributedText = getMarkdownTextFromGPTResponse(content: self.idea.content!, fontSize: 19.0)
        contentTextView.isScrollEnabled = true
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                if self.traitCollection.userInterfaceStyle == .light {
                    self.contentTextView.layer.borderColor = UIColor.black.cgColor
                } else {
                    self.contentTextView.layer.borderColor = UIColor.white.cgColor
                }
            })
        }
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentTextView.bottomAnchor.constraint(equalTo: scaleButton.topAnchor, constant: -20)
        ])
    }
}
