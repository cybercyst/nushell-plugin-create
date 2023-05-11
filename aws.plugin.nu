def-env asp [
  profile?: string
  login?: string
] {
  if ($profile == null) {
    hide-env --ignore-errors AWS_DEFAULT_PROFILE
    hide-env --ignore-errors AWS_PROFILE
    hide-env --ignore-errors AWS_EB_PROFILE
    hide-env --ignore-errors AWS_PROFILE_REGION
    print "AWS profile cleared."
    return
  }

  let available_profiles = (aws --no-cli-pager configure list-profiles | lines)
  if ($available_profiles | find $profile | is-empty) {
    print -e $"(ansi red)Profile ($profile) is not found."
    print -e $"Available profiles \(($available_profiles | str join ', ')\)(ansi reset)"
    return
  }

  let-env AWS_DEFAULT_PROFILE = $profile
  let-env AWS_PROFILE = $profile
  let-env AWS_EB_PROFILE = $profile

  let-env AWS_PROFILE_REGION = (aws configure get region)

  if ($login == "login") {
    aws sso login
    return
  }
}

