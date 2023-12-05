import Data.Char
import Data.Maybe (fromMaybe)
import Text.Read


type SymbolGrid = [((Int, Int), Bool)]

getSymbolGrid :: String -> SymbolGrid
getSymbolGrid input = getSymbolGrid' input 0 0
  where getSymbolGrid' :: String -> Int -> Int -> SymbolGrid
        getSymbolGrid' [] _ _ = []
        getSymbolGrid' (c:cs) x y | isDigit c || c == '.' = ((x, y), False) : getSymbolGrid' cs (x+1) y
                                  | c == '\n' = getSymbolGrid' cs 0 (y+1)
                                  | otherwise = ((x, y), True) : getSymbolGrid' cs (x+1) y


sumParts :: String -> SymbolGrid -> Int
sumParts input symbolGrid = sumParts' input symbolGrid 0 0 "" False
  where sumParts' [] _ _ _ num isPart = if isPart then fromMaybe 0 (readMaybe num) else 0
        sumParts' (c:cs) symbolGrid x y num isPart 
          | isDigit c = 
            sumParts' cs symbolGrid (x+1) y (num++[c]) (isPart || isSymbolNeighbour (x, y) symbolGrid)
          | c == '\n' = 
            if isPart then
              fromMaybe 0 (readMaybe num) + sumParts' cs symbolGrid 0 (y+1) "" False
            else
              sumParts' cs symbolGrid 0 (y+1) "" False
          | otherwise = 
            if isPart then
              fromMaybe 0 (readMaybe num) + sumParts' cs symbolGrid (x+1) y "" False
            else
              sumParts' cs symbolGrid (x+1) y "" False


isSymbolNeighbour :: (Int, Int) -> SymbolGrid -> Bool
isSymbolNeighbour (x, y) symbolGrid = 
  fromMaybe False (lookup (x, y+1) symbolGrid) ||
  fromMaybe False (lookup (x, y-1) symbolGrid) ||
  fromMaybe False (lookup (x+1, y) symbolGrid) ||
  fromMaybe False (lookup (x+1, y+1) symbolGrid) ||
  fromMaybe False (lookup (x+1, y-1) symbolGrid) ||
  fromMaybe False (lookup (x-1, y) symbolGrid) ||
  fromMaybe False (lookup (x-1, y+1) symbolGrid) ||
  fromMaybe False (lookup (x-1, y-1) symbolGrid)


type NumbersGrid = [((Int, Int), Int)]

getNumbersGrid :: String -> NumbersGrid
getNumbersGrid input = getNumbersGrid' input "" 0 0 
  where
    getNumbersGrid' :: String -> String -> Int -> Int -> NumbersGrid
    getNumbersGrid' [] curNum x y = [((x-1, y), fromMaybe 0 (readMaybe curNum)) | not (null curNum)]
    getNumbersGrid' (c:cs) curNum x y | isDigit c = getNumbersGrid' cs (curNum++[c]) (x+1) y
                                      | c == '\n' = 
                                        if not (null curNum) then
                                          ((x-1, y), fromMaybe 0 (readMaybe curNum)) : getNumbersGrid' cs "" 0 (y+1)
                                        else
                                          getNumbersGrid' cs "" 0 (y+1)
                                      | otherwise = if not (null curNum) then
                                          ((x-1, y), fromMaybe 0 (readMaybe curNum)) : getNumbersGrid' cs "" (x+1) y
                                        else
                                          getNumbersGrid' cs "" (x+1) y


getGearRatios :: String -> NumbersGrid -> Int
getGearRatios input numbersGrid = getGears input numbersGrid 0 0
  where
    getGears :: String -> NumbersGrid -> Int -> Int -> Int
    getGears [] _ _ _ = 0
    getGears (c:cs) numbersGrid x y | c == '*' = 
                                      let neighbours = getNumberNeighbours (x, y) numbersGrid
                                      in
                                        if length neighbours == 2 then
                                          product neighbours + getGears cs numbersGrid (x+1) y
                                        else
                                          getGears cs numbersGrid (x+1) y
                                    | c == '\n' = getGears cs numbersGrid 0 (y+1)
                                    | otherwise = getGears cs numbersGrid (x+1) y


getNumberNeighbours :: (Int, Int) -> NumbersGrid -> [Int]
getNumberNeighbours (x, y) numbersGrid = getNumberNeighbours' (x, y) (-1) (-1) numbersGrid
  where
    getNumberNeighbours' :: (Int, Int) -> Int -> Int -> NumbersGrid -> [Int]
    getNumberNeighbours' (x, y) 4 cy numbersGrid = getNumberNeighbours' (x, y) (-1) (cy+1) numbersGrid
    getNumberNeighbours' _ _ 2 _ = []
    getNumberNeighbours' (x, y) cx cy numbersGrid | cx == 0 && cy == 0 = getNumberNeighbours' (x, y) 1 cy numbersGrid
                                                  | otherwise =
                                                      let neighbour = fromMaybe (-1) (lookup (x + cx, y + cy) numbersGrid)
                                                      in
                                                        if neighbour == -1 || length (show neighbour) < cx then
                                                          getNumberNeighbours' (x, y) (cx+1) cy numbersGrid
                                                        else
                                                          neighbour : getNumberNeighbours' (x, y) (cx+1) cy numbersGrid


main :: IO()
main = do
  input <- readFile "input"
  let symbolGrid = getSymbolGrid input
  print $ sumParts input symbolGrid
  let numbersGrid = getNumbersGrid input
  print $ getGearRatios input numbersGrid
