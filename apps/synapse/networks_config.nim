when (NimMajor, NimMinor) < (1, 4):
  {.push raises: [Defect].}
else:
  {.push raises: [].}

type ClusterConf* = object
  maxMessageSize*: string
  clusterId*: uint32
  rlnRelay*: bool
  rlnRelayEthContractAddress*: string
  rlnRelayDynamic*: bool
  rlnRelayBandwidthThreshold*: int
  rlnEpochSizeSec*: uint64
  rlnRelayUserMessageLimit*: uint64
  pubsubTopics*: seq[string]
  discv5Discovery*: bool
  discv5BootstrapNodes*: seq[string]

# cluster-id=279
# Cluster configuration corresponding to The Synapse Network. Note that it
# overrides existing cli configuration
proc TheWakuNetworkConf*(T: type ClusterConf): ClusterConf =
  return ClusterConf(
    maxMessageSize: "150KiB",
    clusterId: 279.uint32,
    rlnRelay: false,
    rlnRelayEthContractAddress: "0xF471d71E9b1455bBF4b85d475afb9BB0954A29c4",
    rlnRelayDynamic: true,
    rlnRelayBandwidthThreshold: 0,
    rlnEpochSizeSec: 1,
    # parameter to be defined with rln_v2
    rlnRelayUserMessageLimit: 1,
    pubsubTopics:
      @[
        "/waku/2/rs/1/0", "/waku/2/rs/1/1", "/waku/2/rs/1/2", "/waku/2/rs/1/3",
        "/waku/2/rs/1/4", "/waku/2/rs/1/5", "/waku/2/rs/1/6", "/waku/2/rs/1/7"
      ],
    discv5Discovery: true,
    discv5BootstrapNodes:
      @[
        "enr:-Kq4QNUvHvhZfXWWkSywxI0Hf53SspkxFuOXNWhEDUwNLQPgBNFdd7xY5XX8PRJAlRVJPUQrTT1HIBC9NFQAYlFALwMBgmlkgnY0gmlwhFBVndKKbXVsdGlhZGRyc4wACgRQVZ3SBh9A3gOJc2VjcDI1NmsxoQKPf_3kF7MBMxmyDoj9FXiR0pQGl3-IzeGeP8_U1oIjqoN0Y3CC6mCDdWRwgiMohXdha3UyDw"
      ],
  )
