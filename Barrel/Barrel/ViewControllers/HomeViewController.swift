//
//  HomeViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    var tableView:                          UITableView!
    var refreshControl:                     UIRefreshControl = UIRefreshControl()
    var customeSplitViewController:         CustomSplitViewController?
    
    var tagSection:             Int = 0
    var spotSection:            Int = 1
    var sections:               [Int] = []
    
    var viewModel =              HomeViewModel()

    var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Spots"
        view.backgroundColor = UIColor.hetro_white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.oceanBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes

        setup()
    }
    
    fileprivate func setup() {
        setupTableView()
        setupBindings()
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
    
}

extension HomeViewController {
    @objc fileprivate func getData() {
        viewModel.getData()
    }
    
    func setupBindings() {
        viewModel.$overview
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (overview) in
                self?.tableView.reloadData()
            }.store(in: &subscribers)
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
            if let spots = viewModel.overview?.data?.spots {
                return spots.count
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == tagSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CarouselTagTableViewCell.self), for: indexPath) as! CarouselTagTableViewCell
            cell.removeSeparator()
            cell.tagDelegate = viewModel
            cell.configure(tags: viewModel.spotTags)
        }
        else if indexPath.section == spotSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SpotTableViewCell.self), for: indexPath) as! SpotTableViewCell
            if let spots = viewModel.overview?.data?.spots {
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
        if indexPath.section == tagSection {
            return 50
        } else {
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == spotSection {
            tableView.deselectRow(at: indexPath, animated: true)
            if let spots = viewModel.overview?.data?.spots {
                let spot = spots[indexPath.row]
                let vc = SpotDetailViewController()
                vc.viewModel = SpotDetailViewModel(spot: spot)
                customeSplitViewController?.showDetailViewController(vc, sender: self)
                
            }            
        }
    }
}

