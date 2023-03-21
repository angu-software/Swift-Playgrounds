import Foundation

public enum SnapshotsDirectory: String {
    case referenceSnapshots = "ReferenceSnapshots"
    case failureDiffs       = "FailureDiffs"

    public func directoryURL(relativeTo baseURL: URL) -> URL {
        return baseURL.appendingPathComponent(rawValue, isDirectory: true)
    }
}
