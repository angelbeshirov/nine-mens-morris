struct BoardConstants {

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

    static let nodeNeighbours = [
        [1, 9],
        [0, 2, 4],
        [1, 14],
        [4, 10],
        [1, 3, 5, 7],
        [4, 13],
        [7, 11],
        [4, 6, 8],
        [7, 12],
        [0, 10, 21],
        [3, 9, 11, 18],
        [6, 10, 15],
        [8, 13, 17],
        [5, 12, 14, 20],
        [2, 13, 23],
        [11, 16],
        [15, 17, 19],
        [12, 16],
        [10, 19],
        [16, 18, 20, 22],
        [13, 19],
        [9, 22],
        [19, 21, 23],
        [14, 22]
    ]
    
    static let millIndices = [
        // Horizontal mills
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [9, 10, 11],
        [12, 13, 14],
        [15, 16, 17],
        [18, 19, 20],
        [21, 22, 23],
        [0, 9, 21], // Vertical mills
        [3, 10, 18],
        [6, 11, 15],
        [1, 4, 7],
        [16, 19, 22],
        [8, 12, 17],
        [5, 13, 20],
        [2, 14, 23]
    ]

    static let range = (0...23);
}

struct GameConstants {
    
}

struct ErrorMessages {
    static let ioError = "IO ERROR TODO FIX TEXT"
}