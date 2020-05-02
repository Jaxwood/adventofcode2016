module Day21 (resulta) where

  import Data.List (findIndex, foldl')
  import Data.Maybe

  data Direction = L | R deriving (Eq,Show)

  data Instruction =
    Rotate Char |
    Move Int Int |
    RotateLeftRight Direction Int |
    Reverse Int Int |
    SwapPosition Int Int |
    SwapLetter Char Char deriving (Eq,Show)

  swapPosition :: Instruction -> String -> String
  swapPosition (SwapPosition x y) candidate =
    zipWith swapper candidate [0..]
    where swapper = (\c i -> if i == x then y' else if i == y then x' else c)
          x' = candidate !! x
          y' = candidate !! y

  swapLetter :: Instruction -> String -> String
  swapLetter (SwapLetter x y) candidate =
    map swapper candidate
    where swapper = (\c -> if c == x then y else if c == y then x else c)
  
  reversePosition :: Instruction -> String -> String
  reversePosition (Reverse x y) candidate =
    f ++ (reverse $ take (succ y) $ drop x candidate) ++ b
    where f = take x candidate
          b = drop (succ y) candidate

  rotateLeftRight :: Instruction -> String -> String
  rotateLeftRight (RotateLeftRight d steps) candidate
    | d == L = take len $ drop steps $ cycle candidate
    | d == R = take len $ drop (len' - steps) $ cycle candidate
    where len = length candidate
          len' = if len > steps then len else len * (steps `div` len + 1)

  move :: Instruction -> String -> String
  move (Move x y) candidate = snd $
    foldr (\c (i, acc) ->
      if x == i then (pred i, acc)
      else if y == i then (pred i, if x < y then c:x':acc else x':c:acc)
      else (pred i, c:acc)) (len, "") candidate
    where x' = candidate !! x
          len = length candidate - 1

  rotate :: Instruction -> String -> String
  rotate (Rotate x) candidate = 
    rotateLeftRight (RotateLeftRight R idx') candidate
    where idx = fromJust $ findIndex (==x) candidate
          idx' = if idx >= 4 then idx + 2 else idx + 1
          
  run :: String -> Instruction -> String
  run s (SwapPosition x y) = swapPosition (SwapPosition x y) s
  run s (SwapLetter x y) = swapLetter (SwapLetter x y) s
  run s (Reverse x y) = reversePosition (Reverse x y) s
  run s (RotateLeftRight x y) = rotateLeftRight (RotateLeftRight x y) s
  run s (Move x y) = move (Move x y) s
  run s (Rotate x) = rotate (Rotate x) s

  toInt :: String -> Int
  toInt = read

  toChar :: String -> Char
  toChar = head

  parse :: String -> Instruction
  parse s =
    case words s of
      ("move":xs) -> (Move (toInt (xs !! 1)) (toInt (xs !! 4)))
      ("reverse":xs) -> (Reverse (toInt (xs !! 1)) (toInt (xs !! 3)))
      ("swap":"position":xs) -> (SwapPosition (toInt (xs !! 0)) (toInt (xs !! 3))) 
      ("swap":"letter":xs) -> (SwapLetter (toChar (xs !! 0)) (toChar (xs !! 3))) 
      ("rotate":"based":xs) -> (Rotate (toChar (xs !! 4)))
      ("rotate":"right":xs) -> (RotateLeftRight R (toInt (xs !! 0)))
      ("rotate":"left":xs) -> (RotateLeftRight L (toInt (xs !! 0)))
    where ws = words s

  resulta :: String -> String -> String
  resulta input password = foldl' run password instructions
    where instructions = map parse $ lines input
