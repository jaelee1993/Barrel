//
//  Overview.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Overview.self, from: jsonData)

import Foundation

// MARK: - Overview
class Overview: Codable {
    var associated: Associated?
    var data: DataClass?
}

// MARK: - Associated
class Associated: Codable {
    var advertising: Advertising?
    var abbrTimezone: String?
    var utcOffset: Int?
    var units: Units?
    var chartsUrl:String?
    var legacyId: String?
    var tideLocation:Location?

}

//MARK: - Tide Location
class Location:Codable {
    var name:String?
    var min:Double?
    var max:Double?
    var lon:Double?
    var lat:Double?
    var mean:Double?
}

// MARK: - Advertising
class Advertising: Codable {
    var spotId:String?
    var subregionId: String?
}

// MARK: - Units
class Units: Codable {
    var temperature:String?
    var tideHeight:String?
    var swellHeight:String?
    var waveHeight:String?
    var windSpeed:String?

}

// MARK: - DataClass
class DataClass: Codable {
    var _id:String?
    var name:String?
    var primarySpot: String?
    var breadcrumb: [Breadcrumb]?
    var timestamp: Int?
    var forecastSummary: ForecastSummary?
    var spots: [Spot]?
    var tides:[Tide]?
    var wind:[Wind]?
}

// MARK: - Breadcrumb
class Breadcrumb: Codable {
    var name:String?
    var href:String?
}

// MARK: - ForecastSummary
class ForecastSummary: Codable {
    var forecastStatus:ForecastStatus?
    var nextForecastTimestamp:Int?
    var forecaster:Forecaster?
    var highlights:[String]?
    var bestBets:[String]?
    var bets:Bets?
    var hasHighlights:Bool?
    var hasBets:Bool?

}

// MARK: - Bets
class Bets: Codable {
    var best, worst: String?

}

// MARK: - ForecastStatus
class ForecastStatus: Codable {
    var status, inactiveMessage: String?

}

// MARK: - Forecaster
class Forecaster: Codable {
    var name, title: String?
    var iconUrl: String?
}

// MARK: - Spot
class Spot: Codable {
    var _id, name: String?
    var conditions: Conditions?
    var waveHeight: WaveHeight?
    var lat, lon: Double?
    var cameras: [Camera]?
    var rank: Int?
    var wind: Wind?
    var tide: TideTimeline?

}

// MARK: - Camera
class Camera: Codable {
    var _id, title: String?
    var streamUrl: String?
    var stillUrl: String?
    var rewindBaseUrl: String?
    var isPremium, isPrerecorded: Bool?
    var lastPrerecordedClipStartTimeUTC, lastPrerecordedClipEndTimeUTC, alias: String?
    var status: Status?
    var control: String?
    var nighttime: Bool?
    var rewindClip: String?

}

// MARK: - Status
class Status: Codable {
    var isDown: Bool?
    var message, subMessage: String?
    var altMessage: String?
}


// MARK: - Conditions
class Conditions: Codable {
    var human: Bool?
    var value: String?
    var expired: Bool?
    var sortableCondition: Int?

}


// MARK: - Tide
class TideTimeline: Codable {
    var previous, current, next: Tide?

}

// MARK: - Current
class Tide: Codable {
    var type: String?
    var height: Double?
    var timestamp, utcOffset: Int?

}


// MARK: - WaveHeight
class WaveHeight: Codable {
    var human: Bool?
    var min, max: Double?
    var occasional: Double?
    var humanRelation: String?
    var plus: Bool?

}



// MARK: - Wind
class Wind: Codable {
    var speed: Double?
    var direction: Double?
    var timestamp: Int?
    var gust: Double?
    var optimalScore: Double?
}
