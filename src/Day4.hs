module Day4 (resulta, resultb) where
  
  import Text.Parsec
  import Text.Parsec.String

  type Name = String
  type Sector = Int
  type Checksum = String
  data Room = Room Name Sector Checksum deriving (Eq, Show)

  resulta :: String -> Int
  resulta str = 0

  resultb :: String -> Int
  resultb str = 0

  parseInputResult :: String -> Either ParseError Room
  parseInputResult = parse parseInput ""

  parseInput :: Parser Room
  parseInput = do
    name <- endBy (many letter) (char '-')
    sector <- many digit
    _ <- char '['
    checksum <- many1 letter
    return $ Room (concat name) (read sector) checksum
