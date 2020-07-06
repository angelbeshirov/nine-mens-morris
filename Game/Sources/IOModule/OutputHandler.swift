// The output handler protocol which every class handling the output 
// visualization to the user should implement using this game package.
public protocol OutputHandler {

    // displays the output to the user in some way
    func display(output: String)
}

// Console implementation of the output handler. Displays the output to the user in 
// the standard output.
public class ConsoleOutputHandler: OutputHandler {

    // public empty initializer to make this class accessible in other modules
    public init() {}

    // displays the output to the user in the standard output
    public func display(output: String) {
        print(output)
    }
}