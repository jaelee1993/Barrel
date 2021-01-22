//
//  HomeViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var tableView:                          UITableView!
    var refreshControl:                     UIRefreshControl = UIRefreshControl()
    var customeSplitViewController:         CustomSplitViewController?
    var overview:                           Overview?
    
    var tagSection:             Int = 0
    var spotSection:            Int = 1
    var sections:               [Int] = []
    
    
    var spotTags:[Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    
    fileprivate func setup() {
        title = "Spots"
        view.backgroundColor = UIColor.hetro_white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.oceanBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        setupTableView()
        getData()
    }
    
    
    
    fileprivate func setupTableView() {
        sections = [tagSection,spotSection]
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.register(TitleTableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(TitleTableViewCell.self))
        tableView.register(SpotTableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(SpotTableViewCell.self))
        tableView.register(CarouselTagTableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(CarouselTagTableViewCell.self))
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setSpotTags() {
        let Nazare = Tag()
        Nazare.displayName = "Nazare"
        Nazare.description = "58581a836630e24c4487900f"
    }
    @objc fileprivate func getData() {
        let nazarePortugal  = "58581a836630e24c4487900f"
        let spaceCoastFL    = "58581a836630e24c44878fe1"
        API.getSubRegionOverview(subRegionId: spaceCoastFL) { (overview) in
            if let overview = overview {
                self.overview = overview
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tagSection {
            return 1
        }
        else if section == spotSection {
            if let spots = overview?.data?.spots {
                return spots.count
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == tagSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CarouselTagTableViewCell.self), for: indexPath) as! CarouselTagTableViewCell
            cell.configure(tags: spotTags)
        }
        else if indexPath.section == spotSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SpotTableViewCell.self), for: indexPath) as! SpotTableViewCell
            if let spots = overview?.data?.spots {
                let spot = spots[indexPath.row]
                cell.title.text = spot.name == nil ? "N/A" : spot.name!
                
                
                if let conditions = spot.conditions?.value {
                    cell.condition.text = conditions.getDisplayCondition()
                    cell.condition.backgroundColor = conditions.getColorForCondition()
                } else {
                    cell.condition.text = "LOLA"
                    cell.condition.backgroundColor = .oceanBlue
                }
                if let max = spot.waveHeight?.max, let min = spot.waveHeight?.min {
                    cell.height.text = "\(Int(min))-\(Int(max))"
                }
                
                if let cameras = spot.cameras {
                    if cameras.isEmpty {
                        cell.setIconImageView(image: nil)
                    } else {
                        cell.setIconImageView(image: UIImage(named: "Camera_blue"))
                    }
                } else {cell.setIconImageView(image: nil)}
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == spotSection {
            tableView.deselectRow(at: indexPath, animated: true)
            if let spots = overview?.data?.spots {
                let spot = spots[indexPath.row]
                let vc = SpotDetailViewController()
                vc.spot = spot
                customeSplitViewController?.showDetailViewController(vc, sender: self)
                
                //            navigationController?.pushViewController(vc, animated: true)
            }            
        }
    }
}
