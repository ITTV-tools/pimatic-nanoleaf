module.exports = (env) ->

  Promise = env.require 'bluebird'
  assert = env.require 'cassert'

  AuroraApi = require 'nanoleaf-aurora-client'

  class LightAurora extends env.devices.PowerSwitch

    constructor: (@config, lastState) ->

      @name = @config.name
      @id = @config.id
      @_state = lastState?.state?.value or off

      @api = new AuroraApi(
        host: @config.IP
        base: '/api/v1/'
        port: '16021'
        accessToken: @config.Token
        timeout: 5000)

      @updateState()
      setInterval( ( =>
        @updateState()
      ), @config.Interval)

      super()

    updateState: () ->
      @api.getPowerStatus().then((info) =>
        info = JSON.parse(info)
        if info.value == true
          @_setState(on)
          @_state = on
          @emit "state", on
        else
          @_setState(off)
          @_state = off
          @emit "state", off
        return
      ).catch (err) ->
        env.logger.error err
        return


    changeStateTo: (state) ->
      @_setState(state)
      if state
        @api.turnOn().then(->
          return
        ).catch (err) ->
          env.logger.error err
          return
      else
        @api.turnOff().then(->
          return
        ).catch (err) ->
          env.logger.error err
          return
      return Promise.resolve()

    destroy: () ->
      delete @api
      super()
