import UIKit

//Generics

//Generics are used to work with more than one data type, A single code snipet is used for all dataTypes
//Swapping using Generics
func swapItems<T>(item1: inout T, item2: inout T)  {
    let temp = item1
    item1 = item2
    item2 = temp
}

var firstIntItem = 2
var secondIntItem = 5
print("Before swap \(firstIntItem), \(secondIntItem)")
swapItems(item1: &firstIntItem, item2: &secondIntItem)
print("After swap \(firstIntItem), \(secondIntItem)")

var firstStringItem = "Hey"
var secondStringItem = "There"

print("Before swap string => \(firstStringItem), \(secondStringItem)")
swapItems(item1: &firstStringItem, item2: &secondStringItem)
print("After swap string =>\(firstStringItem), \(secondStringItem)")
///Here we used same swap function for both Int and string data type, same like this, we can also use other data types

print("\n\n-------------- Stacks Using Generic type --------------\n\n")

//Stack Using Generics
struct Stack<T> {
    private var items: [T] = []
    
    mutating func push(_ item: T) {
        print("Previous Items \(items)")
        print("Item Added \(item)")
        items.append(item)
        print("New Items \(items)")
        
    }
    
    mutating func pull() {
        print("Previous Items \(items)")
        print("Item Removed \(self.items[self.items.count - 1])")
        self.items.removeLast()
        print("Updated Items \(items)")
    }
    
    func peak()  -> T {
        self.items[self.items.count - 1]
    }
}

var stringStack = Stack<String>()
stringStack.push("satish")
stringStack.push("sudheer")
stringStack.push("Nani")
stringStack.push("Bhuvana")

let topItem = stringStack.peak()
print("Top Item \(topItem)")

stringStack.pull()

let topItemNow = stringStack.peak()
print("Top Item \(topItemNow)")

//Same stack we can use for other data type like Integers
var intStack = Stack<Int>()
intStack.push(2)
intStack.push(5)
intStack.push(9)
intStack.push(7)


//Generic function with where clause
print("\n\n-------------- Generic function with where clause --------------\n\n")

protocol Container {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
struct StringStack2<T: Equatable>: Container {
    mutating func append(_ item: Item) {
        self.items.append(item)
    }

    subscript(i: Int) -> Item {
        self.items[i]
    }


    typealias Item = T

    var count: Int {
        self.items.count
    }

    var items: [Item] = []
}

var newSrringStack = StringStack2<String>()
newSrringStack.append("satish")
newSrringStack.append("sudheer")
newSrringStack.append("nani")

let arrOfNames = ["satish", "sudheer", "nani"]

func FindMatchingObjects<C1: Container, C2: Container>(container1: C1, container2: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    
    if container1.count != container2.count {
        return false
    }
    
    for i in 0..<container1.count {
        if container1[i] != container2[i] {
            return false
        }
    }
    
    return true
}

extension Array: Container where Element: Equatable {
    
}


print("All values are matched? => ",FindMatchingObjects(container1: arrOfNames, container2: newSrringStack))
