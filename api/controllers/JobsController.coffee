 # JobsController
 #
 # @description :: Server-side logic for managing jobs
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

serverconfig = require('../../serverconfig')


module.exports = {

  uploadFile:  (req, res) ->
    req.file('file').upload {
      adapter: require('skipper-s3'),
      key: serverconfig.s3.key,
      secret: serverconfig.s3.secret,
      bucket: serverconfig.s3.bucket,
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
