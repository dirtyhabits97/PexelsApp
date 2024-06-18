import Combine
import Foundation
import RealmSwift

@available(macOS 15.0, *)
public final class RealmStorage: LocalStorage {
    private let realm: Realm

    public init(realm: Realm) {
        self.realm = realm
    }

    // MARK: - LocalStorage

    public func saveToDisk<Model: LocalStorageObject>(
        _ models: [Model]
    ) throws {
        try realm.write {
            let realmModels = models.map { $0.asRealmModel() }
            print("com.RealmStorage: Saving \(realmModels)")
            realm.add(realmModels)
        }
    }

    public func clearFromDisk<Model: LocalStorageObject>(_ type: Model.Type) throws {
        try realm.write {
            let realmModels = realm.objects(type.RealmModel)
            print("com.RealmStorage: Deleting \(realmModels)")
            realm.delete(realmModels)
        }
    }

    public func loadFromDisk<Model: LocalStorageObject>(
        _ type: Model.Type
    ) -> AnyPublisher<[Model], Never> {
        let objects = realm
            .objects(type.RealmModel)
            .map { type.build(using: $0) }
        return Just(Array(objects))
            .eraseToAnyPublisher()
    }
}
