output "encrypted_password" {  # Output the encrypted password for the user
  value = aws_iam_user_login_profile.demo_login.encrypted_password
}

# The encrypted password can be decrypted using "echo "PASTE_THE_ENCRYPTED_PASSWORD_FROM_TERRAFORM" | base64 --decode | gpg --decrypt"
# Use the decrypted key to login to the AWS Management Console