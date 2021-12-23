module Main

import Control.App
import Data.List
import Data.String.Parser

record Input where
  constructor MkInput
  minX, maxX : Integer
  minY, maxY : Integer

expr : Parser Input
expr = do
  _ <- string "target area: x="
  minX <- integer
  _ <- string ".."
  maxX <- integer
  _ <- string ", y="
  minY <- integer
  _ <- string ".."
  maxY <- integer
  eos
  pure $ MkInput minX maxX minY maxY

readInput : IO (Either String Input)
readInput = do
  line <- getLine
  case parse expr line of
    Left err => pure $ Left err
    Right (input, _) => pure $ Right input

hits : Input -> (Integer, Integer) -> (Integer, Integer) -> Bool
hits input (x, y) (vx, vy) =
  if x > input.maxX then False else
  if x < input.minX && vx == 0 then False else
  if y < input.minY then False else
  if x >= input.minX && y <= input.maxY then True else
  hits input (x + vx, y + vy) (max (vx - 1) 0, vy - 1)

main : IO ()
main = do
  input <- readInput
  case input of
    Left err => putStrLn err
    Right input => do
      -- Part 1
      let maxYvel = -input.minY - 1
      printLn $ maxYvel * (maxYvel + 1) `div` 2
      -- Part 2
      let velocities = [(x, y) | x <- [1..input.maxX], y <- [input.minY..maxYvel]]
      let valid = filter (hits input (0, 0)) velocities
      printLn $ length valid
