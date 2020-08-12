//
//  LineGraphView.swift
//  Barrel
//
//  Created by Jae Lee on 7/25/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct LineGraphViewConstants {
    static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
    static let margin: CGFloat = 0.0
    static let topBorder: CGFloat = 5
    static let bottomBorder: CGFloat = 5
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 2.0
    static let lineWidth:CGFloat = 1.5
}

struct LineGraphViewPoint {
    var point:CGPoint
    var value:Double?
    var date:Date?
    var other:[String:Any]? = [:]
    var formattedDate:String {
        get {
            guard let date = self.date else {return "Date not available"}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    var formattedQuarterlyDate:String {
        get {
            guard let date = self.date else {return "Date not available"}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    static let samplePoints = [LineGraphViewPoint(point: CGPoint(), value: 0, date: Date(), other: nil),
                               LineGraphViewPoint(point: CGPoint(), value: 0, date: Date(), other: nil),
                               LineGraphViewPoint(point: CGPoint(), value: 0, date: Date(), other: nil),
                               LineGraphViewPoint(point: CGPoint(), value: 0, date: Date(), other: nil),
                               LineGraphViewPoint(point: CGPoint(), value: 0, date: Date(), other: nil),]
    mutating func appendToOther(for key:String, value:Any) {
        self.other?[key] = value
    }
}

protocol LineGraphViewDelegate {
    func graphViewIsSet(_ graphViewPoint:LineGraphViewPoint)
    func graphViewIsFinishedScrolling()
}

class LineGraphView: UIView {
    // point object needed to draw graph
    var graphViewPointBank:[LineGraphViewPoint] = []
    
    // location line shape layer
    private var shapeLayer:CAShapeLayer?
    
    // point of last line drawn
    private var lastHitPoint:CGPoint?
    
    // gradient switch
    private var gradientOn:Bool = false
    
    private var pointLabel:UILabel!
    private let pointLabelWidth:CGFloat = 65
    private var pointLabelLeadingConstraint:NSLayoutConstraint!
    
    // custom data
    private var customMaximumValue:Double?
    
    // colors
    var startColor:UIColor      = UIColor.hetro_white.withAlphaComponent(0)
    var endColor:UIColor        = UIColor.hetro_white.withAlphaComponent(0)
    var fillColor:UIColor       = UIColor.blue
    var strokeColor:UIColor     = UIColor.blue
    var locationLineColor:UIColor    = UIColor.oceanBlue
    
    // delegate
    var delegate: LineGraphViewDelegate?
    
    // label
    var customLabelPreffix:String = "ft"
    
    //closures
    var columnXPoint: ((Int) -> CGFloat)!
    var columnYPoint: ((Double) -> CGFloat)!
    
    
    init(frame:CGRect, fillColor:UIColor = .hetro_black, strokeColor:UIColor = .hetro_black, graphPoints:[(Double,Date)]) {
        super.init(frame: frame)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.graphViewPointBank = convertToGraphViewPoints(points: graphPoints)
        setupPointLabel(frame: frame)
    }
    
    init(frame:CGRect, fillColor:UIColor = .hetro_black, strokeColor:UIColor = .hetro_black, graphPoints:[LineGraphViewPoint]) {
        super.init(frame: frame)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.graphViewPointBank = graphPoints
        setupPointLabel(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPointLabel(frame:CGRect) {
        pointLabel = UILabel()
        pointLabel.textAlignment = .center
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        pointLabel.textColor = locationLineColor
        pointLabel.isHidden = true
        addSubview(pointLabel)
        
        pointLabelLeadingConstraint = pointLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width/2 - pointLabelWidth/2)
        NSLayoutConstraint.activate([
            pointLabel.widthAnchor.constraint(equalToConstant: pointLabelWidth),
            pointLabel.heightAnchor.constraint(equalToConstant: 25),
            pointLabel.bottomAnchor.constraint(equalTo: topAnchor),
            pointLabelLeadingConstraint
        ])
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: LineGraphViewConstants.cornerRadiusSize)
        path.addClip()
        
        // 2
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        //calculate the x point
        let margin = LineGraphViewConstants.margin
        let graphWidth = width - margin * 2 - 4
        
        columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphViewPointBank.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // calculate the y point
        let topBorder = LineGraphViewConstants.topBorder
        let bottomBorder = LineGraphViewConstants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue:Double = customMaximumValue == nil ? 100 : customMaximumValue!
        
        
        columnYPoint = { (graphPoint: Double) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        // draw the line graph
        
        fillColor.setFill()
        strokeColor.setStroke()
        
        // set up the points line
        let graphPath = UIBezierPath()
        
        // set width of line
        graphPath.lineWidth = 1
        
        graphPath.lineJoinStyle = .round
        
        // go to start of line
        guard let value = graphViewPointBank[0].value else {return}
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(value)))
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphViewPointBank.count {
            guard let value = graphViewPointBank[i].value else {return}
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(value))
            graphPath.addLine(to: nextPoint)
        }
        graphPath.stroke()
        
        
        //1 - save the state of the context
        context.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphViewPointBank.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        
        
        drawGradientBelowLine(columnYPoint, maxValue, margin, colorSpace, colorLocations, context, gradient, graphPath)
        
        
        setGraphViewPoints(columnXPoint, columnYPoint)
        
        drawHorizontalLines(margin, topBorder, width, graphHeight, height, bottomBorder)
        
        setDraggableHoldGesture()

    }
    
    fileprivate func drawGradientBelowLine(_ columnYPoint: (Double) -> CGFloat, _ maxValue: Double, _ margin: CGFloat, _ colorSpace: CGColorSpace, _ colorLocations: [CGFloat], _ context: CGContext, _ gradient: CGGradient, _ graphPath: UIBezierPath) {
        //5 - check clipping path - temporary code
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        //Custom color gradient color
        let belowLineColor = [strokeColor.withAlphaComponent(0.2).cgColor, strokeColor.withAlphaComponent(0.01).cgColor]
        
        // let belowLineGradient = ...
        let belowLineGradient = CGGradient(colorsSpace: colorSpace,
                                           colors: belowLineColor as CFArray,
                                           locations: colorLocations)!
        if gradientOn {
            context.drawLinearGradient(belowLineGradient, start: graphStartPoint, end: graphEndPoint, options: [])
        } else {
            context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        }
        context.restoreGState()
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = LineGraphViewConstants.lineWidth
        graphPath.stroke()
    }
    

    
    fileprivate func drawGraphPoints(_ columnXPoint: (Int) -> CGFloat, _ columnYPoint: (Double) -> CGFloat) {
        // draw points
        for i in 0..<graphViewPointBank.count {
            guard let value = graphViewPointBank[i].value else {return}
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(value))
            point.x -= LineGraphViewConstants.circleDiameter / 2
            point.y -= LineGraphViewConstants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: LineGraphViewConstants.circleDiameter, height: LineGraphViewConstants.circleDiameter)))
            circle.fill()
        }
    }
    
    
    fileprivate func setGraphViewPoints(_ columnXPoint: (Int) -> CGFloat, _ columnYPoint: (Double) -> CGFloat) {
        
        for i in 0..<graphViewPointBank.count {
            guard let value = graphViewPointBank[i].value else {continue}
            let point = CGPoint(x: columnXPoint(i), y: columnYPoint(value))
            graphViewPointBank[i].point = point
        }
        
        graphViewPointBank.sort {$0.point.x < $1.point.x} // important for Binaray search when location line is drawn
    }
    
    
    fileprivate func convertToGraphViewPoints(points:[(Double,Date)]) -> [LineGraphViewPoint] {
        var graphViewPoints:[LineGraphViewPoint] = []
        for point in points {
            graphViewPoints.append(LineGraphViewPoint(point: CGPoint(), value: point.0, date: point.1, other: nil))
        }
        return graphViewPoints
    }
    
    
    
    fileprivate func drawHorizontalLines(_ margin: CGFloat, _ topBorder: CGFloat, _ width: CGFloat, _ graphHeight: CGFloat, _ height: CGFloat, _ bottomBorder: CGFloat) {
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
//        linePath.move(to: CGPoint(x: margin, y: topBorder))
//        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
//        linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
//        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        
        let color = UIColor.hetro_black.withAlphaComponent(LineGraphViewConstants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.setLineDash([4.0,8.0], count: 2, phase: 0.0)
        linePath.lineCapStyle = .butt
        linePath.stroke()
        
    }
    

}

