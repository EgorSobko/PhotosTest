import Foundation

// MARK: - Delegate
public protocol KitchenDelegate: AnyObject {
    associatedtype Command
    func perform(_ command: Command)
}

public class AnyKitchenDelegate<C>: KitchenDelegate {
    private let box: AbstractKitchenDelegate<C>
    
    public init<D: KitchenDelegate>(_ delegate: D) where D.Command == C {
        self.box = AnyKitchenDelegateBox(delegate)
    }
    
    public func perform(_ command: C) {
        self.box.perform(command)
    }
}

// MARK: - Implementation
private class AbstractKitchenDelegate<C>: KitchenDelegate {
    func perform(_ command: C) { fatalError("abstract needs override") }
}

private class AnyKitchenDelegateBox<D: KitchenDelegate>: AbstractKitchenDelegate<D.Command> {
    private weak var concrete: D?
    
    init(_ concrete: D) {
        self.concrete = concrete
    }
    
    override func perform(_ command: D.Command) {
        let dispatchBlock = DispatchWorkItem { [weak self] in
            self?.concrete?.perform(command)
        }
        if Thread.isMainThread {
            dispatchBlock.perform()
        }
        else {
            DispatchQueue.main.async(execute: dispatchBlock)
        }
    }
}
