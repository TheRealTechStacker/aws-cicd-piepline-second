variable dockerhub_credentials {
    default = "arn:aws:secretsmanager:eu-central-1:745058185994:secret:mysecretpassword-nH8aYh"
    type = string
}

variable codestar_connector_credentials {
    default = "arn:aws:codestar-connections:eu-central-1:745058185994:connection/bcb6ba19-6465-47d3-86cd-e811c02fcfd4"
    type = stringyes
}

variable "slack_url" {
  type        = string
  description = "The webhook URL"
}

variable "slack_channel" {
  type        = string
  description = "The name of the channel to post the notifications to"
}
