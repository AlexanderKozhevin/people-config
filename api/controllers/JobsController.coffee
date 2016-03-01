 # JobsController
 #
 # @description :: Server-side logic for managing jobs
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports = {
  list: (req, res) ->
    sails.models.jobs.find({limit: 100}).exec (err, found) ->
      res.json(found)
}
