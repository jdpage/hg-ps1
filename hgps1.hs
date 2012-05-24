import Data.Functor
import System.Directory
import System.Environment
import System.FilePath
import System.IO
import Text.Printf

charsToHex :: [Char] -> String
charsToHex = foldl (printf "%s%02x") ""

failAsNothing :: IO a -> IO (Maybe a)
failAsNothing a = catch (Just <$> a) $ const $ return Nothing

getCurrentRevision :: String -> IO (Maybe String)
getCurrentRevision repopath =
    failAsNothing $ withBinaryFile statefile ReadMode getHash
    where
        statefile = repopath </> ".hg" </> "dirstate"
        getHash h = hGetContents h >>=
            ($!) return . charsToHex . take 20

getCurrentBranch :: String -> IO String
getCurrentBranch repopath =
    catch (withFile branchfile ReadMode hGetLine) $ const $ return "default"
    where
        branchfile = repopath </> ".hg" </> "branch"

reduceToRepo :: String -> IO (Maybe String)
reduceToRepo pwd = do
    m <- doesDirectoryExist $ pwd </> ".hg"
    if m
        then return $ Just pwd
        else if isDrive pwd
            then return Nothing
            else reduceToRepo $ takeDirectory pwd

displayRev :: Maybe String -> String
displayRev (Just r) = take 12 r
displayRev Nothing = take 12 $ repeat '?'

getFormat :: [String] -> String
getFormat [] = ":%s:%s"
getFormat args = head args

main :: IO ()
main = getCurrentDirectory >>= reduceToRepo >>= disp'
    where
        disp' Nothing = return ()
        disp' (Just repo) = do
            fmt <- getFormat <$> getArgs
            rev <- getCurrentRevision repo
            branch <- getCurrentBranch repo
            hPrintf stdout fmt branch (displayRev rev)

