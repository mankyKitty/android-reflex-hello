-- {-# LANGUAGE CPP #-}
module Main where

-- #ifndef ghcjs_HOST_OS
-- import           Language.Javascript.JSaddle.Warp         (run)
-- import           Reflex.Dom.Core                          (mainWidget)
-- #else
import Reflex.Dom (mainWidget)
-- #endif

import FrontEnd (frontendWidget)

main :: IO ()
main =
-- #ifndef ghcjs_HOST_OS
--   run 9999 (mainWidget frontendWidget)
-- #else
  mainWidget frontendWidget
-- #endif
