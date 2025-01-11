//
//  SCIdeaQuestionVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/10/25.
//

import UIKit

//View displays a response from the question buttons (ex. How to scale? on the saved idea view
class SCIdeaQuestionVC: UIViewController {
    private var contentTextView = UITextView()
    private var titleLabel = UILabel()
    private var dismissButton = UIButton()
    private var viewTitle: String!
    private var content: String!
    
    init(title: String, content: String){
        self.viewTitle = title
        self.content = content
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SCColors.background
        configureDismissButton()
        configureTitleLabel()
        configureContentTextView()
    }
    
    private func configureContentTextView(){
        view.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.backgroundColor = .clear
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        contentTextView.attributedText = getMarkdownTextFromGPTResponse(content: self.content, fontSize: 19.0)
        contentTextView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = self.viewTitle
        titleLabel.tintColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: dismissButton.topAnchor)
        ])
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    private func configureDismissButton(){
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(SCImages.xImage, for: .normal)
        dismissButton.tintColor = SCColors.symbol
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }
}
