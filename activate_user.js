var yargs = require('yargs').argv;
var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/sails');

var Schema = mongoose.Schema;
var User = new Schema({
	email: {type: "string"},
	pass: {type: "string"},
	active: {type: "boolean"}
});
var Users = mongoose.model('users', User);
Users.findOne({email: yargs.email}, function (err, user) {
  user.active = true;
  user.save() 
  console.log('activated');
  process.exit();
});

