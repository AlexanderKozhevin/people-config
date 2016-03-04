 # EventsController
 #
 # @description :: Server-side logic for managing events
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports = {
  list: (req, res) ->
    sails.models.events.find().exec (err, found) ->
      res.json(found)

  count: (req, res) ->
    if !req.param('query')
      sails.models.events.count().exec (err, found) ->
        res.json(found)
    else
      sails.models.events.count({"name": {'contains':req.param('query')}}).exec (err, found) ->
        res.json(found)
}
