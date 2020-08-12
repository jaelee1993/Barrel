//
//  HomeViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var tableView:UITableView!
    
    var overview:Overview?
    
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
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.register(TitleTableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(TitleTableViewCell.self))
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
//        let imageView = UIImageView(image: UIImage(named: "Surf")!)
//        imageView.contentMode = .scaleAspectFill
//        tableView.createParallaxTableViewHeader(view, mainHeaderView: imageView, height: 250)
        
    }
    fileprivate func getData() {
        API.getSubRegionOverview(subRegionId: "58581a836630e24c44878fe1") { (overview) in
            if let overview = overview {
                self.overview = overview
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let spots = overview?.data?.spots {
            return spots.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TitleTableViewCell.self), for: indexPath) as! TitleTableViewCell
        if let spots = overview?.data?.spots {
            let spot = spots[indexPath.row]
            cell.title.text = spot.name == nil ? "N/A" : spot.name!
            
            
            if let cameras = spot.cameras {
                if cameras.isEmpty {
                    cell.setImageView(image: nil)
                } else {
                    cell.setImageView(image: UIImage(named: "Camera_blue"))
                }
            } else {cell.setImageView(image: nil)}
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let spots = overview?.data?.spots {
            let spot = spots[indexPath.row]
            let vc = SpotDetailViewController()
            vc.spot = spot
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
