//
//  Double.swift
//  Barrel
//
//  Created by Jae Lee on 7/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func convertDegreeToDirection() -> String {
        let windDegreesInDegrees = self
        var direction = ""
        if windDegreesInDegrees >= 348.75 || windDegreesInDegrees < 11.25 {
            direction = "N"
        }
        if windDegreesInDegrees >= 11.25 && windDegreesInDegrees < 33.75 {
            direction = "NNE"
        }
        if windDegreesInDegrees >= 33.75 && windDegreesInDegrees < 56.25 {
            direction = "NE"
        }
        if windDegreesInDegrees >= 56.25 && windDegreesInDegrees < 78.75 {
            direction = "ENE"
        }
        if windDegreesInDegrees >= 78.75 && windDegreesInDegrees < 101.25 {
            direction = "E"
        }
        if windDegreesInDegrees >= 101.25 && windDegreesInDegrees < 123.75 {
            direction = "ESE"
        }
        if windDegreesInDegrees >= 123.75 && windDegreesInDegrees < 146.25 {
            direction = "SE"
        }
        if windDegreesInDegrees >= 146.25 && windDegreesInDegrees < 168.75 {
            direction = "SSE"
        }
        if windDegreesInDegrees >= 168.75 && windDegreesInDegrees < 191.25 {
            direction = "S"
        }
        if windDegreesInDegrees >= 191.25 && windDegreesInDegrees < 213.75 {
            direction = "SSW"
        }
        if windDegreesInDegrees >= 213.75 && windDegreesInDegrees < 236.25 {
            direction = "SW"
        }
        if windDegreesInDegrees >= 236.25 && windDegreesInDegrees < 258.75 {
            direction = "WSW"
        }
        if windDegreesInDegrees >= 258.75 && windDegreesInDegrees < 281.25 {
            direction = "W"
        }
        if windDegreesInDegrees >= 281.25 && windDegreesInDegrees < 303.75 {
            direction = "WNW"
        }
        if windDegreesInDegrees >= 303.75 && windDegreesInDegrees < 326.25 {
            direction = "NW"
        }
        if windDegreesInDegrees >= 326.25 && windDegreesInDegrees < 348.75 {
            direction = "NNW"
        }
        return direction
    }
    
    
    
    var inFeet:Double {
        return (self * 3.2808)
    }
    
    func convertToRadian() -> Double {
        return self * .pi/180
    }
}





extension Int {
    func convertUnixToDate() -> Date {
        return Date(timeIntervalSince1970: Double(self))
    }
}



extension UIImage {

    func rotate(radians: Float) -> UIImage? {
            let cgImage = self.cgImage!
            let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
            let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
            
            var drawRect = CGRect.zero
            drawRect.size = self.size
            let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
            drawRect.origin = drawOrigin
            var tf = CGAffineTransform.identity
            tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
            tf = tf.rotated(by: CGFloat(radians))
            tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
            context.concatenate(tf)
            context.draw(cgImage, in: drawRect)
            var rotatedImage = context.makeImage()!
            
            drawRect = drawRect.applying(tf)
            
            rotatedImage = rotatedImage.cropping(to: drawRect)!
            let resultImage = UIImage(cgImage: rotatedImage)
            return resultImage
            
            
        
    }
}
