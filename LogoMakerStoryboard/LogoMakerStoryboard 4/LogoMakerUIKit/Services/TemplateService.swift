import Foundation

final class TemplateService {
    static let shared = TemplateService()
    private let remoteURL: URL? = nil
    private let workQueue = DispatchQueue(label: "com.logomaker.template-service", qos: .userInitiated)
    private var cachedCategories: [TemplateCategory]?
    private init() {}

    func fetchCategories(forceRefresh: Bool = false, completion: @escaping (Result<[TemplateCategory], Error>) -> Void) {
        workQueue.async { [weak self] in
            guard let self else { return }
            if !forceRefresh, let cachedCategories = self.cachedCategories { self.complete(.success(cachedCategories), completion: completion); return }
            guard let remoteURL = self.remoteURL else { self.loadBundled(completion: completion); return }
            URLSession.shared.dataTask(with: remoteURL) { [weak self] data, response, error in
                guard let self else { return }
                if error != nil || data == nil { self.workQueue.async { self.loadBundled(completion: completion) }; return }
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode), let data else {
                    self.workQueue.async { self.loadBundled(completion: completion) }; return
                }
                let result = self.decode(data: data)
                self.workQueue.async {
                    if case .success(let categories) = result { self.cachedCategories = categories; self.complete(.success(categories), completion: completion) }
                    else { self.loadBundled(completion: completion) }
                }
            }.resume()
        }
    }

    private func loadBundled(completion: @escaping (Result<[TemplateCategory], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "NewLogoMakerIOS-decoded", withExtension: "json") else {
            complete(.failure(NSError(domain: "TemplateService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Template data is missing from the app bundle."])), completion: completion); return
        }
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe); let result = decode(data: data)
            if case .success(let categories) = result { cachedCategories = categories }
            complete(result, completion: completion)
        } catch { complete(.failure(error), completion: completion) }
    }

    private func decode(data: Data) -> Result<[TemplateCategory], Error> {
        do {
            let response = try JSONDecoder().decode(TemplatesResponse.self, from: data)
            guard let templateBlock = response.AppData.Templates.first else {
                return .failure(NSError(domain: "TemplateService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Template data does not contain a template block."]))
            }
            return .success(templateBlock.Categories)
        } catch { return .failure(error) }
    }

    private func complete(_ result: Result<[TemplateCategory], Error>, completion: @escaping (Result<[TemplateCategory], Error>) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }
}
