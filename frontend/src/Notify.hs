{-# LANGUAGE LambdaCase #-}
module Notify
  ( NotifyPerm (..)
  , tryNotify
  ) where

import           GHC.Generics                       (Generic)

import           Control.Lens                       ((^.))
import           Control.Monad                      (void, when)

import           Data.Foldable                      (traverse_)
import           Data.Maybe                         (fromMaybe)
import           Data.Text                          (Text, unpack)

import           Language.Javascript.JSaddle        (FromJSVal (..), JSM,
                                                     strToText, toJSString,
                                                     valToStr)
import           Language.Javascript.JSaddle.Value  (JSValue (ValString))

import           Language.Javascript.JSaddle.Object (fun, js, js1, jsf, jsg,
                                                     new, (!), ( # ))

data NotifyPerm
  = Default
  | Granted
  | Denied
  deriving ( Eq, Show )

instance FromJSVal NotifyPerm where
  fromJSVal = fmap ( matchPermStr . unpack . strToText ) . valToStr
    where
      matchPermStr "default" = Just Default
      matchPermStr "granted" = Just Granted
      matchPermStr "denied"  = Just Denied
      matchPermStr _         = Nothing

tryNotify
  :: Text
  -> JSM ( Maybe NotifyPerm )
tryNotify msg = do
  let
    newNotify nObj =
      void $ new nObj ( ValString msg )

    notifyCB _    Denied  = pure ()
    notifyCB nObj Granted = newNotify nObj
    notifyCB nObj Default = void $ nObj ^. jsf "requestPermission"
      [fun $ \_ _ [newPerm] ->
          fromJSVal newPerm >>= traverse_ (\case Granted -> newNotify nObj
                                                 _       -> pure ()
                                          )
      ]

  notif <- jsg "Notification"
  permS <- notif ^. js "permission"
  fromJSVal permS >>= traverse (\p -> notifyCB notif p >> pure p)
