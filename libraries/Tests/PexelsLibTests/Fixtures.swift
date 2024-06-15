import Foundation

func getFixtureURL(_ filename: String) throws -> URL {
    if let url = Bundle.module.url(forResource: filename, withExtension: nil) {
        return url
    }
    throw "Couldn't find \(filename) in the fixture folder."
}

func getFixture<Model: Decodable>(
    _ filename: String,
    as _: Model.Type
) throws -> Model {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let url = try getFixtureURL(filename)
    return try decoder.decode(Model.self, from: Data(contentsOf: url))
}
