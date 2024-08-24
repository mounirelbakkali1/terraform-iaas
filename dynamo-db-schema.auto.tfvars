example_table_attributes = {
  id = {
    type = "S"
  },
  name = {
    type = "S"
  },
  category = {
    type = "S"
  }
  createdAt = {
    type = "N"
  }
}

example_global_secondary_indexes = {
  CategoryIndex = {
    hash_key        = "category"
    projection_type = "ALL"
  }
  NameIndex = {
    hash_key        = "name"
    projection_type = "ALL"
  }
}

