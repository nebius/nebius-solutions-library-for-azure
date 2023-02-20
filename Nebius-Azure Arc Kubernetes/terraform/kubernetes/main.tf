# Random string
resource "random_string" "il_k8s_suffix" {
  length          = 8
  upper           = false
  lower           = true
  number          = true
  special         = false
}

# VPC and Subnets
resource "yandex_vpc_network" "il_k8s_vpc" {
  name            = "vpc-${random_string.il_k8s_suffix.result}"
  description     = "kubernetes vpc"
}

resource "yandex_vpc_subnet" "il_k8s_vpc_subnet" {
  name            = "subnet-a-${random_string.il_k8s_suffix.result}"
  zone            = var.il_zone
  network_id      = yandex_vpc_network.il_k8s_vpc.id
  v4_cidr_blocks  = var.il_k8s_cidr
}

# Security Groups
resource "yandex_vpc_security_group" "il_k8s_sg-main" {
  name        = "kube-sg-main-${random_string.il_k8s_suffix.result}"
  description = "For basic cluster availability"
  network_id  = yandex_vpc_network.il_k8s_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "incoming-from-balancer"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "node-to-node"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "ANY"
    description    = "pod-to-pod"
    v4_cidr_blocks = ["10.112.0.0/16", "10.96.0.0/16"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "icmp-internal"
    v4_cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "outgoing-all"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "il_k8s_sg-public" {
  name        = "kube-sg-public-${random_string.il_k8s_suffix.result}"
  description = "Internet access"
  network_id  = yandex_vpc_network.il_k8s_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "incoming-nodeport"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "il_k8s_sg-ssh" {
  name        = "kube-sg-ssh-${random_string.il_k8s_suffix.result}"
  description = "SSH access"
  network_id  = yandex_vpc_network.il_k8s_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "incoming-ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "il_k8s_sg-api" {
  name        = "kube-sg-api-${random_string.il_k8s_suffix.result}"
  description = "Kubernetes API access"
  network_id  = yandex_vpc_network.il_k8s_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "incoming-api-6443"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443

  }

  ingress {
    protocol       = "TCP"
    description    = "incoming-api-443"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}

# Service accounts
resource "yandex_iam_service_account" "il_k8s_sa" {
  name            = "kube-sa-${random_string.il_k8s_suffix.result}"
}

resource "yandex_resourcemanager_folder_iam_member" "il_k8s_sa" {
  folder_id       = var.il_folder_id
  member          = "serviceAccount:${yandex_iam_service_account.il_k8s_sa.id}"
  role            = "editor"
}

# KMS
resource "yandex_kms_symmetric_key" "il_k8s_kms" {
  folder_id         = var.il_folder_id
  name              = "kube-kms-${random_string.il_k8s_suffix.result}"
  description       = "kube kms key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // equal to 1 year
}

# Kubernetes cluster
resource "yandex_kubernetes_cluster" "il_k8s_cluster" {
  name          = "kube-${random_string.il_k8s_suffix.result}"
  description   = "kubernetes cluster"
  network_id    = "${yandex_vpc_network.il_k8s_vpc.id}"

  master {
    version     = var.il_k8s_version

    zonal {
      zone      = "${yandex_vpc_subnet.il_k8s_vpc_subnet.zone}"
      subnet_id = "${yandex_vpc_subnet.il_k8s_vpc_subnet.id}"
    }

    public_ip   = true
    security_group_ids = [
      yandex_vpc_security_group.il_k8s_sg-main.id,
      yandex_vpc_security_group.il_k8s_sg-public.id,
      yandex_vpc_security_group.il_k8s_sg-ssh.id,
      yandex_vpc_security_group.il_k8s_sg-api.id
    ]

    maintenance_policy {
      auto_upgrade = true
    }
  }

  service_account_id      = "${yandex_iam_service_account.il_k8s_sa.id}"
  node_service_account_id = "${yandex_iam_service_account.il_k8s_sa.id}"

  release_channel = var.il_k8s_channel

  depends_on = [yandex_resourcemanager_folder_iam_member.il_k8s_sa]

  network_implementation {
    cilium {
      
    }
  }

  kms_provider {
    key_id = "${yandex_kms_symmetric_key.il_k8s_kms.id}"
  }
}

# Kubernetes node group
resource "yandex_kubernetes_node_group" "il_k8s_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.il_k8s_cluster.id}"
  name        = "kube-ng-${random_string.il_k8s_suffix.result}"
  description = "kubernetes node group"
  version     = var.il_k8s_version

  instance_template {
    platform_id = "standard-v3"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.il_k8s_vpc_subnet.id}"]
      security_group_ids = [
        yandex_vpc_security_group.il_k8s_sg-main.id,
        yandex_vpc_security_group.il_k8s_sg-public.id,
        yandex_vpc_security_group.il_k8s_sg-ssh.id,
        yandex_vpc_security_group.il_k8s_sg-api.id
      ]
    }
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      type = "network-ssd"
      size = 64
    }
    scheduling_policy {
      preemptible = false
    }
  }
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  allocation_policy {
    location {
      zone = yandex_vpc_subnet.il_k8s_vpc_subnet.zone
    }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}