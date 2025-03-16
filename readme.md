o container ingress Dockerfile

podman run -p 8080:8080 --cap-add=SYS_ADMIN --cap-add=SYS_RESOURCE localhost/ingress


``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: io-uring-pod
spec:
  securityContext:
    seccompProfile:
      type: Unconfined
  containers:
    - name: io-uring-container
      image: alpine
      securityContext:
        capabilities:
          add:
            - SYS_ADMIN
```

``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: io-uring-pod
spec:
  securityContext:
    seccompProfile:
      type: RuntimeDefault  # Используем стандартный профайл seccomp
  containers:
    - name: io-uring-container
      image: alpine
      securityContext:
        capabilities:
          add:
            - CAP_BPF  # Только нужные права для работы io_uring
            - CAP_PERFMON
        seccompProfile:
          type: Localhost  # Загружаем свой профайл seccomp
```