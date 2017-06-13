const package_pre    = require('../presenter/package');
const _              = require('underscore');
const config         = require('config');

test("Request Package - Default", done => {
  set_test_env(null, null, (err, data) =>{
    expect(data.id_salesforce_external).toBe("a0s28000001Ek6FAAS");
    done();
  });
});

test("Request Package - Empty Result", done => {
  var obj = _.clone(config.api); obj.url = config.api.url + "?page=2&limit=20";
  set_test_env("api", obj, (err, data) =>{
    expect(data.length).toBe(0);
    done();
  });
});

test("Request Package - Invalid EndPoint", done => {
  var obj = _.clone(config.api); obj.url = config.api.url + "_invalid";
  set_test_env("api", obj, (err, data) =>{
    expect(err).toBe(config.error.message);
    done();
  });
});

test("Request Package - Active Only", done => {
  var obj = _.clone(config.api); obj.active_only = true;
  set_test_env("api", obj, (err, data) =>{
    expect(data.id_salesforce_external).toBe("a0s28000000FzRiAAK");
    done();
  });
});

function set_test_env(path, new_value, callback){
  if (path !== null && new_value !== null){
    var temp_config = _.clone(config[path]);
    config[path] = new_value;
  }
  package_pre.get_package({}, (err, data) =>{
    if (path !== null && new_value !== null) {config[path] = temp_config;}
    return callback(err, data);
  });

}
