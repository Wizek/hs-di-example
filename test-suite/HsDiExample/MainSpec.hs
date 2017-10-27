module HsDiExample.MainSpec where

import            DI                        (assemble, override)
import            Data.Time                 (UTCTime, utctDay, addUTCTime)
import            Test.Hspec
import            Data.IORef                (newIORef, modifyIORef, readIORef)
import            Data.Function             ((&))
import            HsDiExample.Main          (mainD, mainT)
import            Data.Functor.Identity     (runIdentity)
import            Data.Time.Clock.POSIX     (posixSecondsToUTCTime)
import            Text.InterpolatedString.Perl6 (qc)

spec :: Spec
spec = describe "main" $ do

  logMessages <- runIO $ do
    logs <- newIORef []
    clockStart <- newIORef $ posixSecondsToUTCTime 0

    $(mainD
      & override "logger"         [qc| \a -> modifyIORef logs (++ [a]) |]
      & override "getArgs"        [qc| return ["sample.txt"] |]
      & override "readFile"       [qc| \"sample.txt" -> return "Alyssa" |]
      & override "getCurrentTime" [qc| readModifyIORef clockStart (addUTCTime 1) |]
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
