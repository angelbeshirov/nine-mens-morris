struct GameLib {
    public init(text: String = "") {
       self.text = text
   }
   
   /// Make this property public accessible
   public var text = "Hello, World!"

   public let version = "alpha-1"
}
