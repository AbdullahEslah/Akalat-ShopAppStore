//
//  GFEmptyStateView.swift
//  Yoogad Business
//
//  Created by Macbook on 5/2/21.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        messageLabel.layer.zPosition = -1
        configure()
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        
        messageLabel.numberOfLines = 3
        if #available(iOS 13.0, *) {
        messageLabel.textColor = .secondaryLabel
        }
        
        logoImageView.image = UIImage(named: "Screen Shot 2021-05-02 at 11.18.12 PM")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50),
//            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 150),
//            //make the image bigger 1.3 times of the screen
////            logoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.1),
////            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.1),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70),
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
//            
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
        
        ])
        
    }
    
}
