{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module FrontEnd
  ( frontendWidget
  ) where

import Reflex.Dom (MonadWidget)
import qualified Reflex.Dom as RD

import Language.Javascript.JSaddle (liftJSM)

import Notify (tryNotify)

frontendWidget :: MonadWidget t m => m ()
frontendWidget = do
  let txConf = RD.TextInputConfig "text" "" RD.never mempty
  dInput <- RD._textInput_value <$> RD.textInput txConf
  RD.divClass "input-result" $ RD.dynText dInput
  RD.divClass "notification-test" $ do
    eNotify <- RD.button "Notify Meh"
    eNotifyPerm <- RD.performEvent $ liftJSM (tryNotify "What up, Reflex") <$ eNotify
    RD.holdDyn Nothing eNotifyPerm >>= RD.display
