//
//  ViewController.swift
//  MuelleAmortiguado
//
//  Created by g332 DIT UPM on 6/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var mSlider: UISlider!
    @IBOutlet weak var kSlider: UISlider!
    @IBOutlet weak var λSlider: UISlider!
    
    @IBOutlet weak var mValue: UILabel!
    @IBOutlet weak var kValue: UILabel!
    @IBOutlet weak var λValue: UILabel!
    
    @IBOutlet weak var speedPosView: GraphView!
    @IBOutlet weak var speedTimeView: GraphView!
    @IBOutlet weak var posTimeView: GraphView!
    
    var graphModel : GraphModel!
    
    var speedPosScale = 19.0 {
        didSet{
            speedPosView.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphModel = GraphModel(m: 5, k: 2000, λ: 17)
        
        speedPosView.dataSource = self
        speedTimeView.dataSource = self
        posTimeView.dataSource  = self
        
        mSlider.sendActionsForControlEvents(.ValueChanged)
        kSlider.sendActionsForControlEvents(.ValueChanged)
        λSlider.sendActionsForControlEvents(.ValueChanged)
        
        mValue.text = String(round(graphModel.m))
        kValue.text = String(round(graphModel.k))
        λValue.text = String(round(graphModel.λ))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IB Actions
    
    @IBAction func mChanged(sender: UISlider) {
        graphModel.m = graphModel.mMax*Double(sender.value) + 1.0
        mValue.text = String(round(graphModel.m))
        speedPosView.setNeedsDisplay()
        speedTimeView.setNeedsDisplay()
        posTimeView.setNeedsDisplay()
    }

    @IBAction func kChanged(sender: UISlider) {
        graphModel.k = graphModel.kMax*Double(sender.value) + 100.0
        kValue.text = String(round(graphModel.k))
        speedPosView.setNeedsDisplay()
        speedTimeView.setNeedsDisplay()
        posTimeView.setNeedsDisplay()
    }

    @IBAction func λChanged(sender: UISlider) {
        graphModel.λ = graphModel.λMax*Double(sender.value)
        λValue.text = String(round(graphModel.λ))
        speedPosView.setNeedsDisplay()
        speedTimeView.setNeedsDisplay()
        posTimeView.setNeedsDisplay()
    }
    
    // MARK: GraphViewDatasource
    
    func startParamOfGraphView(graphView: GraphView) -> Double {
        return 0.0
    }
    
    func endParamOfGraphView(graphView: GraphView) -> Double {
        let endTime = Double(graphView.bounds.size.width/2)
        
        switch graphView {
        case speedTimeView:
            return endTime
        case posTimeView:
            return endTime
        case speedPosView:
            return (speedPosScale*3.14 - graphModel.φ)/graphModel.ω
        default:
            return 0.0
        }
        
    }
    
    func pointOfGraphView(graphView: GraphView, atParam param: Double) -> Point {
        switch graphView {
        case speedPosView:
            let x = graphModel.posAtTime(param)
            let y = graphModel.speedAtTime(param)
            return Point(x : x, y : y)
        case posTimeView:
            let x = param
            let y = graphModel.posAtTime(param)
            return Point(x : x, y : y*10)
        case speedTimeView:
            let x = param
            let y = graphModel.speedAtTime(param)
            return Point(x : x, y : y)
        default:
            return Point(x : 0, y : 0)
        }
    }
    
    @IBAction func decreaseScaleSwipe(sender: UISwipeGestureRecognizer) {
        speedPosScale /= 1.1
    }
    
    @IBAction func increaseScaleSwipe(sender: UISwipeGestureRecognizer) {
        speedPosScale *= 1.1
    }
    
    @IBAction func changeZoomSpeedPos(sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        speedPosView.scaleX /= Double(factor)
        speedPosView.scaleY /= Double(factor)
        sender.scale=1
    }
    
    @IBAction func changeZoomSpeedTime(sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        speedTimeView.scaleX /= Double(factor)
        speedTimeView.scaleY /= Double(factor)
        sender.scale=1
    }
    
    @IBAction func changeZoomPosTime(sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        posTimeView.scaleX /= Double(factor)
        posTimeView.scaleY /= Double(factor)
        sender.scale=1
    }
    
    @IBAction func changeOriginSpeedTime(sender: UITapGestureRecognizer) {
        let pos = sender.locationInView(sender.view)
        speedTimeView.offsetX = pos.x - speedTimeView.bounds.size.width/2
        speedTimeView.offsetY = pos.y - speedTimeView.bounds.size.height/2
    }
    
    @IBAction func changeOriginPosTime(sender: UITapGestureRecognizer) {
        let pos = sender.locationInView(sender.view)
        posTimeView.offsetX = pos.x - posTimeView.bounds.size.width/2
        posTimeView.offsetY = pos.y - posTimeView.bounds.size.height/2
    }
    
    @IBAction func resetAllViews(sender: UIScreenEdgePanGestureRecognizer) {
        
        speedPosScale = 19.0
        
        speedTimeView.offsetX = 0.0
        speedTimeView.offsetY = 0.0
        posTimeView.offsetX = 0.0
        posTimeView.offsetY = 0.0
        
        speedPosView.scaleX = 0.1
        speedPosView.scaleY = 1.0
        speedTimeView.scaleX = 0.1
        speedTimeView.scaleY = 1.0
        posTimeView.scaleX = 0.1
        posTimeView.scaleY = 1.0
        
        mSlider.value = 0.5
        λSlider.value = 0.5
        kSlider.value = 0.5
        mChanged(mSlider)
        kChanged(kSlider)
        λChanged(λSlider)
        
        speedPosView.setNeedsDisplay()
        speedTimeView.setNeedsDisplay()
        posTimeView.setNeedsDisplay()
   
    }
    
    
    @IBAction func centerGraphSpeedTime(sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizerState.Began){
            return
        }
        let pos = sender.locationInView(sender.view)
        speedTimeView.offsetX = +speedTimeView.verticalAxis-pos.x
        speedTimeView.offsetY = +speedTimeView.horizontalAxis-pos.y
    }
    
    @IBAction func centerGraphPosTime(sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizerState.Began){
            return
        }
        let pos = sender.locationInView(sender.view)
        posTimeView.offsetX = +posTimeView.verticalAxis-pos.x
        posTimeView.offsetY = +posTimeView.horizontalAxis-pos.y
    }
}

