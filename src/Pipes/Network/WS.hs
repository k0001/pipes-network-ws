{-# LANGUAGE RankNTypes #-}

-- | This module offers tools to stream from and to WebSocket
-- 'W.Connection's using "Pipes".
--
-- See the
-- [network-simple-wss](https://hackage.haskell.org/package/network-simple-wss),
-- [network-simple-ws](https://hackage.haskell.org/package/network-simple-ws) or
-- and [websockets](https://hackage.haskell.org/package/websockets)
-- libraries as well, for lower level support.
module Pipes.Network.WS
 ( fromConnection
 , toConnection
 ) where

import Control.Monad.IO.Class (MonadIO)
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Data.Function (fix)
import qualified Pipes as P

import qualified Network.Simple.WS as WS

--------------------------------------------------------------------------------

-- | Receives bytes from the remote end and sends them downstream.
--
-- The obtailed 'B.ByteString's are never 'B.empty'.
--
-- This producer returns when the conection is closed gracefully.

-- Note: The WebSockets protocol supports the silly idea of sending text, rather
-- than bytes, over the socket. We don't support that. If necessary, users can
-- find support for this in the `websockets` library.
fromConnection
  :: MonadIO m
  => WS.Connection
  -> P.Producer' B.ByteString m ()  -- ^
{-# INLINABLE fromConnection #-}
fromConnection conn =
  fix $ \k -> do
     bs <- WS.recv conn
     case B.null bs of
        False -> P.yield bs >> k
        True -> pure ()

-- | Send bytes from upstream to the remote end.

-- Note: The WebSockets protocol supports the silly idea of sending text, rather
-- than bytes, over the socket. We don't support that. If necessary, users can
-- find support for this in the `websockets` library.
toConnection
  :: MonadIO m
  => WS.Connection
  -> P.Consumer' B.ByteString m ()  -- ^
{-# INLINABLE toConnection #-}
toConnection conn = P.for P.cat (WS.send conn . BL.fromStrict)

