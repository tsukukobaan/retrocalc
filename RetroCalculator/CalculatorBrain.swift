//
//  CalculatorBrain.swift
//  RetroCalculator
//
//  Created by 小林 泰 on 2017/03/19.
//  Copyright © 2017年 TokyoIceHockeyChannel. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func  setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<Int, Operation>  = [
//        "π" : Operation.Constant(M_PI),
//        "e" : Operation.Constant(M_E),
//        "√" : Operation.UnaryOperation(sqrt),
//        "±" : Operation.UnaryOperation({ -$0 }),
//        "cos" : Operation.UnaryOperation(cos),
        
        12 : Operation.BinaryOperation({ $0 * $1 }),
        11 : Operation.BinaryOperation({ $0 / $1 }),
        13 : Operation.BinaryOperation({ $0 - $1 }),
        14 : Operation.BinaryOperation({ $0 + $1 }),
        15 : Operation.Equals,
    ]
    
    private enum Operation {
//        case Constant(Double)
//        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: Int) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            }
        }
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}








