//
//  SingleForcastDataView.swift
//  Barrel
//
//  Created by Jae Lee on 8/17/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class SingleForcastDataView: UIView {
    var tableView:UITableView!
    
    var surfSection:Int = 0
    var tideSection:Int = 1
    var windSection:Int = 2
    var sections:[Int] = []
    
    var tides:[Tide]?
    var wind:[Wind]?
    var wave:[Wave]?
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setup() {
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        sections = [tideSection, windSection, surfSection]
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.register(ThreeColumnForStatsTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(ThreeColumnForStatsTableViewCell.self))
        tableView.register(TwoColumnForStatsTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TwoColumnForStatsTableViewCell.self))
        tableView.register(TideTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TideTableViewCell.self))
        tableView.register(TitleTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TitleTableViewCell.self))
        tableView.register(WindTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(WindTableViewCell.self))
        tableView.register(SurfTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(SurfTableViewCell.self))
        
        
        tableView.tableFooterView = UIView()
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    public func configure(tides:[Tide], wind:[Wind], wave:[Wave]) {
        self.tides = tides
        self.wind = wind
        self.wave = wave
        self.tableView.reloadData()
    }
}

extension SingleForcastDataView: UITableViewDelegate, UITableViewDataSource {
    fileprivate func getTitleCell(_ tableView: UITableView, _ indexPath: IndexPath, title:String, allowCellIndicator:Bool = false) -> TitleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TitleTableViewCell.self), for: indexPath) as! TitleTableViewCell
        cell.title.text = title
        cell.title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        if allowCellIndicator {
            cell.accessoryType = .disclosureIndicator
        }
        cell.removeSeparator()
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case surfSection:
            return 2
        case tideSection:
            return 2
        case windSection:
            return 2
        default:
            break
        }
        return 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case surfSection:
            if indexPath.row == 0 {
                let cell = getTitleCell(tableView, indexPath, title: "Surf (ft)")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SurfTableViewCell.self), for: indexPath) as! SurfTableViewCell
                if let wave = wave {
                    cell.configure(wave: wave)                    
                }
                cell.removeSeparator()
                return cell
            }
        case tideSection:
            if indexPath.row == 0 {
                let cell = getTitleCell(tableView, indexPath, title: "Tide (ft)")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TideTableViewCell.self), for: indexPath) as! TideTableViewCell
                if let tides = tides {
                    cell.configure(tides: tides)
                }
                
                cell.removeSeparator()
                return cell
            }
        case windSection:
            if indexPath.row == 0 {
                let cell = getTitleCell(tableView, indexPath, title: "Wind (kts)")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(WindTableViewCell.self), for: indexPath) as! WindTableViewCell
                if let wind = wind {
                    cell.configure(wind: wind)
                }
                cell.removeSeparator()
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case surfSection:
            if indexPath.row == 0 {
                return 55
            } else {
                return 120
            }
        case tideSection:
            if indexPath.row == 0 {
                return 55
            } else {
                return 120
            }
        case windSection:
            if indexPath.row == 0 {
                return 55
            } else {
                return 120
            }
        default:
            break
        }
        return 10
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
