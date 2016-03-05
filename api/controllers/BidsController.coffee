 # BidsController
 #
 # @description :: Server-side logic for managing bids
 # @help        :: See http://sailsjsf.org/#!/documentation/concepts/Controllers

module.exports = {

  query: (req, res) ->
    query = JSON.parse(req.param('query'))
    json = {
      max_data: 0
      data: {}
    }
    pagination =  JSON.parse(req.param('pagination'))
    sails.models.bids.count(query).exec (err, max) ->
      json.max_data = max

      query.limit = pagination.limit
      query.skip = (pagination.index_page-1) * pagination.limit

      if pagination.sort[0] == '-'
        query.sort = pagination.sort.substr(1) + ' desc'
      else
        query.sort = pagination.sort + ' asc'

      sails.models.bids.find(query).exec (err, found) ->
        json.data = found
        res.json(json)



  uploadFile:  (req, res) ->
    req.file('file').upload {
      adapter: require('skipper-s3'),
      key: 'AKIAILFXVMS7G77YPIXA',
      secret: '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',
      bucket: 'polymath-storage',
    }, (err, filesUploaded) ->
      res.negotiate(err) if (err)
      res.send({files: filesUploaded,textParams: req.params.all()})

  approve: (req, res) ->
    sails.models.bids.findOne({id: req.param('id')}).exec (err, found) ->
      object = found;
      delete object._id
      delete object.status
      # ha
      sails.models.bids.destroy({id: req.param('id')}).exec () ->

      sails.models.workers.create(object).exec (err, found) ->
        res.send({status: 'success'})

  count: (req, res) ->

    if req.param('id')
      sails.models.bids.count({'job': req.param('id')}).exec (err, found) ->
        res.json(found)


    if req.param('query')
      sails.models.bids.count({"name": {'contains':req.param('query')}}).exec (err, found) ->
        res.json(found)

    if req.param('querybig')
      yo = JSON.parse(req.param('querybig'));
      sails.models.bids.count(yo).exec (err, found) ->
        res.json(found)

    if req.param('status')
      sails.models.bids.count({'status': req.param('status')}).exec (err, found) ->
        res.json(found)


}
