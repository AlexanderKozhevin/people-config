 # WorkersController
 #
 # @description :: Server-side logic for managing workers
 # @help        :: See http://sailsjfdsfs.org/#!/documentation/concepts/Controllers


serverconfig = require('../../serverconfig');

module.exports = {

	list: (req, res) ->
		query = JSON.parse(req.param('query'))
		query.limit = 500
		sails.models.workers.find(query).exec (err, data) ->
			res.send(data)

	query: (req, res) ->
		query = JSON.parse(req.param('query'))
		json = {
			max_data: 0
			data: {}
		}
		pagination =  JSON.parse(req.param('pagination'))
		sails.models.workers.count(query).exec (err, max) ->
			json.max_data = max

			query.limit = pagination.limit
			query.skip = (pagination.index_page-1) * pagination.limit

			if pagination.sort[0] == '-'
				query.sort = pagination.sort.substr(1) + ' desc'
			else
				query.sort = pagination.sort + ' asc'

			sails.models.workers.find(query).exec (err, found) ->
				json.data = found
				res.json(json)

	view: (req, res) ->
		user_id = req.param('user')
		sails.models.workers.findOne({id: user_id}).exec (err, worker_find) ->
			worker = worker_find;
			json = {}
			json.params = []
			if !worker_find
				res.json({status: "error"})
			else

				sails.models.jobs.findOne({id: worker.job}).exec (err, found) ->
					if !found
						res.json({status: "error"})
					else

						job = found
						json.job = job.name

						if job.worker_name.public
							json.name = worker.name

						if job.worker_avatar.public
							json.avatar = worker.avatar

						for i in job.params
							if i.public

						    element =
						      name: i.name,
						      type: i.type

						    switch element.type
						      when 'select'
						        element.values = i.values
						      when 'multiple select'
						        element.values = i.values

						    element.value = worker.values[i.id]
						    json.params.push(element)


						res.json(json)



	uploadFile:  (req, res) ->
    req.file('file').upload {
      adapter: require('skipper-s3'),
      key: serverconfig.s3.key,
      secret: serverconfig.s3.secret,
      bucket: serverconfig.s3.bucket
    }, (err, filesUploaded) ->
      res.negotiate(err) if (err)
      res.send({files: filesUploaded,textParams: req.params.all()})








}
