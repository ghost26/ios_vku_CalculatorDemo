//
//  CalculatorBrain.swift
//  CalculatorDemo
//
//  Created by Руслан Абдулхаликов on 21.10.16.
//  Copyright © 2016 Ruslan Abdulkhalikov. All rights reserved.
//

import Foundation

private func factorial(operand: Double) -> Double {
    return (operand == 0 ? 1 : factorial(operand: operand - 1))
}

class CalculatorBrain {
    
    private var accumulator: Double = 0.0
    
    func  setOperand(operand: Double) {
        accumulator = operand
    }
    
    
    private var operations: Dictionary<String, Operation> = [
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({$0 == 0.0 ? 0.0 : -$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "!" : Operation.UnaryOperation(factorial),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "×" : Operation.BinaryOperation(*),
        "÷" : Operation.BinaryOperation(/),
        "+" : Operation.BinaryOperation(+),
        "-" : Operation.BinaryOperation(-),
        "=" : Operation.Equals,
        "C" : Operation.Reset
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Reset
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOpearationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Reset:
                resetBrain()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    private func resetBrain() {
        accumulator = 0.0
        pending = nil
    }
    
    private var pending: PendingBinaryOpearationInfo?
    
    private struct PendingBinaryOpearationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
