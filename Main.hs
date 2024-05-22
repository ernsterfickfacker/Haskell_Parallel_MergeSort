import Control.Parallel.Strategies (parMap, rpar, rseq, withStrategy, using, runEval)
import Control.Parallel (par, pseq)
import System.IO (readFile, writeFile)
import Data.List (sort)
import Control.DeepSeq (deepseq)
import Control.Exception (evaluate)
import Data.Time.Clock (getCurrentTime, diffUTCTime)
import Text.Printf (printf)
import System.Environment (getArgs)
--import System.CPUTime (getCPUTime)--

merge :: (Ord arr) => [arr] -> [arr] -> [arr]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y    = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

mergeSort :: (Ord arr) => [arr] -> [arr]
mergeSort xs
  | length xs <= 1 = xs
  | otherwise = runEval $ do
      let (left, right) = splitAt (length xs `div` 2) xs
      leftSorted <- rpar (mergeSort left)
      rightSorted <- rpar (mergeSort right)
      rseq leftSorted
      rseq rightSorted
      return (merge leftSorted rightSorted)

readArrayFromFile :: FilePath -> IO [Int]
readArrayFromFile path = do
  content <- readFile path
  let array = map read (words content) :: [Int]
  evaluate (deepseq array array)
  return array

writeArrayToFile :: FilePath -> [Int] -> IO ()
writeArrayToFile path array = writeFile path (unwords (map show array))

main :: IO ()
main = do
  args <- getArgs
  let (inputFile, outputFile) = case args of
        [arg1, arg2] -> (arg1, arg2)
        _ -> error "ERROR when working with files"

  array <- readArrayFromFile inputFile
  start <- getCurrentTime
  --start1 <- getCPUTime
  printf "\nstart: %s\n" (show start)
  --printf "\nstart1: %0.12f seconds\n" (fromIntegral start1 / (10^12) :: Double)--
  let sortedArray = mergeSort array
  end <- getCurrentTime
  --end1 <- getCPUTime
  printf "\nend: %s\n" (show end)
  let dt = realToFrac (diffUTCTime end start) :: Double
  printf "\nTime taken (real time): %0.12f seconds\n" dt
  --printf "\nend1: %0.12f seconds\n" (fromIntegral end1 / (10^12) :: Double)--
  writeArrayToFile outputFile sortedArray
  printf "\nThe array is written to a file\n" 
  --let dt = realToFrac (diffUTCTime end start) :: Double--
  --printf "\nTime taken (real time): %0.12f seconds\n" dt--
  --let dt1 = fromIntegral (end1 - start1) / (10^12) :: Double--
  --printf "\nTime taken (CPU time): %0.12f seconds\n" dt1--
