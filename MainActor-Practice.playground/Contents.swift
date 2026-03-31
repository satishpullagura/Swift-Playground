import UIKit

//MainActor
//@MainActor is provides to make sure all the UI updates executed on main thread. It replaces the use of DispatchQue.main in concurrency model
struct APPConstants {
    static let userDetailsURL = "https://jsonplaceholder.typicode.com/users"
}
struct UserModel: Codable {
    var id: Int
    var name: String
    var email: String
}
class APIServicerManager {
    
    func fetchDataFromServer<T: Codable>(url: String, type: T.Type) async throws -> [T] {
        do {
            let (data, _) = try await  URLSession.shared.data(
                from: URL(string: APPConstants.userDetailsURL)!
            )
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("server error")
        }
        print("end of scope")
        return try JSONDecoder().decode([T].self, from: Data())
        
    }
}
@MainActor
class UserViewModel: ObservableObject {
    @Published var userDetails: [UserModel] = []
    
    func getUserData() async throws {
        
        do {
            let userDetails = try await APIServicerManager().fetchDataFromServer(
                url: APPConstants.userDetailsURL,
                type: UserModel.self
            )
            //Either we can call a specific code on main thread or directly place mainactor on top of class to ren code on main thread
            await MainActor.run {
                self.userDetails = userDetails
                print("successfully fetched data")
                print(
                    "Name: =>",
                    userDetails.first?.name,
                    "Email =>",
                    userDetails.first?.email
                )
            }
            
        } catch {
            throw error
        }
        
    }
}

Task {
    let userDataViewModel = UserViewModel()
    do {
        try await userDataViewModel.getUserData()
    } catch {
        print(error)
    }
}
