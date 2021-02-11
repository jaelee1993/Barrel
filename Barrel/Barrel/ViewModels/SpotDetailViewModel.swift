//
//  SpotDetailViewModel.swift
//  Barrel
//
//  Created by Jae Lee on 2/10/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import Foundation
import Combine

class SpotDetailViewModel:ForcastDataDelegate {
    var currentSelectedDate:String = DateService.convertDate(Date(), format: DateService.F3)
    
    var segments:[String] = [DateService.convertDate(Date(), format: DateService.F3),
                    DateService.convertDate(DateService.getDateFor(days: 1)!, format: DateService.F3),
                    DateService.convertDate(DateService.getDateFor(days: 2)!, format: DateService.F3),
                    DateService.convertDate(DateService.getDateFor(days: 3)!, format: DateService.F3),
                    DateService.convertDate(DateService.getDateFor(days: 4)!, format: DateService.F3),
                    DateService.convertDate(DateService.getDateFor(days: 5)!, format: DateService.F3),]
    
    @Published var tideOverview:Overview?
    @Published var windOverview:Overview?
    @Published var waveOverview:Overview?
    @Published var spot:Spot?
    
    var subscriptions:Set<AnyCancellable> = []
    
    init(spot:Spot) {
        self.spot = spot
    }
    
    public func getData() {
        guard let id = spot?._id else {return}
        getTides(id)
        getWind(id)
        getWave(id)
    }
    
    fileprivate func getTides(_ id: String) {
        API.getSpotElements(oceanElement: .tides,
                            spotId: id,
                            parameter: ElementParameter(spotId: id, days: 6, intervalHours: 1, accesstoken: AppCredentials.accesstoken))
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (overview) in
                self.tideOverview = overview
            }.store(in: &subscriptions)
    }
    
    fileprivate func getWind(_ id: String) {
        API.getSpotElements(oceanElement: .wind,
                            spotId: id,
                            parameter: ElementParameter(spotId: id, days: 6, intervalHours: 3, accesstoken: AppCredentials.accesstoken))
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (overview) in
                self.windOverview = overview
            }.store(in: &subscriptions)
    }
    
    fileprivate func getWave(_ id: String) {
        API.getSpotElements(oceanElement: .wave,
                            spotId: id,
                            parameter: ElementParameter(spotId: id, days: 6, intervalHours: 3, accesstoken: AppCredentials.accesstoken))
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (overview) in
                self.waveOverview = overview
            }.store(in: &subscriptions)
    }
    
    
    func getStatistics() -> [Statistic]{
        var statistics = [Statistic]()
        if let conditions = spot?.conditions?.value {
            statistics.append(Statistic(title: "Conditions", body: conditions.getDisplayCondition(), bodyBackgroundColor:conditions.getColorForCondition()))
        }
        if let windSpeed = spot?.wind?.speed {
            statistics.append(Statistic(title: "Wind Speed", body: "\(windSpeed)mph"))
        }
        if let windInDegrees = spot?.wind?.direction {
            statistics.append(Statistic(title: "Wind Direction", body: windInDegrees.convertDegreeToDirection()+"(\(windInDegrees))"))
        }
        return statistics
    }
}
