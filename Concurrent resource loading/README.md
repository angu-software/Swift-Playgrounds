# Resource loading using Swift concurrency

The idea is to build a resource loaded which is downloading a remote resource. If a request comes in to load the same resource again which is currently loading the task waits until the original triggered download is finished.
