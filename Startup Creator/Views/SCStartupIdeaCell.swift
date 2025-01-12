//
//  SCStartupIdeaCell.swift
//  Startup Creator
//
//  Created by Chris W on 1/5/25.
//

import UIKit

class SCStartupIdeaCell: UICollectionViewCell {
    static let identifier = "SCStartupIdeaCell"
    
    private lazy var lightImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = SCImages.lightbulbYellowImage
        return imgView
    }()
    
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray3
        layer.cornerRadius = 6.0
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(content: String){
        let attrStr = getMarkdownTextFromGPTResponse(content: content, fontSize: 18.0, truncate: true)
        self.titleLabel.attributedText = attrStr
    }
    
    private func configure(){
        configureImage()
        configureLabel()
    }
    
    private func configureLabel(){
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: lightImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func configureImage(){
        contentView.addSubview(lightImageView)
        let width = 44.0
        let height = 44.0
        NSLayoutConstraint.activate([
            lightImageView.widthAnchor.constraint(equalToConstant: width),
            lightImageView.heightAnchor.constraint(equalToConstant: height),
            lightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lightImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])
    }
}
