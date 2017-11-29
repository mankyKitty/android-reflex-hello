{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
module FrontEnd (frontendWidget) where

import           Control.Lens                       ((^.))
import           Control.Monad                      (void, when)

import           Data.Text                          (Text)

import qualified Reflex                             as R

import           Reflex.Dom                         (MonadWidget)
import qualified Reflex.Dom                         as RD

import           Language.Javascript.JSaddle        (JSM, JSVal, liftJSM)
import           Language.Javascript.JSaddle.Run    (enableLogging)
import           Language.Javascript.JSaddle.String (JSString)
import           Language.Javascript.JSaddle.Value  (JSValue (ValString),
                                                     valToStr)

import           Language.Javascript.JSaddle.Object (js, (!), ( # ))
import qualified Language.Javascript.JSaddle.Object as JS

data NotifyPerm
  = Def
  | Granted
  | Denied
  deriving Show

notify
  :: JSM ( Maybe NotifyPerm )
notify = do
  let notifyP, permP, grantS, consoleO, logP, requestP :: JSString
      notifyP  = "Notification"
      permP    = "permission"
      grantS   = "granted"
      requestP = "requestPermission"

      consoleO = "console"
      logP     = "log"

      msg = "What up, Reflex?"

      newNotify =
        JS.new ( JS.jsg notifyP ) ( ValString msg )

  permS <- valToStr =<< JS.global ^. js notifyP . js permP
  case permS of
    "granted" -> void newNotify >> pure ( Just Granted )
    "denied"  -> pure ( Just Denied )
    "default" -> do
      void $ ( JS.jsg notifyP ) ^. JS.jsf requestP
        [JS.fun $ \_ _ [newPerm] -> do
            np <- valToStr newPerm
            when ( np == grantS ) $
              void newNotify
        ]
      pure ( Just Def )
    _ -> pure Nothing

frontendWidget :: MonadWidget t m => m ()
frontendWidget = do
  let
    txConf = RD.TextInputConfig "text" "" R.never mempty

  dInput <- RD._textInput_value <$> RD.textInput txConf
  RD.divClass "input-result" $
    RD.dynText dInput

  RD.divClass "notification-test" $ do
    eNotify <- RD.button "Notify Meh"
    eNotifyPerm <- RD.performEvent ( liftJSM notify <$ eNotify )

    RD.holdDyn Nothing eNotifyPerm
      >>= RD.display
