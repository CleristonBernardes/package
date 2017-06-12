const package_pre    = require('../presenter/package');

test("Request Package", done => {
  function callback(err, data) {
    expect(data.name).toBe("3 Night Garden Cottage Retreat");
    done();
  };

  package_pre.get_package({},callback);
});
