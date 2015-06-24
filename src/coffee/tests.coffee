rawCSV =
  '''table
  id, lang
  1, English
  2, 日本語
  '''
test 'convert to insert sql', ->
  insert =
    '''
    INSERT INTO table (id,  lang) VALUES
      (1, 'English'),
      (2, '日本語');
    '''
  equal(convert('INSERT', 'default', rawCSV), insert)

  divided =
    '''
    INSERT INTO table (id,  lang) VALUES (1, 'English');
    INSERT INTO table (id,  lang) VALUES (2, '日本語');
    '''
  equal(convert('INSERT', 'divided', rawCSV), divided)

test 'convert to delete sql', ->
  del =
    '''
    DELETE FROM table
      WHERE (id,  lang) IN (
        (1, 'English'),
        (2, '日本語'));
    '''
  equal(convert('DELETE', null, rawCSV), del)

test 'convert to select sql', ->
  select =
    '''
    SELECT * FROM table
      WHERE (id,  lang) IN (
        (1, 'English'),
        (2, '日本語'));
    '''
  equal(convert('SELECT', null, rawCSV), select)
