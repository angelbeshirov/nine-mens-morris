extension String {
    subscript (i: Int) -> Character {
        get {
            return self[self.index(self.startIndex, offsetBy: i)]
        }
    }
}

class IOUtil {

    var coordinateMapping: [String: Int] = [String: Int]();

    public init() {
        self.coordinateMapping["a1"] = 0;
        self.coordinateMapping["d1"] = 1;
        self.coordinateMapping["g1"] = 2;
        self.coordinateMapping["b2"] = 3;
        self.coordinateMapping["d2"] = 4;
        self.coordinateMapping["f2"] = 5;
        self.coordinateMapping["c3"] = 6;
        self.coordinateMapping["d3"] = 7;
        self.coordinateMapping["e3"] = 8;
        self.coordinateMapping["a4"] = 9;
        self.coordinateMapping["b4"] = 10;
        self.coordinateMapping["c4"] = 11;
        self.coordinateMapping["e4"] = 12;
        self.coordinateMapping["f4"] = 13;
        self.coordinateMapping["g4"] = 14;
        self.coordinateMapping["c5"] = 15;
        self.coordinateMapping["d5"] = 16;
        self.coordinateMapping["e5"] = 17;
        self.coordinateMapping["b6"] = 18;
        self.coordinateMapping["d6"] = 19;
        self.coordinateMapping["f6"] = 20;
        self.coordinateMapping["a7"] = 21;
        self.coordinateMapping["d7"] = 22;
        self.coordinateMapping["g7"] = 23;
    }

    public func getPlayerColors() -> (Color, Color) {
        var colorPlayer1: Color = Color.black; // TODO this should be initialized directly without this initial black value
        var colorPlayer2: Color = Color.black;

        print("Please enter the color of the pools for player 1 [black/white]:")
        while let choice = readLine() {
            let lowerCased = choice.lowercased()
            
            if let color = Color(rawValue: lowerCased) {
                colorPlayer1 = color;
                switch color {
                case .black:
                    colorPlayer2 = Color.white
                case .white:
                    colorPlayer2 = Color.black
                }
                break;
            } else {
                print("Invalid choice, please enter either [black/white]")
            }
        }

        print("");
        print("The game has started!");
        print("Player 1 has the \(colorPlayer1) color")
        print("Player 2 has the \(colorPlayer2) color")

        return (colorPlayer1, colorPlayer2)
    }

    public func getPlaceCoordinates() -> (Int) {

        print("Please enter coordinate for piece placement:")

        if let input = readLine(), let numericCoordinate = self.coordinateMapping[input] {
            return numericCoordinate;
        }

        // TODO IOException can be thrown here?

        return -1;
    }

    public func getMoveCoordinates() -> (Int, Int) {
        if let input = readLine(), 
        input.count == 4, 
        let numericCoordinate1 = self.coordinateMapping[String(input.prefix(2))], 
        let numericCoordinate2 = self.coordinateMapping[String(input.suffix(2))] {
            return (numericCoordinate1, numericCoordinate2);
        }

        return (-1, -1)
    }

        // public func getPlaceCoordinates() -> (Character, Int) {
        //     var firstCoordinate: Character = "a";
        //     var secondCoordinate: Int = -1;

        //     print("Please enter coordinate for piece placement:")

        //     if let input = readLine() {
        //         if input.count != 2 || Int(input[0].asciiValue! - Character("a").asciiValue!) < 0 || 
        //         Int(input[0].asciiValue! - Character("a").asciiValue!) > 6 ||
        //         !input[1].isWholeNumber || input[1].wholeNumberValue! < 1 || input[1].wholeNumberValue! > 7 {
        //             print("Invalid input! Will throw something here later on!");
        //         }

        //         firstCoordinate = input[0];
        //         secondCoordinate = input[1].wholeNumberValue!;
        //     }

        //     // TODO IOException can be thrown here?

        //     return (firstCoordinate, secondCoordinate)
        // }
}