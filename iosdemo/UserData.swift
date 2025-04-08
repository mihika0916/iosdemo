import ParseSwift
import Foundation

struct UserData: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var owner: User?
    var favoriteQuote: String?

    // called after sign up
    static func createDefault(for user: User) {
        var data = UserData()
        data.owner = user
        data.favoriteQuote = "Default quote"

        var acl = ParseACL()
        acl.setReadAccess(user: user, value: true)
        acl.setWriteAccess(user: user, value: true)
        data.ACL = acl

        data.save { result in
            switch result {
            case .success(let saved):
                print("Created default UserData: \(saved)")
            case .failure(let error):
                print("Failed to create UserData: \(error)")
            }
        }
    }

    // called after login
    static func fetch(for user: User, completion: @escaping (UserData?) -> Void) {
        guard let userId = user.objectId else {
            completion(nil)
            return
        }

        let userPointer = Pointer<User>(objectId: userId)
        let query = UserData.query("owner" == userPointer)

        query.first { result in
            switch result {
            case .success(let data):
                print("Fetched UserData: \(data)")
                completion(data)
            case .failure(let error):
                print("Failed to fetch UserData: \(error)")
                completion(nil)
            }
        }
    }
}
