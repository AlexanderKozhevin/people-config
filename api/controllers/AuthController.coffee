 # AuthController
 #
 # @description :: Server-side logic for managing auths
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

bcrypt = require('bcrypt');
module.exports = {

  _config: {
    actions: true,
    rest: false,
    shortcuts: false
  },

  is_logged: (req, res) ->
    if req.session.authenticated
      res.json({status: "success"})
    else
      res.json({status: "error"})
  register: (req, res) ->
    json =
      email: req.param('email')
      pass: req.param('pass')
      active: false
    sails.models.users.create(json).exec (err, found) ->
      res.json({status: "error"}) if err
      res.json({status: "error"}) if !found
      res.json({status: "success"}) if found

  login: (req, res) ->
    email = req.param('email')
    pass = req.param('pass')

    if !email or !pass
      res.json({status: "error"})
    else
      sails.models.users.findOne({email: email}).exec (err, found) ->

        res.json({status: "error"}) if err
        res.json({status: "error"}) if !found

        if found
          if found.active
            is_correct = bcrypt.compareSync(pass, found.pass);
            if is_correct
              if req.session
                req.session.authenticated = true
              res.json({status: "granted"})
            else
              res.json({status: "error"})
          else
            res.json({status: "denied"})

}
