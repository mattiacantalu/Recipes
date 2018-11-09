import Foundation

protocol Dispatcher {
    func dispatch(callback: @escaping () -> Void)
}

struct DefaultDispatcher: Dispatcher {
    init() {}

    func dispatch(callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            callback()
        }
    }
}

struct SyncDispatcher: Dispatcher {
    init() {}

    func dispatch(callback: @escaping () -> Void) {
        callback()
    }
}
