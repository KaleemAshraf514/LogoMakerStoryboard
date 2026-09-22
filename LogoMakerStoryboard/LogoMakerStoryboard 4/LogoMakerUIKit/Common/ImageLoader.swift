import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    private init() {
        cache.countLimit = 150
        cache.totalCostLimit = 80 * 1024 * 1024
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
    }
    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let cached = cache.object(forKey: url as NSURL) {
            if Thread.isMainThread { completion(cached) } else { DispatchQueue.main.async { completion(cached) } }
            return nil
        }
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self, error == nil, let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode), let data, !data.isEmpty,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self.cache.setObject(image, forKey: url as NSURL, cost: data.count)
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
}
