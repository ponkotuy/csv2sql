(function() {
  var rawCSV;

  rawCSV = 'table\nid, lang\n1, English\n2, 日本語';

  test('convert to insert sql', function() {
    var divided, insert;
    insert = 'INSERT INTO table (id,  lang) VALUES\n  (1, \'English\'),\n  (2, \'日本語\');';
    equal(convert('INSERT', 'default', rawCSV), insert);
    divided = 'INSERT INTO table (id,  lang) VALUES (1, \'English\');\nINSERT INTO table (id,  lang) VALUES (2, \'日本語\');';
    return equal(convert('INSERT', 'divided', rawCSV), divided);
  });

  test('convert to delete sql', function() {
    var del;
    del = 'DELETE FROM table\n  WHERE (id,  lang) IN (\n    (1, \'English\'),\n    (2, \'日本語\'));';
    return equal(convert('DELETE', null, rawCSV), del);
  });

  test('convert to select sql', function() {
    var select;
    select = 'SELECT * FROM table\n  WHERE (id,  lang) IN (\n    (1, \'English\'),\n    (2, \'日本語\'));';
    return equal(convert('SELECT', null, rawCSV), select);
  });

}).call(this);
