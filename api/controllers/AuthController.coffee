 # AuthController
 #
 # @description :: Server-side logic for managing auths
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports = {

  _config: {
    actions: true,
    rest: false,
    shortcuts: false
  },

  login: (req, res) ->
    email = req.param('email')
    pass = req.param('pass')
    sails.models.users.findOne({email: email}).exec (err, found) ->

      res.send('error') if err

      if !found
        res.send('unknown user')

      if found

        if found.active
          console.log('granted')
          res.json({status: "granted"})
        else
          console.log('granted')
          res.json({status: "denied"})

}
