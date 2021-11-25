/**
    Author: Taichi Masuyama
    Contact: montanha.masu536@gmail.com
    Version: 1.0.0
 */

/*
 Usage:
 let logger = QBLogger("namespace:name")
 
 logger.info(message: "informational message")

 logger.error(message: "error message")
 logger.error(message: "error message", err: ErrorObj)
 */


import Foundation

final class QBLogger {
    
    static func error(_ error: Error) {
        print("🚨errorDescription: \(error.localizedDescription)")
    }
}
