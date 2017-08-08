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
        "×": Operation.binaryOperation({ $0 * $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    
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
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    func performOperand(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .binaryOperation(let function):
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
        accumulator = 0
        pending = nil
    }
    
}
