variable private_buckets {
  description = "A list of private buckets"
  type        = map
  default = {
    bucket1 = {
      name                           = "prazzy-static-website-11012020",
      origin_access_identity_comment = "prazzy-static-website-11012020"
    },
    bucket2 = {
      name                           = "prazzy-static-website-11022020",
      origin_access_identity_comment = "prazzy-static-website-11022020"
    }
  }
}