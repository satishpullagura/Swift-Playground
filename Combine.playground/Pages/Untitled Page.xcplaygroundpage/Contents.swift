import UIKit
import Combine
import Foundation


//combine latest
let publisher1 = CurrentValueSubject<Int, Never>(1)
let publisher2 = CurrentValueSubject<Int, Never>(2)

let combinedPublisher = publisher1.combineLatest(publisher2)
let cancellable = combinedPublisher.sink { value1, value2 in
    print(value1, value1)
}

publisher1.send(32)
publisher2.send(45)
publisher1.send(22)

//ZIP
let publisher11 = [1,2,3].publisher
let publisher12 = ["A","B","C","D",].publisher
let publisher13 = ["sathish","sudheer","nani"].publisher

let zipPublisher = Publishers.Zip3(publisher11, publisher12, publisher13)

let cancellabel11 = zipPublisher.sink { value in
    print(value.0, value.1, value.2)
}


//switchToLatest
let commonPublisher = PassthroughSubject<AnyPublisher<Int, Never>, Never>()
let vegItemPublisher = CurrentValueSubject<Int, Never>(1)
let nonvegItemPublisher = CurrentValueSubject<Int, Never>(2)

let cancellable21 = commonPublisher.switchToLatest()
    .sink { value in
    print(value)
}

commonPublisher.send(AnyPublisher(nonvegItemPublisher))
vegItemPublisher.send(39)
nonvegItemPublisher.send(90)






enum ServerError: Error {
    case invalidNumber
}

class ViewModel: ObservableObject {
    @Published var number = 1
    var cancellabel: AnyCancellable?
    
    init() {
        let numberPublisher = [1,2,3,4,5,6].publisher
        let doublePublisher = numberPublisher.tryMap { number in
            if number == 4 {
                throw ServerError.invalidNumber
            }
            return number * 2
        }.mapError { _ in
            return ServerError.invalidNumber
        }
        
        cancellabel = numberPublisher.assign(to: \.number, on: self)
    }
    
    
    
}


 let viewModel = ViewModel()
print(viewModel.number)
//error handling
/*let numberPublisher = [1,2,3,4,5,6].publisher
let doublePublisher = numberPublisher.tryMap { number in
    if number == 4 {
        throw ServerError.invalidNumber
    }
    return number * 2
}.mapError { _ in
    return ServerError.invalidNumber
}



let cancellabel = doublePublisher.sink { complition in
    switch complition {
    case .finished:
        print("finished")
    case .failure(let error):
        print(error)
    }
} receiveValue: { value in
    print(value)
}*/

//MARK: Making network call using Combine
/*"userId": 1,
 "id": 1,
 "title": "sunt",
 "body": "quia"**/
struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

func fetchData() -> AnyPublisher<[Post], Error> {
    return URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        .map(\.data)
        .decode(type: [Post].self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

var cancellable123123 = Set<AnyCancellable>()

fetchData().sink { compltion in
    switch compltion {
    case .finished:
        print("Do UI update")
    case .failure(let error):
        print(error)
    }
} receiveValue: { result in
    print(result)
}.store(in: &cancellable123123)

