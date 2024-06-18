import SwiftUI

@available(macOS 15.0, *)
struct NetworkStatusView: View {
    @StateObject
    var observedObject: NetworkStatusObservableObject

    init(networkStatusObservableObject: NetworkStatusObservableObject) {
        _observedObject = StateObject(wrappedValue: networkStatusObservableObject)
    }

    var body: some View {
        HStack {
            Circle()
                .fill(observedObject.networkStatus == .offline ? Color.red : Color.green)
                .frame(width: 10, height: 10)
            Text(observedObject.networkStatus.rawValue)
                .font(.footnote)
                .foregroundColor(.primary)
        }
    }
}
