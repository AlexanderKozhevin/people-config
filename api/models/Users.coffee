 # Users.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/documentation/concepts/models-and-orm/models

module.exports =

  attributes: {
    email: {type: "string"},
    pass: {type: "string"},
    active: {type: "boolean"}
  },
  beforeCreate: (values, next) ->
    require('bcrypt').hash(values.pass, 10, (err, encryptedPassword) ->
      values.pass = encryptedPassword;
      next()
    )
