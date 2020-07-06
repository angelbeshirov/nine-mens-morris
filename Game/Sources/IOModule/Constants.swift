// Here constants for the classes in this module are defined.
// All constants are defined in a internal struct added by an extension
// for the particular class. This way we won't have some random
// structs defined at the global level thus polluting it.
extension ConsoleInputHandler 
{
    struct Constants 
    {
        // mapping from 2d to 1d coordinates
        static let coordinateMapping = [
            "a1": 0,
            "d1": 1,
            "g1": 2,
            "b2": 3,
            "d2": 4,
            "f2": 5,
            "c3": 6,
            "d3": 7,
            "e3": 8,
            "a4": 9,
            "b4": 10,
            "c4": 11,
            "e4": 12,
            "f4": 13,
            "g4": 14,
            "c5": 15,
            "d5": 16,
            "e5": 17,
            "b6": 18,
            "d6": 19,
            "f6": 20,
            "a7": 21,
            "d7": 22,
            "g7": 23
        ]

        // Console messages
        static let enterColorsPrompt = "Please enter the color of the pools for player 1 [black/white]:"
        static let invalidColors = "Invalid input for initial colors, please enter either [black/white]."
        static let invalidCoordinates = "The coordinates you have entered do not exist on this board, please try again!"
    }
}