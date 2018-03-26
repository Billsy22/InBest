//
//  LineChart.swift
//  LineChart
//
//  Created by Taylor Bills on 3/22/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class LineChart: UIView {
    
    // MARK: -  Instance Properites
    // Create 2 layers to be added one for line one for points. CAShapeLayer basically a "shape"
    let lineLayer = CAShapeLayer()
    let circlesLayer = CAShapeLayer()
    // Create an instance of a CGAffineTransform, which is used to rotate, scale, translate, or skew the objects you draw. In this case it is going to take one point and transform it into anothe rpoint. We take an x point and a y point and combine them to make a point
    var chartTransform: CGAffineTransform?
    
    // MARK: -  Interface Builder Properties
    // We mark these with IBInspectable so we can change them directly in interface builder for example. a "cornerRadius" property would become available in the attributes inspector as "Corner Radius"
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var circleSizeMultiplier: CGFloat = 3
    @IBInspectable var axisColor: UIColor = UIColor.white
    @IBInspectable var showInnerLines: Bool = true
    @IBInspectable var labelFontSize: CGFloat = 10
    @IBInspectable var showPoints: Bool = true {
        didSet {
            circlesLayer.isHidden = !showPoints
        }
    }
    @IBInspectable var circleColor: UIColor = UIColor.green {
        didSet {
            circlesLayer.fillColor = circleColor.cgColor
        }
    }
    @IBInspectable var lineColor: UIColor = UIColor.init(red: 0.573, green: 0.639, blue: 0.569, alpha: 1.0) {
        didSet {
            lineLayer.strokeColor = lineColor.cgColor
        }
    }
    
    // MARK: -  Grid Properties
    var axisLineWidth: CGFloat = 1
    var deltaX: CGFloat = 10 // The change between each tick on the x axis
    var deltaY: CGFloat = 10 // The change between each tick on the y axis
    var xMax: CGFloat = 100
    var yMax: CGFloat = 100
    var xMin: CGFloat = 0
    var yMin: CGFloat = 0
    var data: [CGPoint]? // stuff to be converted to a point on the grid...i think
    
    // MARK: -  Initializers
    // Instantiates the graph in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        combinedInit()
    }
    
    // For when you have dragged a LineChart into the interface builder and connected it with an outlet
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        combinedInit()
    }
    
    // Contains all the code needed for both
    func combinedInit() {
        // Add line layer and set properties
        layer.addSublayer(lineLayer)
        // fill color on a line graph is anything between the start point and end point that is off the exact line.
        lineLayer.fillColor = UIColor.clear.cgColor
        // Stroke color is the actual line from one point to the next point
        lineLayer.strokeColor = lineColor.cgColor
        // Add circle layer and set properties
        layer.addSublayer(circlesLayer)
        circlesLayer.fillColor = circleColor.cgColor
        // Set grid properties
        layer.borderWidth = 1
        layer.borderColor = axisColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the frame of our subviews. This will make them as big as the screen
        lineLayer.frame = bounds
        circlesLayer.frame = bounds
        
        if let data = data {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plot(data)
        }
    }
    
    // MARK: -  Axis set up
    // This one sets our max and min of x and y based on the points we enter. To figure out the highest value we divide it by the delta properties and round up then multiply it by delta
    func setAxisRange(forPoints points: [CGPoint]) {
        guard !points.isEmpty else { return }
        let xs = points.map() { $0.x }
        let ys = points.map() { $0.y }
        xMax = ceil(xs.max()! / deltaX) * deltaX
        yMax = ceil(ys.max()! / deltaY) * deltaY
        xMin = 0
        yMin = 0
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    // This function explicitly lets you set the max and min of the x and y values
    func setAxisRange(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    // This method creates the transform we will use for drawing the axes, points, and lines.
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        // change the label fint size and the actual label size so that the labels don't fall off the screen or out of the view. Changing the size of the label is using the .size extension method we made on the 'String' class earlier.
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        let xOffset = xLabelSize.height + 2
        let yOffset = yLabelSize.width + 5
        // For the scale factos we need to divide the bounds (minus the offsets) by the difference between the max and min of the x and y values respectfully
        let xScale = (bounds.width - yOffset - xLabelSize.width/2 - 2)/(maxX - minX)
        let yScale = (bounds.height - xOffset - yLabelSize.height/2 - 2)/(maxY - minY)
        // Quick lesson on CGAffineTransform...
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: yOffset, ty: bounds.height - xOffset)
        /*
         CGTransform arguments are a, b, c, d, tx, ty
         a: scale x relative to old x | newX = a * oldX
         b: scale x relevate to old x...but for rotation
         c: scale y relative to old y...but for rotation
         d: scale y relative to old y | newY = d * oldY
         tx: translate newX using the scale system of oldX | newX = oldX * a + tx
         ty: ^ but with y
         *** CoreGraphics has the y axis and increasing when moving down so we need to invert the yScale ***
         */
        // Redraws the bounds that are needed for our graph
        setNeedsDisplay()
    }
    
    // MARK: -  Actually Draw the axis we just set up
    // We will use this draw functionbecuase it comes with a drawing context. That way we don't have to make one.
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
            let chartTransform = chartTransform else { return }
        drawAxes(in: context, usingTransform: chartTransform)
    }
    
    // Make a helper method so we can call the drawing function multiple places
    func drawAxes(in context: CGContext, usingTransform transform: CGAffineTransform) {
        context.saveGState()
        // The 2 kinds of lines we need for the axes. Thicker for the border, thinner for grid lines.
        let thickerLines = CGMutablePath()
        let thinnerLines = CGMutablePath()
        // Draw the 2 lines for the axes.
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)]
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)]
        // Add our lines. Similar to adding actions to alerts
        thickerLines.addLines(between: xAxisPoints, transform: transform)
        thickerLines.addLines(between: yAxisPoints, transform: transform)
        // spacing out our thinner lines evenly
        for x in stride(from: xMin, through: xMax, by: deltaX) {
            let tickPoints = showInnerLines ? [CGPoint(x: x, y: yMin).applying(transform), CGPoint(x: x, y: yMax).applying(transform)] : [CGPoint(x: x, y: 0).applying(transform), CGPoint(x: x, y: 0).adding(y: -5)]
            thinnerLines.addLines(between: tickPoints)
            if x != xMin {
                let label = "\(Int(x))" as NSString
                let labelSize = "\(Int(x))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: x, y: 0).applying(transform).adding(x: -labelSize.width/2).adding(y: 1)
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        
        // Repeat for y lines
        for y in stride(from: yMin, to: yMax, by: deltaY) {
            let tickPoints = showInnerLines ?
                [CGPoint(x: xMin, y: y).applying(chartTransform!), CGPoint(x: xMax, y: y).applying(chartTransform!)] :
                [CGPoint(x: 0, y: y).applying(chartTransform!), CGPoint(x: 0, y: y).applying(chartTransform!).adding(x: 5)]
            
            
            thinnerLines.addLines(between: tickPoints)
            
            if y != yMin {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: 0, y: y).applying(chartTransform!)
                    .adding(x: -labelSize.width - 1)
                    .adding(y: -labelSize.height/2)
                
                label.draw(at: labelDrawPoint,
                           withAttributes:
                    [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize),
                     NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        // set the color and size for the thicker lines
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(thickerLines)
        context.strokePath()
        // do the same for the thinner lines
        context.setStrokeColor(axisColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(axisLineWidth/2)
        context.addPath(thinnerLines)
        context.strokePath()
        // whenever you change a graphics context you should save it prior and restore it after
        context.restoreGState()
    }
    
    // MARK: -  Plot methods
    func plot(_ points: [CGPoint]) {
        // first we cleare the data points in the paths
        lineLayer.path = nil
        circlesLayer.path = nil
        data = nil
        
        guard !points.isEmpty else { return }
        self.data = points
        // Make sure we have a transform. If we DO NOT, we determineIt without our setAxisRange method.
        if let chartTransform = self.chartTransform {
            // If we DO have it. we set our line path and our circle path.
            let linePath = CGMutablePath()
            linePath.addLines(between: points, transform: chartTransform)
            lineLayer.path = linePath
            if showPoints {
                circlesLayer.path = circles(atPoints: points, withTransform: chartTransform)
            }
        } else {
            setAxisRange(forPoints: points)
        }
    }
    
    func circles(atPoints points: [CGPoint], withTransform transform: CGAffineTransform) -> CGPath {
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * circleSizeMultiplier
        for i in points {
            let p = i.applying(transform)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
        }
        return path
    }
}
