//: [Previous](@previous)

import Foundation
import Combine
import SwiftUI

var greeting = "Hello, playground"

//: [Next](@next)
//MARK: Just Publisher
///Just Publisher is a the only publish only one value at a time


let publisher = Just(10)
///Sink is a subscriber, when just publisher send values sink receives bcoz we have subscribed that publisher with sink subscriber
let cancellable = publisher.sink { value in
    print(value)
}

//MARK: Sequence Publisher

let numberPublisher = [1,2,3,4,5,6,7,8,9].publisher
let cancellable1 = numberPublisher.sink { value in
    print(value)
}

//MARK: Operators
//Operators are 3 Types
//1.Transform Operators
//2.Filter Operators
//3.Combine Operators

//MARK: 1.Transform Operators
//MARK: - a) Map, b) Flatmap, c) merge

//MARK: a) Map

let numbPublisher = [1,2,3,4,5,6,7,8,9].publisher
let doublePublisher = numbPublisher.map({$0 * 2})
let cancellabledouble = doublePublisher.sink { value in
    print("Map ==>",value)
}

//MARK: b) FlatMap

let strPublisher = ["satish", "sudheer"].publisher
let flatMapPublisher = strPublisher.flatMap { strValue in
    strValue.publisher
}

let cancellableFlatMap = flatMapPublisher.sink { value in
    print("FlatMap ===>",value)
}

//MARK: c) Merge

let pub1 = [1,2,3,4,5].publisher
let pub2 = [4,5,6].publisher
let mergePub = Publishers.Merge(pub1, pub2)

let cancellableMergPub = mergePub.sink { value in
    print("Merged Publisher Values",value)
}

//MARK: 2.Filter Operators
//MARK: - a) filter, b) compactMap, c) debouce

//MARK: a) Filter

let numbPub = [1,2,3,4,5,6,7,8,9,10,12,11,12,13,14,15,16,17,18,19,20].publisher
let filterPub = numbPub.filter { numb in
    numb % 2 == 0
}//it only print even number, it filter all elements and only return even number

let cancellableFilter = filterPub.sink { evenValue in
    print("FilteredValues ==> ",evenValue)
}

//MARK: b) CompactMap
let stringCumNumpPublisher2 = ["1", "2", "3", "A"].publisher
let onlyNumberPublisher = stringCumNumpPublisher2.compactMap { value in
    Int(value)
}
let cancellableCompactMap = onlyNumberPublisher.sink { value in
    print("Compact map ==>",value)
}

//MARK: c) debouce

class ViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var debounceValue: String = ""
    var cancellable = Set<AnyCancellable>()
    
    init() {
        $userInput
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { finalText in
                self.debounceValue = finalText
            }.store(in: &cancellable)
    }
}

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            TextField("Search here...", text: $viewModel.userInput)
            Text(
                "Debouce value after user typed in serach bar \(viewModel.debounceValue)"
            )
        }
    }
}

//MARK: 3.Combine Operators
//MARK: - a) combineLatest, b) zip, c) switchToLatest


//MARK: a) CombineLatest
let publisher1 = CurrentValueSubject<Int, Never>(1)
let publisher2 = CurrentValueSubject<Int, Never>(2)

let combineLatestPub = publisher1.combineLatest(publisher2)

let cancellableCombineLatest = combineLatestPub.sink { (value1, value2) in
    print("Combine latest value1 \(value1),...... value2 \(value2)")
}

publisher1.send(10)
publisher2.send(45)

//MARK: b) Zip

let publisher124 = [1,2,3,4,5,6].publisher
let publisher224 = ["A", "B", "C", "D"].publisher
let publisher324 = ["satish", "sudheer", "sudheeksha"].publisher

let zipPublisher = Publishers.Zip3(publisher124, publisher224, publisher324)
let cancellableZipOperator = zipPublisher.sink { value in
    print(value.0, value.1, value.2)
}

//MARK: c) SwitchToLatest

let commonPublisher = PassthroughSubject<AnyPublisher<Int, Never>, Never>()
let userPublisher1 = CurrentValueSubject<Int, Never>(1)
let userPublisher2 = CurrentValueSubject<Int, Never>(2)

let cancellableSwitchtoLatest = commonPublisher.switchToLatest().sink { value in
    print("Switch to latest value \(value)")
}

commonPublisher.send(AnyPublisher(userPublisher1))
userPublisher1.send(234)

userPublisher2.send(109)//this wont get print, bcoz it is not updated as latest publisher, so before sending value we much add this publisher to common publisher then send value to get printed. untill you add this publisher to common this 109 value will be in queue


commonPublisher.send(AnyPublisher(userPublisher2))
userPublisher2.send(987)


