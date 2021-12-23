module Main where

import Control.Monad (void)
import Data.List (tails)
import Data.Maybe (fromMaybe)
import GHC.IO.Handle.FD (stderr)
import System.Exit (ExitCode (ExitFailure), exitWith)
import System.IO (hPrint)
import Text.Parsec (char, digit, many1, parse, try, (<|>))
import Text.Parsec.String (Parser)

-- | Represents a snailfish number tree.
data Tree
  = Lit Integer
  | Node Tree Tree
  deriving (Eq)

instance Show Tree where
  show (Lit x) = show x
  show (Node a b) = "[" ++ show a ++ "," ++ show b ++ "]"

litE :: Parser Tree
litE = do
  n <- many1 digit
  pure $ Lit (read n)

nodeE :: Parser Tree
nodeE = do
  void $ char '['
  left <- treeE
  void $ char ','
  right <- treeE
  void $ char ']'
  pure $ Node left right

treeE :: Parser Tree
treeE = litE <|> nodeE

parseOrExit :: String -> IO Tree
parseOrExit s = case parse treeE "<input>" s of
  Left pe -> do
    hPrint stderr pe
    exitWith (ExitFailure 1)
  Right tr -> pure tr

treeSum :: Tree -> Tree -> Tree
treeSum a b = treeReduce $ Node a b

treeReduce :: Tree -> Tree
treeReduce n =
  let n' = treeReduce1 n
   in if n == n' then n else treeReduce n'

treeReduce1 :: Tree -> Tree
treeReduce1 n =
  case explode 0 n of
    Just (m, _) -> m
    Nothing -> fromMaybe n (split1 n)

explode :: Int -> Tree -> Maybe (Tree, (Integer, Integer))
explode d (Lit x) = Nothing
explode 4 (Node (Lit x) (Lit y)) = Just (Lit 0, (x, y))
explode d (Node left right) =
  case explode (d + 1) left of
    Just (t, (carryL, carryR)) ->
      Just (Node t (addFirst carryR right), (carryL, 0))
    Nothing -> do
      (t, (carryL, carryR)) <- explode (d + 1) right
      pure (Node (addLast carryL left) t, (0, carryR))

split1 :: Tree -> Maybe Tree
split1 (Lit x) =
  if x >= 10
    then Just $ Node (Lit (x `div` 2)) (Lit ((x + 1) `div` 2))
    else Nothing
split1 (Node left right) =
  case split1 left of
    Just t -> Just $ Node t right
    Nothing -> do
      t <- split1 right
      pure $ Node left t

addFirst :: Integer -> Tree -> Tree
addFirst 0 t = t
addFirst n t = case t of
  Lit x -> Lit $ x + n
  Node a b -> Node (addFirst n a) b

addLast :: Integer -> Tree -> Tree
addLast 0 t = t
addLast n t = case t of
  Lit x -> Lit $ x + n
  Node a b -> Node a (addLast n b)

magnitude :: Tree -> Integer
magnitude (Lit x) = x
magnitude (Node left right) =
  3 * magnitude left + 2 * magnitude right

pairs :: [a] -> [(a, a)]
pairs l = [p | (x : ys) <- tails l, y <- ys, p <- [(x, y), (y, x)]]

main :: IO ()
main = do
  inp <- getContents
  trees <- mapM parseOrExit $ lines inp
  let result = foldl1 treeSum trees
  print $ magnitude result
  let ans = maximum [magnitude $ treeSum a b | (a, b) <- pairs trees]
  print ans
