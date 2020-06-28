Map create = {
  'tbversion': {
    'name': 'TB_TBL_VERSION',
    'pk': ['TABLE_NAME'],
    'columns': ['TABLE_NAME', 'TABLE_VERSION', 'ADDLCOL1', 'ADDLCOL2'],
    'types': ['VARCHAR(45)', 'VARCHAR(45)', 'VARCHAR(45)', 'VARCHAR(45)'],
    'version': 1
  },
  'tbprefs': {
    'name': 'TB_PREFS',
    'pk': ['KEY', 'VAL'],
    'columns': ['KEY', 'VAL', 'ADDLCOL1', 'ADDLCOL2', 'ADDLCOL3'],
    'types': [
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)'
    ],
    'version': 1
  },
  'tbusers': {
    'name': 'TB_USERS',
    'pk': ['USER_ID', 'PASS'],
    'columns': ['USER_ID', 'PASS', 'LAST_LOGIN', 'ROLE', 'EXT_ID', 'BIO_AUTH'],
    'types': [
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
      'VARCHAR(45)',
    ],
    'version': 1
  },
  'tbcustitmrcnt': {
    'name': 'TB_RCNT_ITM',
    'pk': [],
    'columns': [],
    'types': [],
    'version': 1
  },
};
