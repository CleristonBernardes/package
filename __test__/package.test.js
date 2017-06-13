const package_pre    = require('../presenter/package');
const _              = require('underscore');
const config         = require('config');

test("Request Package - Success", done => {
  function callback(err, data) {
    expect(data.id_salesforce_external).toBe("a0s28000001Ek6FAAS");
    done();
  };

  package_pre.get_package({},callback);
});

test("Request Package - Empty Result", done => {
  const temp_api = _.clone(config.api);
  config.api.url = config.api.url + "?page=2&limit=20"
  function callback(err, data) {
    expect(data.length).toBe(0);
    config.api = temp_api;
    done();
  };

  package_pre.get_package({},callback);
});

test("Request Package - Invalid EndPoint", done => {
  const temp_api = _.clone(config.api);
  config.api.url = config.api.url + "_invalid"
  function callback(err, data) {
    expect(err).toBe(config.error.message);
    config.api = temp_api;
    done();
  };

  package_pre.get_package({},callback);
});

test("Request Package - Active Only", done => {
  const temp_api = _.clone(config.api);
  config.api.active_only = true
  function callback(err, data) {
    expect(data.id_salesforce_external).toBe("a0s28000000FzRiAAK");
    config.api = temp_api;
    done();
  };

  package_pre.get_package({},callback);
});

// function set_config_data(path, new_value){
//   for (var i=0, path=path.split('.'), len=path.length; i<len; i++){
//     obj = config[path[i]];
//   };
//   const temp_obj = _.clone(obj);
//   console.log("temp_api", obj);
//   obj = new_value;
// }
