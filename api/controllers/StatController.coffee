 # StatController
 #
 # @description :: Server-side logic for managing stats
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers


# panel.topEvents({type: 'general'}).then(function(data){
#   console.log(data)
# })
#
# // panel.segmentation({event: 'landing', from_date: '2016-03-01', to_date: '2016-03-02'}).then(function(data){
# //   console.log(data.data)
# // })
#
# // panel.segmentation({event: 'landing', from_date: '2016-03-01', to_date: '2016-03-02', on: 'properties["mp_country_code"]'}).then(function(data){
# //   console.log(data.data)
# // })
#

MixpanelExport = require('mixpanel-data-export');
panel = new MixpanelExport({
  api_key: "8c22fb4c225edefd204b54cd10ea52cd",
  api_secret: "378eee2fca7aa372d4d63077d0bfb8ef"
});

Q = require('q')
Promise = require('promise')

Date.prototype.subDays = (days) ->
    dat = new Date(this.valueOf())
    dat.setDate(dat.getDate() - days);
    return dat;

module.exports = {

  general: (req, res) ->
    json =
      workers: 0
      jobs: 0
      bids: 0
    q1 = new Promise (resolve, reject) ->
      sails.models.workers.count({}).exec (err, data) -> resolve(data)
    q2 = new Promise (resolve, reject) ->
      sails.models.bids.count({status: "pending"}).exec (err, data) -> resolve(data)
    q3 = new Promise (resolve, reject) ->
      sails.models.jobs.count({}).exec (err, data) -> resolve(data)
    Q.all([q1, q2, q3]).then (data) ->
      json.workers = data[0]
      json.bids = data[1]
      json.jobs = data[2]
      res.json(json)


  day: (req, res) ->
    today = new Date()
    day_before = today.subDays(1)

    str_today = today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate()
    str_yesterday = day_before.getFullYear() + '-' + (day_before.getMonth()+1) + '-' + day_before.getDate()

    panel.segmentation({event: 'landing', from_date: str_yesterday, to_date: str_today, unit: "hour"}).then (data) ->
      res.json(data)

  period: (req, res) ->
    to = new Date()
    from = new Date(req.param('from'))

    panel.segmentation({event: 'landing', from_date: req.param('from'), to_date: req.param('to')}).then (data) ->
      res.json(data)





}
