resource "aws_dynamodb_table" "status_table" {
  name           = "space_station_status"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "station_id"  
  attribute {
    name = "station_id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name               = "status-index"
    hash_key           = "status"
    projection_type    = "ALL"  

    read_capacity      = 5
    write_capacity     = 5
  }
}
