public protocol OutputHandler {
    func display(output: String)
}

public class ConsoleOutputHandler: OutputHandler {

    public init() {

    }

    public func display(output: String) {
        print(output)
    }
}