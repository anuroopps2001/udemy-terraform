// Extract user region
data "aws_region" "current" {}



// 
data "aws_region" "eu_west" {
    provider = aws.eu_west
}

output "eu_west_region" {
 value =  data.aws_region.eu_west
}
// Extract AWS user identity info
data "aws_caller_identity" "caller_identity" {}