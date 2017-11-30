module Notify (tryNotify) where

import           Control.Lens                       ((^.))
import           Control.Monad                      (void, when)

import           Data.Text                          (Text, pack, unpack)

import           Language.Javascript.JSaddle        (JSM)
import           Language.Javascript.JSaddle.String (JSString, strToText)
import           Language.Javascript.JSaddle.Value  (JSValue (ValString),
                                                     valToStr)

import           Language.Javascript.JSaddle.Object (js, (!), ( # ))
import qualified Language.Javascript.JSaddle.Object as JS

data NotifyPerm
  = Def
  | Granted
  | Denied
  deriving Show

tryNotify
  :: JSM ( Maybe NotifyPerm )
tryNotify = do
  let
      msg :: Text
      msg = pack "What up, Reflex?"

      unpackJSString =
        unpack . strToText

      newNotify nObj =
        JS.new nObj ( ValString msg )

  notif <- JS.jsg "Notification"
  permS <- valToStr =<< notif ^. js "permission"
  case unpackJSString permS of
    "denied"  -> pure ( Just Denied )
    "granted" -> newNotify notif >> pure ( Just Granted )
    "default" -> do
      _ <- notif ^. JS.jsf "requestPermission"
        [JS.fun $ \_ _ [newPerm] -> do
            np <- valToStr newPerm
            when ( unpackJSString np == "granted" ) $
              void ( newNotify notif )
        ]
      pure ( Just Def )
    _ -> pure Nothing
