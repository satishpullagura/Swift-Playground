import UIKit

//Actor
//acrors are same like classes it only alows one thread or task to change its state. it prevents data races in concurency model

//Example to demonstrate Actors

actor ShopingCart {
    private var items: [String: Int] = [:]
    func addItems(itemName: String, quantity: Int = 1) {
        self.items[itemName, default: 0] += quantity
    }
    
    func removeItem(itemName: String) {
        self.items.removeValue(forKey: itemName)
    }
    
    func getAllItemsCount() -> Int {
        return self.items.values.reduce(0, +)
    }
}

let shopingcart = ShopingCart()

Task {
    await shopingcart.addItems(itemName: "Apple")
}

Task {
    await shopingcart.addItems(itemName: "Mango", quantity: 10)
}

Task {
    await shopingcart.addItems(itemName: "watermelon", quantity: 5)
}

Task {
    await shopingcart.removeItem(itemName: "Apple")
}

Task {
    let count = await shopingcart.getAllItemsCount()
    print("count of all items in shopping cart",count)
}

