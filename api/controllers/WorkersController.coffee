 # WorkersController
 #
 # @description :: Server-side logic for managing workers
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers


module.exports = {

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
      key: 'AKIAILFXVMS7G77YPIXA',
      secret: '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',
      bucket: 'polymath-storage',
    }, (err, filesUploaded) ->
      res.negotiate(err) if (err)
      res.send({files: filesUploaded,textParams: req.params.all()})



	count: (req, res) ->

		if req.param('id')
			sails.models.workers.count({'job': req.param('id')}).exec (err, found) ->
				res.json(found)

		if req.param('query')
			sails.models.workers.count({"name": {'contains':req.param('query')}}).exec (err, found) ->
				res.json(found)

		if req.param('querybig')
			yo = JSON.parse(req.param('querybig'));
			sails.models.workers.count(yo).exec (err, found) ->
				res.json(found)

		if !req.param('querybig') and !req.param('query') and !req.param('id')
			sails.models.workers.count().exec (err, found) ->
				res.json(found)




}
