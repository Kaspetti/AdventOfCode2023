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


main :: IO()
main = do
  input <- readFile "input"
  let symbolGrid = getSymbolGrid input
  print $ sumParts input symbolGrid
