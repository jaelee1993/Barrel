//
//  HomeViewModel.swift
//  Barrel
//
//  Created by Jae Lee on 2/9/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel:TagDelegate {
    
    @Published var overview:Overview?
    
    var currentlySelectedTag:Tag?
    var spotTags:[Tag] = []
    
    var subscriptions: Set<AnyCancellable> = []
    
    init() {
        setSpotTags()
    }
    
    
    func setSpotTags() {
        // -------------------------------------------------- */
        let brevardCounty = Tag(tagName: "Brevard County",
                                displayName: "Brevard County",
                                description: "58581a836630e24c44878fe1")
        spotTags.append(brevardCounty)
        // -------------------------------------------------- */
        let volusiaCounty = Tag(tagName: "Volusia County",
                           displayName: "Volusia County",
                           description: "58581a836630e24c44878fe0")
        spotTags.append(volusiaCounty)
        // -------------------------------------------------- */
        let duvalCounty = Tag(tagName: "Duval County",
                           displayName: "Duval County",
                           description: "5e556e9231e571b1a21d34a0")
        spotTags.append(duvalCounty)
        // -------------------------------------------------- */
        let orangeCounty = Tag(tagName: "Orange County",
                               displayName: "Orange County",
                               description: "58581a836630e24c44878fd6")
        spotTags.append(orangeCounty)
        // -------------------------------------------------- */
        let palmBeachCounty = Tag(tagName: "Palm Beach County",
                               displayName: "Palm Beach County",
                               description: "5deecc4b17912b71be2c2e1c")
        spotTags.append(palmBeachCounty)
        // -------------------------------------------------- */
        let browardDateCounty = Tag(tagName: "Broward-Dade County",
                               displayName: "Broward-Dade County",
                               description: "58581a836630e24c4487914c")
        spotTags.append(browardDateCounty)
        // -------------------------------------------------- */
        let portugal = Tag(tagName: "Portugal",
                           displayName: "Portugal",
                           description: "58581a836630e24c4487900f")
        spotTags.append(portugal)
        
        self.currentlySelectedTag = brevardCounty
    }
    
    
    
    public func getData() {
        guard let selectedSubRegion = currentlySelectedTag?.description else {return}
        
        API.getSubRegionOverview(subRegionId: selectedSubRegion)
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (overview) in
                self.overview = overview
            }
            .store(in: &subscriptions)
    }
    
    func tagSelected(_ tag: Tag) {
        if let tagName = tag.tagName {
            NotificationCenter.default.post(name: Notification.Name(TextContent.TagHit.name),
                                                           object: nil,
                                                           userInfo: [TextContent.TagHit.key:tagName] )
            if let currentlySelectedTagName = currentlySelectedTag?.tagName {
                if currentlySelectedTagName == tagName {
                    currentlySelectedTag = nil
                } else {
                    currentlySelectedTag = tag
                }
            } else {
                currentlySelectedTag = tag
            }
        }
        
        getData()
    }
}
