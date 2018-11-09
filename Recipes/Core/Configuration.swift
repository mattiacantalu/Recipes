import Foundation

struct Configuration {
    let baseUrl: String
    let service: Service

    init(baseUrl: String,
         service: Service = Service()) {
        self.baseUrl = baseUrl
        self.service = service
    }
}
