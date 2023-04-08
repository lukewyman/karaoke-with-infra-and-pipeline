data "aws_acm_certificate" "ssl_cert" {
  domain = "karaoke.lukewyman.dev"
}

data "aws_route53_zone" "hosted_zone" {
  name = "lukewyman.dev"
}