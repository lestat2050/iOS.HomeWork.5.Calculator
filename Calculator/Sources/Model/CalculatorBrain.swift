//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Yaroslav Surovtsev on 8/7/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

class CalculatorBrain {

    private let operations: [String: Operation] = [
        "+/-": Operation.unaryOperation({ $0 * -1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "%": Operation.percent({ $0 / 100}),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    
    private var previousOperand = 0.0
    private var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    var result: Double {
        get {
            return accumulator;
        }
    }
    
    private enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case percent((Double) -> Double)
        case equals
        case clear
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    func performOperand(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .percent(let function):
                accumulator = previousOperand * function(accumulator)
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                previousOperand = accumulator
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function,
                                                     firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            case .clear:
                clear()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if let pendingInfo = pending {
            accumulator = pendingInfo.binaryFunction(pendingInfo.firstOperand,
                                                  accumulator)
            pending = nil
        }
    }
    
    private func clear() {
        previousOperand = 0
        accumulator = 0
        pending = nil
    }
    
}
