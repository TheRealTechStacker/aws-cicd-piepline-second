variable dockerhub_credentials {
    default = "arn:aws:secretsmanager:eu-central-1:745058185994:secret:mysecretpassword-nH8aYh"
    type = string
}

variable codestar_connector_credentials {
    default = "arn:aws:codestar-connections:eu-central-1:745058185994:connection/477af574-0d5a-4781-99eb-3c3845a92a49"
    type = string
}

variable "slack_url" {
  type        = string
  description = "The webhook URL"
}

variable "slack_channel" {
  type        = string
  description = "The name of the channel to post the notifications to"
}
