{-# LANGUAGE ViewPatterns #-}

import qualified Data.Map as Map
import Data.Foldable (toList)
import System.Environment (getArgs)

data Instr = Instr String Int String (Int -> Bool)

parseLine :: String -> Instr
parseLine (words -> r:f:u:_:c:o:x:_) = Instr r (f' (read u)) c (`op` read x)
    where
        f' = case f of
            "dec" -> negate
            _     -> id
        op = case o of
            "!=" -> (/=)
            "==" -> (==)
            "<=" -> (<=)
            ">=" -> (>=)
            "<"  -> (<)
            ">"  -> (>)
            _    -> undefined

execInstr :: Map.Map String Int -> Instr -> Map.Map String Int
execInstr m (Instr r u ce cf) | cf (Map.findWithDefault 0 ce m) = Map.insertWith (+) r u m
                              | otherwise = m

main :: IO()
main = do
    filename:_ <- getArgs
    contents <- readFile filename
    let instructions = map parseLine $ lines contents
    putStr "Largest value: "
    print $ maximum $ foldl execInstr Map.empty instructions
    putStr "Highest value during execution: "
    print $ maximum $ foldMap toList $ scanl execInstr Map.empty instructions
