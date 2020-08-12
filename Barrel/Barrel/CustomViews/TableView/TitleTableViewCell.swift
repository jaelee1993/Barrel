//
//  TitleTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit


class TitleTableViewCell: UITableViewCell {
    var gradientView:GradientViewVertical!
    var title:UILabel!
    var rowActionButton:UIButton!
    var leftIconImageView:UIImageView!
    var rowActionDelegate:RowActionDelegate?
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupGradientView()
        setupImageView()
        setupTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        gradientView.isHidden = true
    }
    
    fileprivate func setupGradientView() {
        gradientView = GradientViewVertical()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isHidden = true
        contentView.addSubview(gradientView)
        gradientView.constraintsToSuperView(self)
    }
    
    fileprivate func setupTitle() {
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        title.textColor = .hetro_labelColor
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: leftIconImageView.leadingAnchor, constant: -3),
            ])
    }
    
   
    fileprivate func setupImageView() {
        leftIconImageView = UIImageView()
        leftIconImageView.isHidden = true
        leftIconImageView.translatesAutoresizingMaskIntoConstraints = false
        leftIconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(leftIconImageView)
        NSLayoutConstraint.activate([
            leftIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            leftIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            leftIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            leftIconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setGradientColors(colors:[CGColor]) {
        gradientView.isHidden = false
        gradientView.resetGradientColors(colors: colors)
    }
    
    func setImageView(image:UIImage? = nil) {
        leftIconImageView.isHidden = false
        leftIconImageView.image = image
    }
    
}
