# admission-webhook-example

### Setup the webhook:

1. Build and push an image

    ```
    docker build -t $DOCKER_REPO/admission-webhook-example:v1 .
    docker push $DOCKER_REPO/admission-webhook-example:v1
    ```

1. Update `deployment/deployment.yaml` with the recently pushed image.

1. Apply deploy

    ```
    k apply -f deployment/deployment.yaml
    k apply -f deployment/service.yaml
    ```

1. Setup tls

    ```
    ./deployment/webhook-create-signed-cert.sh
    cat ./deployment/validatingwebhook.yaml | ./deployment/webhook-patch-ca-bundle.sh > ./deployment/validatingwebhook-ca-bundle.yaml
    ```

1. Apply webhook

    ```
    k apply -f deployment/validatingwebhook-ca-bundle.yaml
    ```

### Steps to reproduce:

1. Create ns

    ```
    k create ns foo
    ```

2. Delete ns

    ```
    k delete ns foo
    ```

3. Ensure that the webhook is called 2 times by the apiserver

    ```
    $ k logs admission-webhook-example-deployment-7c79f6d9f6-jzlld

    I0608 19:36:56.158918       1 main.go:49] Server started
    /validate
    I0608 19:39:02.558411       1 webhook.go:56] AdmissionReview for Kind=/v1, Kind=Namespace, Namespace=foo (foo) UID=43634f7e-4d99-426e-b0f9-400b3917161c patchOperation=DELETE UserInfo={minikube-user  [system:masters system:authenticated] map[]}
    I0608 19:39:02.558686       1 webhook.go:121] Ready to write reponse ...
    /validate
    I0608 19:39:02.562774       1 webhook.go:56] AdmissionReview for Kind=/v1, Kind=Namespace, Namespace=foo (foo) UID=1f510b02-7b78-457d-81f3-9b3396b0b1f8 patchOperation=DELETE UserInfo={minikube-user  [system:masters system:authenticated] map[]}
    I0608 19:39:02.563073       1 webhook.go:121] Ready to write reponse ...
    ```

    ```
    $ k logs admission-webhook-example-deployment-7c79f6d9f6-jzlld

    W0608 19:39:02.558911       1 dispatcher.go:141] rejected by webhook "required-labels.banzaicloud.com": &errors.StatusError{ErrStatus:v1.Status{TypeMeta:v1.TypeMeta{Kind:"", APIVersion:""}, ListMeta:v1.ListMeta{SelfLink:"", ResourceVersion:"", Continue:"", RemainingItemCount:(*int64)(nil)}, Status:"Failure", Message:"admission webhook \"required-labels.banzaicloud.com\" denied the request: fake reason", Reason:"fake reason", Details:(*v1.StatusDetails)(nil), Code:400}}
    W0608 19:39:02.563429       1 dispatcher.go:141] rejected by webhook "required-labels.banzaicloud.com": &errors.StatusError{ErrStatus:v1.Status{TypeMeta:v1.TypeMeta{Kind:"", APIVersion:""}, ListMeta:v1.ListMeta{SelfLink:"", ResourceVersion:"", Continue:"", RemainingItemCount:(*int64)(nil)}, Status:"Failure", Message:"admission webhook \"required-labels.banzaicloud.com\" denied the request: fake reason", Reason:"fake reason", Details:(*v1.StatusDetails)(nil), Code:400}}
    ```

    You can also try the same setup with another non-namespaced resource and ensure that the webhook will receive only 1 request.
