import Combine
import RealmSwift

// LocalStorage
// + saveToDisk<Model>(_ models: [Model], transform: (Model) -> ManagedObject) throws
// + clearFromDisk<Model: ManagedObject>(_ type: Model.Type) throws
// + loadFromDisk(_ type: Model.Type) -> AnyPublisher<Model, Error>
@available(macOS 15.0, *)
public protocol LocalStorage {
    func saveToDisk<Model: LocalStorageObject>(
        _ models: [Model]
    ) throws

    func clearFromDisk<Model: LocalStorageObject>(
        _ type: Model.Type
    ) throws

    func loadFromDisk<Model: LocalStorageObject>(
        _ type: Model.Type
    ) -> AnyPublisher<[Model], Never>
}

// NOTE: For now, we only support local storage with Realm so there is no problem in exposing
// Realm objects in the public API.
// However, if we want to support multiple storage vendors we will need to use internal types
public protocol LocalStorageObject {
    associatedtype RealmModel: RealmSwift.Object

    func asRealmModel() -> RealmModel
    static func build(using: RealmModel) -> Self
}
