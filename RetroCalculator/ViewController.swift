//
//  ViewController.swift
//  RetroCalculator
//
//  Created by 小林 泰 on 2017/03/10.
//  Copyright © 2017年 TokyoIceHockeyChannel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var btnSound: AVAudioPlayer!
    private var userIsInMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn",ofType:"wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }

    }
    

    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    @IBAction private func touchButton(_ sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        
        let digit = button.tag
        
        if digit <= 10 {
            touchDigit(digit)
        } else if digit > 10 {
            performOperation(digit)
        }
        
        playSound()
        
    }
    
    func touchDigit(_ digit: Int) {
        
        if userIsInMiddleOfTyping {
            let textCurrenlyInDisplay = display.text!
            display.text = textCurrenlyInDisplay + "\(digit)"
            
        } else {
            display.text = "\(digit)"
        }
        userIsInMiddleOfTyping = true
        
    }
    
    func performOperation(_ digit: Int) {
        
        if userIsInMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInMiddleOfTyping = false
        }
        if let mathematicalSymbol = digit as Optional {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        brain.clear()
        displayValue = brain.result
        userIsInMiddleOfTyping = false
        playSound()
    }


}
