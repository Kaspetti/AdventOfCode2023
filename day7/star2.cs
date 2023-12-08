using System.Text;

class Star2 {
    enum Type {
        FIVE_OF_A_KIND = 7,
        FOUR_OF_A_KIND = 6,
        FULL_HOUSE = 5,
        THREE_OF_A_KIND = 4,
        TWO_PAIR = 3,
        ONE_PAIR = 2,
        HIGH_CARD = 1
    }


    // Dictionary to map card ranks to a descending alphabetical order in order to sort it
    static readonly Dictionary<char, char> _mapCards = new Dictionary<char, char>(){
        {'A', 'A'},
        {'K', 'B'},
        {'Q', 'C'},
        {'T', 'D'},
        {'9', 'E'},
        {'8', 'F'},
        {'7', 'G'},
        {'6', 'H'},
        {'5', 'I'},
        {'4', 'J'},
        {'3', 'K'},
        {'2', 'L'},
        {'J', 'M'},
    };


    static void Main(string[] args) {
        using(StreamReader file = new StreamReader("input")) {
            string? line;
            var hands = new List<(Type type, string hand, int bet)>();

            while ((line = file.ReadLine()) != null) {
                hands.Add(ProcessHand(line));
            }

            hands = hands.OrderBy(o => (int)o.type).ThenByDescending(o => o.hand).ToList();

            var total = 0;
            for (var i = 0; i < hands.Count; i++) {
                total += hands[i].bet * (i+1);
            }

            Console.WriteLine(total);

            file.Close();
        }
    }


    ///<summary>
    /// Processes a hand and returns its type, the hand mapped to alphabetical order and its bet
    ///</summary>
    /// <param name="hand">The hand to process. Must be of this format: 'XXXXX NNN' where Xs are the hand and Ns are the bet</param>
    /// <returns>A tuple with the hands type, its encoded string, and its bet</returns>
    private static (Type type, string hand, int bet) ProcessHand(string hand) {
        var handBet = hand.Split(' ');
        int bet;

        try {
            bet = Int32.Parse(handBet[1]);
        } catch (Exception e) {
            throw new Exception($"Error when trying to parse {handBet[1]} into Int32: {e}");
        }

        var cardsOccurences = GetCharacterOccurences(handBet[0]);
        var handType = GetHandType(cardsOccurences);
        var encodedCards = EncodeString(handBet[0], _mapCards);

        return (handType, encodedCards, bet);
    }


    ///<summary>
    /// Counts the number of occurences of a character in a string and returns a dictionary of all counts
    ///</summary>
    ///<param name="line">The string to count occurences of</param>
    ///<returns>A dictionary of the count of all the characters in the line</returns>
    private static Dictionary<char, int> GetCharacterOccurences(string line) {
        var chars = new Dictionary<char, int>();
        foreach (var c in line) {
            if (chars.ContainsKey(c)) {
                chars[c]++;
                continue;
            }

            chars.Add(c, 1);
        }

        return chars;
    }


    ///<summary>
    ///Encodes a string given a dictionary of mappings from a character to another.
    ///</summary>
    ///<param name="line">The string to encode</param>
    ///<param name="map">A dicionary mapping characters to other characters</param>
    ///<returns>The encoded string after running it through the map</returns>
    private static string EncodeString(string line, Dictionary<char, char> map) {
        var sb = new StringBuilder();

        foreach (var c in line) {
            sb.Append(map[c]);
        }

        return sb.ToString();
    }


    ///<summary>
    ///Gets the type of a hand
    ///</summary>
    ///<param name="cards">The dicionary containing information about the count of each card rank in the hand</param>
    ///<returns>The type of the hand</returns>
    private static Type GetHandType(Dictionary<char, int> cards) {
        var highestOccurence = cards.Values.Max();
        int countJokers = 0;

        if (cards.ContainsKey('J')) {
            countJokers = cards['J'];
        }

        switch (highestOccurence) {
            case 5:
                return Type.FIVE_OF_A_KIND;
            case 4:
                return countJokers != 0 ? Type.FIVE_OF_A_KIND : Type.FOUR_OF_A_KIND;
            case 3:
                switch (countJokers) {
                    case 1:
                        return Type.FOUR_OF_A_KIND;
                    case 2:
                        return Type.FIVE_OF_A_KIND;
                    case 3:
                        return cards.Count == 2 ? Type.FIVE_OF_A_KIND : Type.FOUR_OF_A_KIND;
                    default:
                        return cards.Count == 2 ? Type.FULL_HOUSE : Type.THREE_OF_A_KIND;
                }
            case 2:
                switch (countJokers) {
                    case 1:
                        return cards.Count == 3 ? Type.FULL_HOUSE : Type.THREE_OF_A_KIND;
                    case 2:
                        return cards.Count == 3 ? Type.FOUR_OF_A_KIND : Type.THREE_OF_A_KIND;
                    default:
                        return cards.Count == 3 ? Type.TWO_PAIR : Type.ONE_PAIR;
                }
            case 1:
                return countJokers == 1 ? Type.ONE_PAIR : Type.HIGH_CARD;
        }

        return Type.HIGH_CARD;
    } 
}
