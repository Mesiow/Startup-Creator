//
//  SCStartupIdeaVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/4/25.
//

import UIKit

//View that is shown from a new network call
class SCStartupIdeaVC: UIViewController {
    
    private let content: String! //the gpt content response we retrieved to display
    private var contentView = UIView()
    private var contentTextView = UITextView()
    
    weak var listDelegate: SCSavedStartupIdeaListDelegate!
    
    init(delegate: SCSavedStartupIdeaListDelegate, content: String) {
        self.listDelegate = delegate
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureContentView()
        configureContentTextView()
    }
    
    @objc func saveButtonPressed(){
        let idea = Idea(context: SCCoreDataManager.context)
        idea.date = Date()
        idea.content = self.content
        
        listDelegate.saveIdeaEntry(idea: idea)
        
        presentAlertOnMainThread(title: "Saved!", message: "Your idea has been saved.")
    }
    
    private func configureViewController(){
        view.backgroundColor = SCColors.background
        title = "Startup Idea"
        navigationController?.navigationBar.prefersLargeTitles = true
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
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
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        
        contentTextView.attributedText = getMarkdownTextFromGPTResponse(content: self.content, fontSize: 19.0)
        contentTextView.isScrollEnabled = true
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
