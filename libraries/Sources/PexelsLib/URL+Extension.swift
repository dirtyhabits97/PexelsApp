import Foundation

extension URL {
    init?(string: String?) {
        if let string {
            self.init(string: string)
        } else {
            return nil
        }
    }
}
