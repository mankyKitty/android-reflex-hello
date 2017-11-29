module Main where

import           Language.Javascript.JSaddle.Warp (run)
import           Reflex.Dom.Core                  (mainWidget)

import           FrontEnd                         (frontendWidget)

main :: IO ()
main = run 9999 (mainWidget frontendWidget)
