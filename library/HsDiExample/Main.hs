module HsDiExample.Main where

import            DI
import            Prelude                   hiding (readFile)
import            Data.Time                 (getCurrentTime, diffUTCTime)
import qualified  Data.Text                 as T
import qualified  Data.Text.IO              as T
import            Data.Text.IO              (readFile)
import            Data.Semigroup            ((<>))
import            System.Environment        (getArgs)

injLeaf "getCurrentTime"
injLeaf "getArgs"
injLeaf "readFile"

injAllG

logger :: T.Text -> IO ()
loggerI = T.putStrLn

main :: IO ()
mainI getCurrentTime getArgs readFile logger = do
  startTime <- getCurrentTime
  [fileName] <- getArgs
  target <- readFile fileName
  logger $ "Hello, " <> target <> "!"
  endTime <- getCurrentTime
  let duration = endTime `diffUTCTime` startTime
  logger $ T.pack (show (round (duration * 1000) :: Integer)) <> " milliseconds"
