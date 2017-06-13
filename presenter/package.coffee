package_c    = require '../controller/package'
_            = require 'underscore'
async        = require 'async'
config       = require 'config'
moment       = require 'moment'

get_package = (params, done) ->
  package_c.get_all_public_offers (err, offers) ->
    return done err if err?
    return done null, [] if offers.count <= 0 || not offers.result?

    # assemblying all packages from diff offers
    offer_packages = offers.result.map (r) ->
      if config.api.active_only && not (moment(r.end_date) >= moment() || not r.end_date?)
        []
      else
        # r.packages.push(r.lowest_price_package) # turned out to be on the list already
        r.packages

    # formating the packages to one big array
    all_packages = []
    for pack in offer_packages
      all_packages = _.union all_packages, pack

    # if theres not package, return empty array
    return done null, [] if all_packages.length is 0
    # if theres only one, return it
    return done null, all_packages[0] if all_packages.length is 1

    sorted = _.sortBy all_packages, (p) ->
      Math.abs((p.value || 0) - (p.price || 0)) * -1

    done null, sorted[0]

module.exports = {
  get_package
  clean_cache: package_c.clean_cache
}
