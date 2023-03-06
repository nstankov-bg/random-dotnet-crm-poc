##EXPERIMENTAL//
project = "test-dotnet-app-public"

app "test-dotnet-app-public" {
  labels = {
    "service" = "test-dotnet-app-public"
    "env"     = "dev"
  }

  build {
    use "docker" {
        buildkit = true
        platform = "linux/arm64/v8" #MacOS M2
        context    = "../../"
        dockerfile = "../../Dockerfile"
    }
    registry {
      use "docker" {
        image = "nikoogle/test-dotnet-app-public"
        tag   = "latest"
        local = true

      }
    }
  }


  deploy {
    use "kubernetes" {
      probe_path = "/api/weather"
    }
  }

  //ArgoCD here wins any day of the week so far.
  // release {
  //   use "kubernetes" {
  //     load_balancer = true
  //     port          = 8081
  //   }
  // }
}
