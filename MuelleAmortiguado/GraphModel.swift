//
//  GraphModel.swift
//  MuelleAmortiguado
//
//  Created by g332 DIT UPM on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import Foundation


class GraphModel {
    
    //Customizable attributes
    var m : Double {
        didSet {
            updateConstants()
        }
    }
    var k : Double {
        didSet{
            updateConstants()
        }
    }
    var λ : Double {
        didSet{
            updateConstants()
        }
    }
    
    let mMax : Double
    let kMax : Double
    let λMax : Double

    //Initial attributes
    let x0 = 5.0
    let v0 = 0.0
    var ω0 : Double = 0.0
    
    //Attributes used to calculate speed and position
    var γ : Double = 0.0
    var ω : Double = 0.0
    var A : Double = 0.0
    var φ : Double = 0.0
    
    init(m : Double, k : Double, λ : Double){
        self.mMax = m
        self.kMax = k
        self.λMax = λ
        self.m = mMax
        self.k = kMax
        self.λ = λMax
        updateConstants()
    }
    
    private func updateConstants() {
        ω0 = sqrt(k / m)
        γ = λ / m / 2
        ω = sqrt(ω0*ω0 - γ*γ)
        
        A = sqrt(x0*x0 + pow((v0+γ*x0)/ω,2))
        φ = atan(x0*ω/(v0+γ*x0))
        
    }
    
    func speedAtTime(t : Double) -> Double {
        let a1 = -γ*A*exp(-γ*t)*sin(ω*t+φ)
        let a2 = A*exp(-γ*t)*ω*cos(ω*t+φ)
        return a1 + a2

    }
    
    func posAtTime(t : Double) -> Double {
        return A*exp(-γ*t)*sin(ω*t + φ)
    }
    
}