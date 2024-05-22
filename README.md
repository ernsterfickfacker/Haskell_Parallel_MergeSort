# Parallel Merge Sort using parMap in Haskell

PS C:\ghcup\ghc\myproject> cabal build

cabal run myproject "inpe6.txt" "oute6.txt"

## Building the program:
ghc -threaded -feager-blackholing --make .\Main.hs

PS C:\ghcup\ghc\myproject\app> .\Main.exe ".\inpe4.txt" ".\oute4.txt" +RTS -N4 4-number of logical kernell


## Additional:
PS C:\ghcup\ghc\myproject> cabal run exes -- Oren 13 10

PS C:\ghcup\ghc\myproject> cabal clean

PS C:\ghcup\ghc\myproject> cabal update


## If the error is in import Control.Parallel.Strategies (parMap, rpar, rseq, withStrategy, using, runEval) / import Control.Parallel (par, pseq)
add in myproject.cabal
 build-depends:    base ^>=4.17.2.1,
					  parallel >=3.2.2.0,
					  deepseq >=1.4.8.0,
					  time >=1.9.3
