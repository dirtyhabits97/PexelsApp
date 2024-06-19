import SnapshotTesting
import SwiftUI

func assertFullscreenSnapshots(
    of view: some View,
    function: StaticString = #function
) {
    #if os(iOS)
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light)),
            named: "\(function)_iPhoneSE_light"
        )
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .dark)),
            named: "\(function)_iPhoneSE_dark"
        )
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13ProMax), traits: .init(userInterfaceStyle: .light)),
            named: "\(function)_iPhone13ProMax_light"
        )
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13ProMax), traits: .init(userInterfaceStyle: .dark)),
            named: "\(function)_iPhone13ProMax_dark"
        )
    #endif
}

func assertCompactSnapshots(
    of view: some View,
    function: StaticString = #function
) {
    #if os(iOS)
        assertSnapshot(
            of: view,
            as: .image(
                layout: .fixed(width: 300, height: 300),
                traits: .init(userInterfaceStyle: .light)
            ),
            named: "\(function)_light"
        )
        assertSnapshot(
            of: view,
            as: .image(
                layout: .fixed(width: 300, height: 300),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "\(function)_dark"
        )
    #endif
}
