{-# options_ghc -fdefer-type-errors #-}

module MTLStyleExample.Main where

import qualified Data.Text as T
import qualified Data.Text.IO as T

import Prelude hiding (readFile)

import Data.Semigroup ((<>))
import Data.Time.Clock (diffUTCTime)
import Data.Time (getCurrentTime)

import System.Environment (getArgs)

import DI

injLeaf "getCurrentTime"
injLeaf "getArgs"

injAllG

logger :: T.Text -> IO ()
loggerI = T.putStrLn

readFileI = T.readFile

--------------------------------------------------------------------------------
-- Logic

main :: IO ()
mainI getCurrentTime getArgs readFile logger = do
  startTime <- getCurrentTime
  [fileName] <- getArgs
  target <- readFile fileName
  logger $ "Hello, " <> target <> "!"
  endTime <- getCurrentTime
  let duration = endTime `diffUTCTime` startTime
  logger $ T.pack (show (round (duration * 1000) :: Integer)) <> " milliseconds"
