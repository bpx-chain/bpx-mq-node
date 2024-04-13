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
        "/waku/2/rs/279/0", "/waku/2/rs/279/1", "/waku/2/rs/279/2", "/waku/2/rs/279/3",
        "/waku/2/rs/279/4", "/waku/2/rs/279/5", "/waku/2/rs/279/6", "/waku/2/rs/279/7"
      ],
    discv5Discovery: true,
    discv5BootstrapNodes:
      @[
        "enr:-MG4QD-y_9EVpWtUjp-kqRhBd9uUfl5GILlJl37QDQOT02ikA2NSrEDqwBe1_LT2KYSEzpFIo-X5Auqd129pgqJKC8sBgmlkgnY0gmlwhFBVndKKbXVsdGlhZGRyc4wACgRQVZ3SBh9A3gOCcnOTARcIAAAAAQACAAMABAAFAAYAB4lzZWNwMjU2azGhAo9__eQXswEzGbIOiP0VeJHSlAaXf4jN4Z4_z9TWgiOqg3RjcILqYIN1ZHCCIyiFd2FrdTIP"
      ],
  )
