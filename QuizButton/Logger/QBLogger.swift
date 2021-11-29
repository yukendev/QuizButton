import Foundation

final class QBLogger {
    
    static func error(_ error: Error) {
        print("🚨errorDescription: \(error.localizedDescription)")
    }
}
