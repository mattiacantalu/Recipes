import Foundation

final class JSONUtil {

    static func loadClass<T: Decodable>(fromResource resource: String, ofType classType: T.Type) throws -> T? {
        guard let data = JSONUtil.loadData(fromResource: resource) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(classType, from: data)
        } catch {
            return nil
        }
    }

    static func loadData(fromResource resource: String, ofType type: String = "json") -> Data? {
        guard let path = Bundle(for: JSONUtil.self).path(forResource: resource, ofType: type) else {
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            return nil
        }
    }
}
