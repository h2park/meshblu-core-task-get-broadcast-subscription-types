_    = require 'lodash'
http = require 'http'
DeviceManager = require 'meshblu-core-manager-device'

class GetBroadcastSubscriptionTypes
  BROADCAST_SUBSCRIPTION_TYPES: ['broadcast']

  constructor: ({@datastore,@uuidAliasResolver}) ->
    @deviceManager = new DeviceManager {@datastore}

  _doCallback: (request, code, data, callback) =>
    response =
      metadata:
        responseId: request.metadata.responseId
        code: code
        status: http.STATUS_CODES[code]
      data: data
    callback null, response

  do: (request, callback) =>
    {uuid, messageType, options} = request.metadata
    try
      data = JSON.parse request.rawData
    catch
      return @_doCallback request, 422, {}, callback

    {types} = data
    types ?= []
    subscriptionTypes = _.intersection types, @BROADCAST_SUBSCRIPTION_TYPES

    responseData =
      types: subscriptionTypes
      uuid: uuid

    return @_doCallback request, 204, responseData, callback

module.exports = GetBroadcastSubscriptionTypes
