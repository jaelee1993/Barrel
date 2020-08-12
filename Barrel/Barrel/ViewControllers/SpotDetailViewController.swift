//
//  SpotDetailViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {
    var tableView:UITableView!
    
    var videoSection:Int = 0
    var statSection:Int = 1
    var tideSection:Int = 2
    var windSection:Int = 3
    var sections:[Int] = []
    
    
    var spot:Spot!
    var tideOverview:Overview?
    var windOverview:Overview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hetro_white
        
        setup()

        
    }
    fileprivate func setup() {
        setupTitle()
        setupTableView()
        getData()
    }
    fileprivate func setupTitle() {
        if let name = spot.name {
            self.title = name
        }
    }
    
    fileprivate func setupTableView() {
        sections = [videoSection, statSection, tideSection, windSection]
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.register(VideoTableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(VideoTableViewCell.self))
        tableView.register(ThreeColumnForStatsTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(ThreeColumnForStatsTableViewCell.self))
        tableView.register(TwoColumnForStatsTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TwoColumnForStatsTableViewCell.self))
        tableView.register(TideTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TideTableViewCell.self))
        tableView.register(TitleTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(TitleTableViewCell.self))
        tableView.register(WindTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(WindTableViewCell.self))
        
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func getStatistics() -> [Statistic]{
        var statistics = [Statistic]()
        if let conditions = spot.conditions?.value {
            statistics.append(Statistic(title: "Conditions", body: conditions))
        }
        if let windSpeed = spot.wind?.speed {
            statistics.append(Statistic(title: "Wind Speed", body: "\(windSpeed)mph"))
        }
        if let windInDegrees = spot.wind?.direction {
            statistics.append(Statistic(title: "Wind Direction", body: windInDegrees.convertDegreeToDirection()+"(\(windInDegrees))"))
        }
        return statistics
    }
    
    func getData() {
        guard let id = spot._id else {return}
    
        let accesstoken = "7016ca1cb16e8882d347c3b26df30d5ca80f60d3"
        
        getTides(id, accesstoken)
        getWind(id, accesstoken)
    }
    
    
    fileprivate func getTides(_ id: String, _ accesstoken: String) {
        API.getSpotElements(oceanElement: .tides,
                            spotId: id,
                            parameter: ElementParameter(spotId: id, days: 2, intervalHours: 1, accesstoken: accesstoken)) { (response) in
                                if let response = response {
                                    self.tideOverview = response
                                    self.updateTableView()
                                }
        }
    }
    fileprivate func getWind(_ id: String, _ accesstoken: String) {
        API.getSpotElements(oceanElement: .wind,
                            spotId: id,
                            parameter: ElementParameter(spotId: id, days: 1, intervalHours: 3, accesstoken: accesstoken)) { (response) in
                                if let response = response {
                                    self.windOverview = response
                                    self.updateTableView()
                                }
        }
    }
    
    
}


extension SpotDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
        case videoSection:
            return 2
        case statSection:
            return 1
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
        case videoSection:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(VideoTableViewCell.self), for: indexPath) as! VideoTableViewCell
                cell.parentViewController = self
                cell.removeSeparator()
                if let firstCamera = spot.cameras?.first, let streamUrl = firstCamera.streamUrl  {
                    cell.configure(urlString: streamUrl, parentViewController: self)
                    cell.removeSeparator()
                } else {
                    cell.removeSeparator()
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath) as! UITableViewCell
                cell.removeSeparator()
                return cell
            }
        case statSection:
            let stats = getStatistics()
            if stats.count <= 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ThreeColumnForStatsTableViewCell.self), for: indexPath) as! XColumnStatsTableViewCell
                cell.configure( stats )
                cell.removeSeparator()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TwoColumnForStatsTableViewCell.self), for: indexPath) as! XColumnStatsTableViewCell
                cell.configure( stats )
                cell.removeSeparator()
                return cell
            }
            
        case tideSection:
            if indexPath.row == 0 {
                let cell = getTitleCell(tableView, indexPath, title: "Tide (ft)")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TideTableViewCell.self), for: indexPath) as! TideTableViewCell
                if let tides = tideOverview?.data?.tides {
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
                if let wind = windOverview?.data?.wind {
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
        case videoSection:
            if let _ = spot.cameras?.first {
                if indexPath.row == 0 {
                    return UITableView.automaticDimension
                } else {
                    return 10
                }
            } else {
                return 0
            }
            
        case statSection:
            let stats = getStatistics()
            if stats.count <= 2 {
                return 60
            } else {
                return 110
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
