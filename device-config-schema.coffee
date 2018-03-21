module.exports = {
  title: "pimatic-neoleaf device config schemas"
  LightAurora: {
    title: "AuroraLight config options"
    type: "object"
    properties:
      IP:
        description: "IP of AuroraLight"
        type: "string"
      Token:
        description: "API Key"
        type: "string"
      Interval:
        description: "Update Interval in ms"
        type: "number"
        default: 1000

  }
}
