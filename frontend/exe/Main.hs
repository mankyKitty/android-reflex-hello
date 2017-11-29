module Main where

import           Reflex.Dom (mainWidget)

import           FrontEnd   (frontendWidget)

main :: IO ()
main = mainWidget frontendWidget
