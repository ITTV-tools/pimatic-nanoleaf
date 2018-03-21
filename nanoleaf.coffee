# Pimatic MQTT plugin
module.exports = (env) ->

  Promise = env.require 'bluebird'
  pluginConfigDef = require './nanoleaf-config-schema'

  deviceTypes = {}
  for device in [
    'light-aurora'
  ]
    className = device.replace /(^[a-z])|(\-[a-z])/g, ($1) -> $1.toUpperCase().replace('-','')
    deviceTypes[className] = require('./devices/' + device)(env)


  class NanloafPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")

      for className, classType of deviceTypes
        env.logger.debug "Registering device class #{className}"
        @framework.deviceManager.registerDeviceClass(className, {
          configDef: deviceConfigDef[className],
          createCallback: @callbackHandler(className, classType)
        })

    callbackHandler: (className, classType) ->
      return (config, lastState) =>
        return new classType(config, @, lastState)


  return new NanloafPlugin
