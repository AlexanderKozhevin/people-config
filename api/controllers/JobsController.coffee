 # JobsController
 #
 # @description :: Server-side logic for managing jobs
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports = {

  uploadFile:  (req, res) ->
    req.file('file').upload {
      adapter: require('skipper-s3'),
      key: 'AKIAILFXVMS7G77YPIXA',
      secret: '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',
      bucket: 'polymath-storage',
    }, (err, filesUploaded) ->
      res.negotiate(err) if (err)
      res.send({files: filesUploaded,textParams: req.params.all()})

  list: (req, res) ->
    sails.models.jobs.find({limit: 100}).exec (err, found) ->
      res.json(found)

  count: (req, res) ->
    if !req.param('query')
      sails.models.jobs.count().exec (err, found) ->
        res.json(found)
    else
      sails.models.jobs.count({"name": {'contains':req.param('query')}}).exec (err, found) ->
        res.json(found)

}
