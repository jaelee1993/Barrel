//
//  UISegmentedControl_Underline.swift
//  PagingNavigation
//
//  Created by Jae Lee on 2/6/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit


class UISegmentedControl_Underline: UIControl {
    private var stackView:                          UIStackView!
    private var stackViewWidth:                     NSLayoutConstraint!
    private var underline:                          UIView!
    private var underlineLeading:                   NSLayoutConstraint!
    private var underlineWidthConstraint:           NSLayoutConstraint!
    private var underlineWidth:                     CGFloat = 60
    private var buttons:                            [UIButton] = []
    
    public var items:                               [Any]?
    public var selectedSegmentIndex:                Int = 1 {
        didSet {
            self.animateUnderline(segment:self.selectedSegmentIndex)
        }
    }
    
    public var underlineColor:                      UIColor = .black {
        didSet {
            underline.backgroundColor = underlineColor
        }
    }
    public var textColor:                           UIColor = .black {
        didSet {
            for button in buttons {
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    public var textFont:                            UIFont = UIFont.systemFont(ofSize: 12, weight: .regular) {
        didSet {
            for button in buttons {
                button.titleLabel?.font = textFont
            }
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    public init(items: [Any]?) {
        super.init(frame: CGRect())
        self.items = items
        setup()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let items = items {
            underlineWidth = stackView.frame.width/CGFloat(items.count)
            underlineWidthConstraint.constant = underlineWidth
            animateUnderline(index: selectedSegmentIndex)
        }
    }
    fileprivate func setup() {
        setupHorizontalStack()
        setupUnderline()
        
    }
     
     
    fileprivate func setupHorizontalStack() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
    
        guard let items = items else {return}
        var i = 0
        for item in items {
            if let title = item as? String {
                let button = UIButton()
                button.tag = i
                button.setTitle(title, for: .normal)
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
                button.addTarget(self, action: #selector(navigationButtonIsHit(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                
                buttons.append(button)
                i+=1
                
            }
            
        }
    }
     
     
     
    
    fileprivate func setupUnderline() {
        underline = UIView(frame: CGRect())
        underline.backgroundColor = underlineColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(underline)
        
        underlineWidthConstraint = underline.widthAnchor.constraint(equalToConstant: underlineWidth)
        underlineLeading = underline.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
    
        NSLayoutConstraint.activate([
            underline.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            underlineLeading,
            underlineWidthConstraint,
            underline.heightAnchor.constraint(equalToConstant: 3)
        ])
        
    
    }
  
    fileprivate func animateUnderline(index:Int) {
        guard let items = items else {return}
        guard index <= items.count - 1 else {return}
        
        UIView.animate(withDuration: 0.01, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.underlineLeading.constant = self.underlineWidth * CGFloat(index)
            self.layoutIfNeeded()
            
        }) { (_) in }
    }
    fileprivate func animateUnderline(_ sender:UIButton) {
        guard let items = items else {return}
        guard sender.tag <= items.count - 1 else {return}
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.underlineLeading.constant = self.underlineWidth * CGFloat(sender.tag)
            self.layoutIfNeeded()
            
        }) { (_) in }
    }
    fileprivate func animateUnderline(segment:Int) {
        guard let items = items else {return}
        guard segment <= items.count - 1 else {return}
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.underlineLeading.constant = self.underlineWidth * CGFloat(segment)
            self.layoutIfNeeded()
            
        }) { (_) in }
    }
    
    @objc func navigationButtonIsHit(_ sender:UIButton) {
        selectedSegmentIndex = sender.tag
        animateUnderline(sender)
        sendActions(for: .valueChanged)
    }
    
    
}
