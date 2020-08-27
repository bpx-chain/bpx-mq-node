import
  confutils, chronicles, chronos, stew/byteutils,
  eth/[keys, p2p, async_utils],
  ../../waku/protocol/v1/waku_protocol,
  ../../waku/node/v1/waku_helpers,
  ./config_example

## This is a simple Waku v1 example to show the Waku v1 API usage.

const clientId = "Waku example v1"

let
  # Load the cli configuration from `config_example.nim`.
  config = WakuNodeConf.load()
  # Seed the rng.
  rng = keys.newRng()
  # Set up the address according to NAT information.
  (ip, tcpPort, udpPort) = setupNat(config.nat, clientId, config.tcpPort,
    config.udpPort, config.portsShift)
  address = Address(ip: ip, tcpPort: tcpPort, udpPort: udpPort)

# Create Ethereum Node
var node = newEthereumNode(config.nodekey, # Node identifier
  address, # Address reachable for incoming requests
  1, # Network Id, only applicable for ETH protocol
  nil, # Database, not required for Waku
  clientId, # Client id string
  addAllCapabilities = false, # Disable default all RLPx capabilities
  rng = rng)

node.addCapability Waku # Enable only the Waku protocol.

# Set up the Waku configuration.
let wakuConfig = WakuConfig(powRequirement: 0.002,
  bloom: some(fullBloom()), # Full bloom filter
  isLightNode: false, # Full node
  maxMsgSize: waku_protocol.defaultMaxMsgSize,
  topics: none(seq[waku_protocol.Topic]) # empty topic interest
  )
node.configureWaku(wakuConfig)

# Optionally direct connect to a set of nodes.
if config.staticnodes.len > 0:
  connectToNodes(node, config.staticnodes)

# Connect to the network, which will make the node start listening and/or
# connect to bootnodes, and/or start discovery.
# This will block until first connection is made, which in this case can only
# happen if we directly connect to nodes (step above) or if an incoming
# connection occurs, which is why we use `traceAsyncErrors` instead of `await`.
# TODO: This looks a bit awkward and the API should perhaps be altered here.
traceAsyncErrors node.connectToNetwork(@[],
  true, # Enable listening
  false # Disable discovery (only discovery v4 is currently supported)
  )

# Using a hardcoded symmetric key for encryption of the payload for the sake of
# simplicity.
var symKey: SymKey
symKey[31] = 1
# Asymmetric keypair to sign the payload.
let signKeyPair = KeyPair.random(rng[])

# Code to be executed on receival of a message on filter.
proc handler(msg: ReceivedMessage) =
  if msg.decoded.src.isSome():
    echo "Received message from ", $msg.decoded.src.get(), ": ",
      string.fromBytes(msg.decoded.payload)

# Create and subscribe filter with above handler.
let
  topic = [byte 0, 0, 0, 0]
  filter = initFilter(symKey = some(symKey), topics = @[topic])
discard node.subscribeFilter(filter, handler)

# Repeat the posting of a message every 5 seconds.
proc repeatMessage(udata: pointer) {.gcsafe.} =
  {.gcsafe.}:
    # Post a waku message on the network, encrypted with provided symmetric key,
    # signed with asymmetric key, on topic and with ttl of 30 seconds.
    let posted = node.postMessage(
      symKey = some(symKey), src = some(signKeyPair.seckey),
      ttl = 30, topic = topic, payload = @[byte 0x48, 0x65, 0x6C, 0x6C, 0x6F])

    if posted: echo "Posted message as ", $signKeyPair.pubkey
    else: echo "Posting message failed."

  discard setTimer(Moment.fromNow(5.seconds), repeatMessage)
discard setTimer(Moment.fromNow(5.seconds), repeatMessage)

runForever()