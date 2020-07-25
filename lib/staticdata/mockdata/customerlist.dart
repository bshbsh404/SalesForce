Map<String,dynamic> custList = {"resp":{
  "columns": ["id","custName", "address","status"],
  "values": [
    ["1","vignesh retailer", "new bus stand","true"],
    ["2","vignesh1 retailer", "new bus stand","true"],
    ["3","vignesh2 retailer", "new bus stand","true"],
    ["4","vignesh3 retailer", "new bus stand","true"],
    ["5","vignesh4 retailer", "new bus stand","true"],
  ],
  "name": "TB_CUST",
  "pk": ["id"],
  'types': [
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
  ]
}};
Map<String,dynamic> items =  {"resp":{
  "columns": ["id","itemname", "power","status"],
  "values": [
    ["1","switch", null,"true"],
    ["2","cable", null,"true"],
    ["3","L-joint",null,"true"],
    ["4","regulator",null, "true"],
    ["5","fan", "60w","true"],
  ],
  "name": "TB_ITEMS",
  "pk": ["id"],
  'types': [
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
  ]
}};
Map<String,dynamic> stocks =  {"resp":{
  "columns": ["id","stock","mrp","ptr","schm","status"],
  "values": [
    ["1","10","3","2.3","1.0.0","true"],
    ["2","10","3","2.3","1.0.0","true"],
    ["3","10","3","2.3","1.0.0","true"],
    ["4","10","3","2.3","1.0.0","true"],
  ],
  "name": "TB_STOCKS",
  "pk": ["id"],
  'types': [
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
  ]
}};
Map<String,dynamic> outst = {"resp": {
  "columns": ["id","stock","mrp","ptr","schm","status"],
  "values": [
    ["1","10","3","2.3","1.0.0","true"],
    ["2","10","3","2.3","1.0.0","true"],
    ["3","10","3","2.3","1.0.0","true"],
    ["4","10","3","2.3","1.0.0","true"],
  ],
  "name": "TB_OUTST",
  "pk": ["id"],
  'types': [
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
  ]
}};
Map<String,dynamic> ordrlst =  {"resp":{
  "columns": ["id","qty","invno","ordno","status"],
  "values": [
    ["1","10","I001","O001","true"],
    ["2","3","I001","O001","true"],
    ["3","4","I003","O002","true"],
    ["4","8","I005","O004","true"],
  ],
  "name": "TB_OUTST",
  "pk": ["id"],
  'types': [
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
    'VARCHAR(45)',
  ]
}};