//MARK: - Public functions
extension LineGraphView {
    public func resetGraphPoints(graphPoints:[(Double,Date)],customMaximumValue:Double? = nil) {
        self.customMaximumValue = customMaximumValue
        self.graphViewPointBank = convertToGraphViewPoints(points: graphPoints)
        setNeedsDisplay()
    }
    public func resetGraphPoints(graphViewPoints:[LineGraphViewPoint],customMaximumValue:Double? = nil) {
        self.customMaximumValue = customMaximumValue
        self.graphViewPointBank = graphViewPoints
        setNeedsDisplay()
    }
    public func setCustomMaximumValue(value:Double) {
        self.customMaximumValue = value
    }
    
}

//MARK: - Graph Dragging
extension LineGraphView {
    fileprivate func setDraggableHoldGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressIsDragging(_:)))
        longGesture.minimumPressDuration = 0.3
        addGestureRecognizer(longGesture)
    }
    
    @objc fileprivate func longPressIsDragging(_ sender:UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let target = sender.location(in: self).x
            drawDragLocationLine(findClosest(graphViewPoints: self.graphViewPointBank, target: target))
            
        case .ended:
            shapeLayer?.path = nil
            pointLabel.isHidden = true
            delegate?.graphViewIsFinishedScrolling()
            setNeedsDisplay()
        default:
            print("")
        }
    }
    
    private func drawDragLocationLine(_ graphViewPoint:LineGraphViewPoint) {
        guard graphViewPoint.point != lastHitPoint else {return} // check to see if point is being repeated
    
        //intialize if have not
        if shapeLayer == nil {
            shapeLayer = CAShapeLayer()
            shapeLayer?.strokeColor = locationLineColor.cgColor
            shapeLayer?.lineWidth = 1
            layer.addSublayer(shapeLayer!)
        }
        
        let dragLocationLinePath = UIBezierPath()
        dragLocationLinePath.move(to: CGPoint(x: graphViewPoint.point.x, y: LineGraphViewConstants.topBorder))
        dragLocationLinePath.addLine(to: CGPoint(x: graphViewPoint.point.x, y: bounds.maxY - LineGraphViewConstants.bottomBorder))
        
        // generate feed back
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
        
        // set new path
        shapeLayer?.path = dragLocationLinePath.cgPath
        
        // setting label and its position
        setLabel(graphViewPoint)
        
        // call delegate
        delegate?.graphViewIsSet(graphViewPoint)
        
        //update last hit point
        lastHitPoint = graphViewPoint.point
        setNeedsDisplay()
        
    }
    
    fileprivate func setLabel(_ graphViewPoint: LineGraphViewPoint) {
        pointLabel.textColor = locationLineColor
        let halfWidth = pointLabelWidth/2
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.pointLabel.isHidden = false
            if let value = graphViewPoint.value {
                self.pointLabel.text = String(format: "%.2f", value) + " " + self.customLabelPreffix
            }
            if graphViewPoint.point.x < halfWidth || graphViewPoint.point.x > self.bounds.width - halfWidth {
                if graphViewPoint.point.x < halfWidth {
                    self.pointLabelLeadingConstraint.constant = 0
                }
                if graphViewPoint.point.x > self.bounds.width - halfWidth {
                    self.pointLabelLeadingConstraint.constant = self.bounds.width - self.pointLabelWidth
                }
            } else {
                self.pointLabelLeadingConstraint.constant = graphViewPoint.point.x - halfWidth
            }
        }) { (_) in }
    }
    
    private func findClosest(graphViewPoints:[LineGraphViewPoint], target:CGFloat) -> LineGraphViewPoint {
        // Corner cases
        let count = graphViewPoints.count
        if (target <= graphViewPoints[0].point.x) {
            return graphViewPoints[0]
        }
        if (target >= graphViewPoints[count - 1].point.x) {
            return graphViewPoints[count - 1];
        }

        // Doing binary search
        var i = 0
        var j = count
        var mid = 0
        while (i < j) {
            mid = (i + j) / 2

            if (graphViewPoints[mid].point.x == target) {
                return graphViewPoints[mid]
            }
            /* If target is less than array element,
                then search in left */
            if (target < graphViewPoints[mid].point.x) {

                // If target is greater than previous
                // to mid, return closest of two
                if (mid > 0 && target > graphViewPoints[mid - 1].point.x) {
                    return getClosest(val1: graphViewPoints[mid - 1], val2: graphViewPoints[mid], target: target)
                }

                /* Repeat for left half */
                j = mid;
            }

            // If target is greater than mid
            else {
                if (mid < count - 1 && target < graphViewPoints[mid + 1].point.x) {
                    return getClosest(val1: graphViewPoints[mid], val2: graphViewPoints[mid + 1], target: target)
                }
                    // update i
                i = mid + 1
            }
        }

        // Only single element left after search
        return graphViewPoints[mid]
    }
    
    // Method to compare which one is the more close.
    // We find the closest by taking the difference
    // between the target and both values. It assumes
    // that val2 is greater than val1 and target lies
    // between these two.
    private func getClosest(val1:LineGraphViewPoint, val2:LineGraphViewPoint, target:CGFloat) -> LineGraphViewPoint {
        if (target - val1.point.x >= val2.point.x - target) {
            return val2
        }
        else {
            return val1
        }
        
    }
}




extension LineGraphView {
   
}
