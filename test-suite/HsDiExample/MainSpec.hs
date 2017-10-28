module HsDiExample.MainSpec where

import            DI                        (assemble, override)
import qualified  Data.Map                  as M
import            Data.Time                 (UTCTime, utctDay, addUTCTime)
import            Test.Hspec
import            ComposeLTR                ((.>), ($>))
import            Data.IORef                (newIORef, modifyIORef, readIORef, IORef)
import            Data.Function             ((&))
import            Data.Semigroup            ((<>))
import            HsDiExample.Main          (mainD, mainT)
import            Data.Functor.Identity     (runIdentity)
import            Data.Time.Clock.POSIX     (posixSecondsToUTCTime)
import            Text.InterpolatedString.Perl6 (qc)

spec :: Spec
spec = describe "main" $ do

  logMessages <- runIO $ do
    logs <- newIORef []
    clockStart <- newIORef $ posixSecondsToUTCTime 0

    files <- newIORef mempty
    let
      writeFile fname fcont = modifyIORef files (<> (fname =: fcont))
      readFile fname = readIORef files <&> (
        (M.lookup fname) .> maybe (error $ "File not found: " <> fname) id)

    writeFile "sample.txt" "Alyssa"

    $(mainD
      & override "logger"         [qc| \a -> modifyIORef logs (++ [a]) |]
      & override "getArgs"        [qc| return ["sample.txt"] |]
      & override "readFile"       [qc| readFile |]
      & override "getCurrentTime" [qc| readModifyIORef clockStart (addUTCTime 1) |]
      & assemble)

    readIORef logs


  it "prints two log messages" $
    length logMessages `shouldBe` 2

  it "prints a greeting as the first message" $
    (logMessages !! 0) `shouldBe` "Hello, Alyssa!"

  it "prints the elapsed time in milliseconds as the second message" $
    (logMessages !! 1) `shouldBe` "1000 milliseconds"

(=:) = M.singleton
(<&>) = flip (<$>)

readModifyIORef :: IORef a -> (a -> a) -> IO a
readModifyIORef ref phi = do
  val <- readIORef ref
  modifyIORef ref phi
  return val

noop :: Monad m => m ()
noop = return ()
