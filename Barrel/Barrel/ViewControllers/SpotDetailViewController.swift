//
//  SpotDetailViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit
import Combine


class SpotDetailViewController: UIViewController {
    var tableView:          UITableView!
    var segmentedControl:   UISegmentedControl_Underline!
    
    var videoSection:       Int = 0
    var statSection:        Int = 1
    var segmentSection:     Int = 2
    var sections:           [Int] = []
    
    var viewModel:          SpotDetailViewModel?
    
    var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hetro_white
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setup() {
        setupSegmentedControl()
        setupTableView()
        setupObservers()
        setupBindings()
        getData()
    }
    
    fileprivate func setupSegmentedControl() {
        
        segmentedControl = UISegmentedControl_Underline(items: viewModel?.segments ?? [])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.textColor = UIColor.hetro_black
        segmentedControl.addTarget(self, action: #selector(self.segmentAction(_:)), for: .valueChanged)
        segmentedControl.underlineColor = UIColor.oceanBlue
        
    }
    @objc func segmentAction(_ sender:UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        NotificationCenter.default.post(name: NSNotification.Name(TextContent.SurfDataSegmentHit.name), object: nil, userInfo: [TextContent.SurfDataCarouselScrolled.indexKey:index])
        
//        NotificationCenter.default.publisher(for: <#T##Notification.Name#>)
    }
    
    fileprivate func setupTableView() {
        sections = [videoSection, segmentSection, statSection]
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.register(VideoTableViewCell.self,                     forCellReuseIdentifier: NSStringFromClass(VideoTableViewCell.self))
        tableView.register(ThreeColumnForStatsTableViewCell.self,       forCellReuseIdentifier: NSStringFromClass(ThreeColumnForStatsTableViewCell.self))
        tableView.register(TwoColumnForStatsTableViewCell.self,         forCellReuseIdentifier: NSStringFromClass(TwoColumnForStatsTableViewCell.self))
        tableView.register(TideTableViewCell.self,                      forCellReuseIdentifier: NSStringFromClass(TideTableViewCell.self))
        tableView.register(TitleTableViewCell.self,                     forCellReuseIdentifier: NSStringFromClass(TitleTableViewCell.self))
        tableView.register(WindTableViewCell.self,                      forCellReuseIdentifier: NSStringFromClass(WindTableViewCell.self))
        tableView.register(ForcastDataTableViewCell.self,               forCellReuseIdentifier: NSStringFromClass(ForcastDataTableViewCell.self))
        
        
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changeSegment(notification:)),
                                               name: Notification.Name(TextContent.SurfDataCarouselScrolled.name),
                                               object: nil)
    }
    
    @objc func changeSegment(notification: NSNotification) {
        if let index = notification.userInfo?[TextContent.SurfDataCarouselScrolled.indexKey] as? Int {
            segmentedControl.selectedSegmentIndex = index
        }
        
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
   
    
    
    
}

extension SpotDetailViewController {
    func setupBindings() {
        guard let viewModel = viewModel else {return}
        
        viewModel.$spot.sink(receiveValue: { [unowned self] (spot) in
            self.title = spot?.name ?? ""
        }).store(in: &subscribers)
        
        
        viewModel.$tideOverview.combineLatest(viewModel.$waveOverview, viewModel.$windOverview)
            .receive(on: DispatchQueue.main)
            .sink { (response) in
            print(response)
        } receiveValue: { [unowned self] (value) in
            self.tableView.reloadData()
        }.store(in: &subscribers)
        
        
    }
    
    func getData() {
        viewModel?.getData()
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
        case segmentSection:
            return 1
        case statSection:
            return 1
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
                if let firstCamera = viewModel?.spot?.cameras?.first, let streamUrl = firstCamera.streamUrl  {
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
        case segmentSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ForcastDataTableViewCell.self), for: indexPath) as! ForcastDataTableViewCell
            cell.carouselForcastDataView.dataSource = viewModel
            return cell
        case statSection:
            let stats = viewModel?.getStatistics() ?? []
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case videoSection:
            if let _ = viewModel?.spot?.cameras?.first {
                if indexPath.row == 0 {
                    return UITableView.automaticDimension
                } else {
                    return 10
                }
            } else {
                return 0
            }
            
        case segmentSection:
            return 700
        case statSection:
            let stats = viewModel?.getStatistics() ?? []
            if stats.count <= 2 {
                return 60
            } else {
                return 110
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case videoSection:
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        case statSection:
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        case segmentSection:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = .clear
            view.addSubview(segmentedControl)
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            return view
        default:
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case videoSection:
            return 0
        case statSection:
            return 0
        case segmentSection:
            return 40
        
        default:
            return 0
        }
    }
}
