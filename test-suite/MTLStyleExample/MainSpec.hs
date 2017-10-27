{-# options_ghc -fdefer-type-errors #-}

module MTLStyleExample.MainSpec where

import Data.Function ((&))
import Data.Functor.Identity (runIdentity)
import Data.Time.Clock.POSIX (posixSecondsToUTCTime)
import Test.Hspec

import MTLStyleExample.Main
import MTLStyleExample.Test.Stubs

import Data.IORef (newIORef, modifyIORef, readIORef)
import Data.Time (UTCTime, utctDay, addUTCTime)

import DI (assemble, override)


spec :: Spec
spec = describe "main" $ do
  logMessages <- runIO $ do
    logs <- newIORef []
    clockStart <- newIORef $ posixSecondsToUTCTime 0
    $(mainD
      & override "logger" "\\a -> modifyIORef logs (++ [a])"
      & override "getArgs" "return [\"foo\"]"
      & override "readFile" "\\_ -> return \"Alyssa\""
      & override "getCurrentTime" "readModifyIORef clockStart (addUTCTime 1)"
      & assemble)
    readIORef logs

  it "prints two log messages" $
    length logMessages `shouldBe` 2

  it "prints a greeting as the first message" $
    (logMessages !! 0) `shouldBe` "Hello, Alyssa!"

  it "prints the elapsed time in milliseconds as the second message" $
    (logMessages !! 1) `shouldBe` "1000 milliseconds"

readModifyIORef ref phi = do
  val <- readIORef ref
  modifyIORef ref phi
  return val

noop = return ()
