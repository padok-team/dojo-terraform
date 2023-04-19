#cloud-config
groups:
  - docker
users:
  - name: ${github_username}
    ssh_import_id:
      - gh:${github_username}
    lock_passwd: true
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: [docker] # for sudoless docker
    shell: /bin/bash

write_files:
  - path: /etc/ssh/banner
    content: |
      (             (         )      )
      )\ )    (     )\ )   ( /(   ( /(
      (()/(    )\   (()/(   )\())  )\())
      /(_))((((_)(  /(_)) ((_)\ |((_)\
      (_))   )\ _ )\(_))_    ((_)|_ ((_)
      | _ \  (_)_\(_)|   \  / _ \| |/ /
      |  _/   / _ \  | |) || (_) | ' <
      |_|    /_/ \_\ |___/  \___/ _|\_\


        _._     _,-'""`-._
      (,-.`._,'(       |\`-/|
          `-.-' \ )-`( , o o)
                `-    \`_`"'-

  - path: /etc/environment
    content: |
      DOCKER_BUILDKIT="1"
    append: true

runcmd:
  # Install banner
  - echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config.d/banner.conf
  - sudo systemctl restart sshd

  # Install aws cli
  - sudo apt install -y unzip
  - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  - sudo unzip awscliv2.zip
  - sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
  - aws --version

  # Install tfswitch
  - curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
  - tfswitch --version

  # Install tgswitch
  - curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
  - tgswitch --version

  # Install direnv
  - curl -sfL https://direnv.net/install.sh | bash
  - direnv --version

  # Clone the exercise repository
  %{~ for repo_name, repo_url in repositories ~}
  - git clone "${repo_url}" "/home/${github_username}/${repo_name}" || echo "failed to clone ${repo_url}"
    # Set correct permissions for the repository
  - chown -R ${github_username}:${github_username} "/home/${github_username}/${repo_name}" || true # no fail if clone failed
  %{~ endfor }

  # Set useful data
  - touch /home/${github_username}/data.txt
  - echo "dns_zone_id = ${dns_zone_id}" >> /home/${github_username}/data.txt
  - echo "lb_dns_name = ${lb_dns_name}" >> /home/${github_username}/data.txt
  - echo "lb_listner_arn = ${lb_listner_arn}" >> /home/${github_username}/data.txt
  - echo "lb_security_group_id = ${lb_security_group_id}" >> /home/${github_username}/data.txt
  - echo "vpc_id = ${vpc_id}" >> /home/${github_username}/data.txt
  - echo "private_subnets_ids = ${private_subnets_ids}" >> /home/${github_username}/data.txt
  - echo "aws_account_id = ${aws_account_id}" >> /home/${github_username}/data.txt
  - echo "iam_user_name = ${iam_user_name}" >> /home/${github_username}/data.txt
  - echo "iam_user_password = ${iam_user_password}" >> /home/${github_username}/data.txt
  - echo "ecr_backend_image = ${ecr_backend}" >> /home/${github_username}/data.txt
  - echo "ecr_frontend_image = ${ecr_frontend}" >> /home/${github_username}/data.txt
