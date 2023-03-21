import UIKit

actor ResourceLoader {

    private let urlSessionConfig: URLSessionConfiguration
    private lazy var session = URLSession(configuration: urlSessionConfig)

    init(urlSessionConfig: URLSessionConfiguration = .default) {
        self.urlSessionConfig = urlSessionConfig
    }

    private var runningDataTasks: [URLRequest: Task<(Data, URLResponse), Error>] = [:]

    func sendRequest(_ urlRequest: URLRequest) async throws -> (data: Data, response: URLResponse) {
        if let runningRequest = runningDataTasks[urlRequest] {
            return try await runningRequest.value
        }

        let task = Task {
            try await session.data(for: urlRequest)
        }

        runningDataTasks[urlRequest] = task

        let response = try await task.value

        runningDataTasks[urlRequest] = nil

        return response
    }
}

actor ImageLoader {

    private let resourceLoader = ResourceLoader()
    private var cache: [URLRequest: Data]? = [:]

    func sendImageDataRequest(_ urlRequest: URLRequest) async throws -> Data {
        if let imageData = cache?[urlRequest] {
            return imageData
        }

        let imageDataResponse = try await resourceLoader.sendRequest(urlRequest)

        cache?[urlRequest] = imageDataResponse.data

        return imageDataResponse.data
    }
}

var requestSendingCount = 0
func requestData() async throws -> String {
    try await Task.sleep(nanoseconds:200000000)
    requestSendingCount += 1
    return String("ABCDEFGHIJKLMNOP".randomElement()!)
}

var runningTask: Task<String, Error>?

func fetchData() async throws -> String {
    if let runningTask = runningTask {
        return try await runningTask.value
    } else {
        let newTask = Task {
            try await requestData()
        }

        runningTask = newTask
        return try await newTask.value
    }
}

let numberOfDetachedTasks = 10
var detachedTaskFinishedCount = 0

//Task { @MainActor in
//    for index in 0..<numberOfDetachedTasks {
//        Task.detached {
//            try await Task.sleep(nanoseconds: .random(in: 0..<300000))
//
//            let data = try await fetchData()
//
//            print("Result \(index): \(data)")
//            detachedTaskFinishedCount += 1
//        }
//    }
//
//    while detachedTaskFinishedCount < numberOfDetachedTasks {
//        await Task.yield()
//    }
//
//    print("All finished!")
//    print("Actual request send: \(requestSendingCount)")
//}

// -----

final class URLRequestCoordinator {

    private let requestResolver: (URLRequest) async throws -> Data

    private var runningRequests = RunningRequestStore()

    init(requestResolver: @escaping (URLRequest) async throws -> Data) {
        self.requestResolver = requestResolver
    }

    func sendRequest(_ request: URLRequest) async throws -> Data {
        print("entering \(#function)")
        if let runningTask = await runningRequests.task(for: request) {
            return try await runningTask.value
        }

        let requestTask: Task<Data, Error> = Task {
            let data = try await self.requestResolver(request)
            return data
        }

        await runningRequests.addTask(requestTask, for: request)

        let data = try await requestTask.value

        await self.runningRequests.removeTask(for: request)

        return data
    }
}

actor RunningRequestStore {
    private var runningRequests: [URLRequest: Task<Data, Error>] = [:]

    func addTask(_ task: Task<Data, Error>, for request: URLRequest) {
        guard runningRequests[request] == nil else {
            return
        }

        runningRequests[request] = task
    }

    func task(for request: URLRequest) -> Task<Data, Error>? {
        return runningRequests[request]
    }

    func removeTask(for request: URLRequest) {
        runningRequests[request] = nil
    }
}

enum RequestError: LocalizedError {
    case somethingWentWrong

    var errorDescription: String? {
        return "\(self)"
    }
}

// ----------

let urlRequest01 = URLRequest(url: URL(string: "https://giveMeARandomCharacter.com")!)
let urlRequest02 = URLRequest(url: URL(string: "https://giveMeAnotherRandomCharacter.com")!)
let urlRequest03 = URLRequest(url: URL(string: "https://somethingWentWrong.com")!)

let requestCoordinator = URLRequestCoordinator { request in
    defer {
        requestSendingCount += 1
    }

    try await Task.sleep(nanoseconds: .random(in: 20000000..<5000000000))

    if request == urlRequest03 {
        throw RequestError.somethingWentWrong
    }
    let character = String("ABCDEFGHIJKLMNOP".randomElement()!)

    return character.data(using: .utf8)!
}

let availableRequests = [urlRequest01, urlRequest02, urlRequest03]

Task {
    print("---------URLRequestCoordinator--------------")
    requestSendingCount = 0
    let numberOfDetachedTasks = 10

    for index in 0..<numberOfDetachedTasks {
        Task.detached {
            let request = availableRequests.randomElement()!
            let requestDesc = request.url!.absoluteString

            do {
                let data = try await requestCoordinator.sendRequest(request)

//                try await Task.sleep(nanoseconds: .random(in: 0..<300000))

                print("\(Thread.current) Result \(index): \(requestDesc) -> \(String(data: data, encoding: .utf8)!)")
            } catch {
                print("\(Thread.current) Error \(index): \(requestDesc) -> \(error.localizedDescription)")
            }

            detachedTaskFinishedCount += 1
        }
    }

    while detachedTaskFinishedCount < numberOfDetachedTasks {
        await Task.yield()
    }

    print("All finished!")
    print("Actual request send: \(requestSendingCount)")
}

