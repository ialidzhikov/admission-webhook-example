module github.com/ialidzhikov/admission-webhook-example

go 1.14

require (
	github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b
	k8s.io/api v0.17.6
	k8s.io/apimachinery v0.17.6
)

replace (
	k8s.io/api => k8s.io/api v0.17.6
	k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.17.6
	k8s.io/apimachinery => k8s.io/apimachinery v0.17.6
	k8s.io/apiserver => k8s.io/apiserver v0.17.6
	k8s.io/client-go => k8s.io/client-go v0.17.6
)
