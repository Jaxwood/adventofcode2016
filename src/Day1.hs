module Day1 (resulta, resultb) where

  import Data.List.Split
  import qualified Data.Text as T

  data Move = R Int | L Int
  data Position = Position Int Int
  data Pole = North | South | East | West
  data Coord = Coord Position Pole

  resulta :: String -> Int
  resulta = blocks . head . calculate . moves

  resultb :: String -> Int
  resultb str = 0

  blocks :: Coord -> Int
  blocks (Coord (Position x y) _) =
    (abs x) + (abs y)
  
  path :: Position -> Position -> [(Int, Int)]
  path (Position x y) (Position x' y') 
    | x == x' = map (\y'' -> (x, y'')) [y..y']
    | otherwise = map (\x'' -> (x'', y)) [x..x']

  calculate :: [Move] -> [Coord]
  calculate = foldl acc []

  acc :: [Coord] -> Move -> [Coord]
  acc [] (L a) =
    [(Coord (Position (0-a) 0) West)]

  acc [] (R a) =
    [(Coord (Position a 0) East)]

  acc lst@((Coord (Position x y) North):xs) (L a) =
    (Coord (Position (x-a) y) West):lst

  acc lst@((Coord (Position x y) North):xs) (R a) =
    (Coord (Position (x+a) y) East):lst

  acc lst@((Coord (Position x y) South):xs) (L a) =
    (Coord (Position (x+a) y) East):lst

  acc lst@((Coord (Position x y) South):xs) (R a) =
    (Coord (Position (x-a) y) West):lst

  acc lst@((Coord (Position x y) East):xs) (R a) =
    (Coord (Position x (y-a)) South):lst

  acc lst@((Coord (Position x y) East):xs) (L a) =
    (Coord (Position x (y+a)) North):lst

  acc lst@((Coord (Position x y) West):xs)(R a) =
    (Coord (Position x (y+a)) North):lst

  acc lst@((Coord (Position x y) West):xs) (L a) =
    (Coord (Position x (y-a)) South):lst

  moves :: String -> [Move]
  moves = map move . parseInput

  move :: String -> Move
  move (x:xs) 
    | x == 'R' = R (read xs)
    | otherwise = L (read xs)

  parseInput :: String -> [String]
  parseInput = map trim . splitOn ","
  
  trim :: String -> String
  trim = T.unpack . T.strip . T.pack 
