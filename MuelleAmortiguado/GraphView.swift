//
//  GraphView.swift
//  MuelleAmortiguado
//
//  Created by g332 DIT UPM on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit


struct Point {
    var x = 0.0
    var y = 0.0
}

protocol GraphViewDataSource : class {
    func startParamOfGraphView(graphView: GraphView) -> Double
    func endParamOfGraphView(graphView : GraphView) -> Double
    func pointOfGraphView(graphView : GraphView, atParam param : Double) -> Point
}

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var axisWidth : Double = 1.0
    
    @IBInspectable
    var graphWidth : Double = 1.0
    
    @IBInspectable
    var axisColor : UIColor = UIColor.whiteColor()
    
    @IBInspectable
    var graphColor : UIColor = UIColor.blackColor()
    
    var horizontalAxis : CGFloat = CGFloat(0.0)
    var verticalAxis : CGFloat = CGFloat(0.0)
    
    var scaleX = 0.1 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var scaleY = 1.0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var offsetX = CGFloat(0.0) {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var offsetY = CGFloat(0.0) {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var incParamDefault = 0.01
    
    #if TARGET_INTERFACE_BUILDER
    var dataSource: GraphViewDataSource!
    #else
    weak var dataSource: GraphViewDataSource!
    #endif
    
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource : GraphViewDataSource {
            
            func startParamOfGraphView(graphView: GraphView) -> Double  {return 0.0}
            
            func endParamOfGraphView(graphView: GraphView) -> Double {return 200.0}
            
            func pointOfGraphView(graphView: GraphView, atParam param: Double) -> Point {
                return Point(x: param*2, y: (param*10)%25)
            }
        }
        
        dataSource = FakeDataSource()
    }
    
    override func drawRect(rect: CGRect) {
        drawAxis()
        drawGraph()
    }
    
    private func drawAxis() {
        let path = UIBezierPath()
        horizontalAxis = bounds.size.height/2+offsetY
        verticalAxis = bounds.size.width/2+offsetX
        
        path.moveToPoint(CGPointMake(0, horizontalAxis))
        path.addLineToPoint(CGPointMake(bounds.size.width, horizontalAxis))
        
        path.moveToPoint(CGPointMake(verticalAxis, 0))
        path.addLineToPoint(CGPointMake(verticalAxis, bounds.size.height))
        
        path.lineWidth = CGFloat(axisWidth)
        axisColor.set()
        
        path.stroke()
    }
    
    private func drawGraph() {
        let width = Double(bounds.size.width)
        
        let startParam = dataSource.startParamOfGraphView(self)
        let endParam = dataSource.endParamOfGraphView(self)
        let incParam = min((endParam - startParam)/width, incParamDefault)
        
        let path = UIBezierPath()
        
        var point = dataSource.pointOfGraphView(self, atParam : startParam)
        
        path.moveToPoint(CGPointMake(xCoordFor(point.x),yCoordFor(point.y)))
        
        for var t = startParam; t < endParam; t += incParam {
            point = dataSource.pointOfGraphView(self, atParam : t)
            path.addLineToPoint(CGPointMake(xCoordFor(point.x),yCoordFor(point.y)))
            
        }
        
        path.lineWidth = CGFloat(graphWidth)
        
        graphColor.set()
        
        path.stroke()
        
    }
    
    private func xCoordFor(x: Double) -> CGFloat {
        return CGFloat(x/scaleX)+bounds.size.width/2+offsetX
    }
    
    private func yCoordFor(y: Double) -> CGFloat {
        return bounds.size.height - (CGFloat(y/scaleY)+bounds.size.height/2-offsetY)
    }
    
}

