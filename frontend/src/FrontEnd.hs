{-# LANGUAGE OverloadedStrings #-}
module FrontEnd (frontendWidget) where

import qualified Reflex as R

import           Reflex.Dom (MonadWidget)
import qualified Reflex.Dom as RD

frontendWidget
  :: MonadWidget t m
  => m ()
frontendWidget = do
  let
    txConf = RD.TextInputConfig "text" "" R.never mempty

  dInput <- RD._textInput_value <$> RD.textInput txConf
  RD.divClass "input-result" $
    RD.dynText dInput
