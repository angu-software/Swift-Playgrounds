import Foundation

public final class SnapshotFileStore {

    private let fileExtension = "png"
    private let fileManager = FileManager.default

    private let directory: URL
    private let queue: DispatchQueue

    public init?(directory: URL) {
        guard directory.isFileURL,
              directory.hasDirectoryPath else {
            return nil
        }

        self.directory = directory
        self.queue = DispatchQueue(label: String(describing: type(of: self)) + " \(directory.path)")
    }

    public func snapshot(named fileName: SnapshotFileName) -> Snapshot? {
        return try? sync {
            let fileURL = self.fileURL(with: fileName)
            guard let fileData = fileManager.contents(atPath: fileURL.path) else {
                return nil
            }

            return Snapshot(data: fileData)
        }
    }

    public func saveSnapshot(_ snapshot: Snapshot, named fileName: SnapshotFileName) throws {
        try sync {
            let fileURL = self.fileURL(with: fileName)
            guard let fileData = snapshot.pngData() else {
                return
            }

            try fileManager.createDirectory(atPath: directory.path, withIntermediateDirectories: true)
            try fileData.write(to: fileURL, options: .atomic)
        }
    }

    private func fileURL(with fileName: SnapshotFileName) -> URL {
        var fileURL = directory.appendingPathComponent(fileName.rawValue)
        if fileURL.pathExtension != fileExtension {
            fileURL.appendPathExtension(fileExtension)
        }
        return fileURL
    }

    private func sync(_ task: () throws -> Void) throws {
        try queue.sync {
            try task()
        }
    }

    private func sync<T>(_ task: () throws -> T) throws -> T {
        return try queue.sync {
            try task()
        }
    }
}
