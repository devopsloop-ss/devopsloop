+++
title = 'What happens when: I create a Kubernetes Pod'
date = 2024-02-18T17:10:53+05:30
draft = false
categories = ["devops", "kubernetes"]
tags = ["devops", "kubernetes", "what-happens-when"]
+++

_This blogpost takes a deepdive into the series of events that transpire, when a Kubernetes pod is created_

Have you ever wondered what happens behind the scenes when you create a pod in Kubernetes?
This blog post aims to unveil the intricate dance of events that unfolds from the moment
you issue a command like kubectl run to the point where your pod is up and running.

We'll break down the process into bite-sized steps, exploring various elements involved, including:

- **Client-side interactions:** How your command interacts with the Kubernetes API server.
- **Authentication and authorization:** Ensuring you have the necessary permissions to create pods.
- **API communication:** The exchange of information between different components.
- **Worker node activities:** Downloading images, launching containers, and managing resources.

A pre requisite to this post is knowing about the distributed architecture of Kubernetes.

## Why do I need to know this?

Understanding this process is crucial for both DevOps engineers and developers working with containerized applications in Kubernetes. Here's why:

### For DevOps Engineers:

- **Troubleshooting and debugging:** A deeper understanding of pod creation enables efficient troubleshooting of deployment issues. Knowing the various steps involved helps pinpoint potential bottlenecks or errors that might occur during the process.
- **Resource optimization:** By understanding how pods are created and managed, DevOps engineers can make informed decisions about resource allocation, ensuring efficient utilization and cost optimization.
- **Security considerations:** Familiarity with the authentication and authorization aspects of pod creation empowers DevOps engineers to implement robust security measures and manage access controls effectively.

### For Developers:

- **Improved collaboration:** When developers understand the underlying infrastructure, they can collaborate more effectively with DevOps teams, leading to smoother deployments and faster development cycles.
- **Debugging deployments:** Knowing the steps involved in pod creation allows developers to better debug issues related to their containerized applications and pinpoint problems within their code or configuration.
- **Informed infrastructure decisions:** Understanding the pod creation process empowers developers to make informed decisions about container image selection, resource requirements, and deployment strategies.

By demystifying pod creation in Kubernetes, this series aims to equip both DevOps engineers and developers with the knowledge and understanding to navigate the containerized world with greater confidence and efficiency.

## The process

So you just typed `kubectl run myapp --image nginx:latest` into your customised terminal with nerdfonts or a dull one with default prompt. Regardless, here's what happens next:

### Client-side (kubectl):

- User types and executes the command kubectl run myapp --image nginx:latest.
- kubectl parses the command, identifying arguments like pod name and image.
- kubectl authenticates with the Kubernetes API server using configured credentials.
- kubectl constructs a REST API request targeting the Pods endpoint with the generated Pod manifest.

### API Server:

- API server receives the request from kubectl.
- API server authenticates kubectl and authorizes the action based on configured policies.
- API server validates the provided Pod manifest against the Kubernetes Pod schema.
- Upon successful validation, the API server stores the new Pod object in its internal storage.

### Worker Node (kubelet):

- Kubelet receives notification from the API server about the newly created Pod.
- Kubelet retrieves the Pod object details from the API server (if not already cached).
- Kubelet determines the image pull policy defined for the Pod (e.g., "Always," "IfNotPresent").
- If necessary, kubelet pulls the specified image (nginx:latest) from a container registry.
- Kubelet selects a suitable container runtime (e.g., Docker, containerd) based on configuration.
- Kubelet uses the container runtime to create a new container instance based on the image.
- Kubelet configures network namespaces and interfaces for the Pod and container.
- Kubelet sets up resource limits and requests based on the Pod specification.
- Kubelet starts the container within the Pod.

### Ongoing Management:

- Kubelet continuously monitors the Pod and container health.
- Kubelet restarts the container if it crashes or fails liveness/readiness probes.
- Kubelet reports Pod and container resource usage metrics to the Metrics API for monitoring.

### Optional Service Exposure:

- (If `kubectl expose` is used) Kubelet creates a Service object mapping the Pod's internal IP to a cluster IP or load balancer.
- DNS records might be automatically created for accessing the service by name by kubeDNS or any other custom DNS controller (depending on configuration).

### Client-side Verification:

User can use kubectl get pods to verify the Pod creation and its "Running" state.
For further details, kubectl logs can access container logs, and the API server allows querying various cluster resources.

## The key learnings

Understanding the intricacies of pod creation in Kubernetes goes beyond mere theoretical knowledge. It empowers us to make informed decisions when designing applications and automating deployments. Here are some key ways to leverage this understanding:

### Application Design:

- **Resource optimization:** By knowing how resources are allocated during pod creation, developers can design their applications with efficient resource utilization in mind. This can involve choosing appropriate container images, optimizing memory and CPU usage, and defining clear resource requests and limits.
- **Error handling and resiliency:** Understanding the potential failure points during pod creation (e.g., image pull failures, container startup issues) allows developers to incorporate robust error handling mechanisms and build applications with inherent resiliency.

### Automation and CI/CD Pipelines:

- **Scripted deployments:** Knowledge of pod creation steps enables the creation of scripts or tools that automate pod deployment workflows. This can streamline the process, reduce human error, and ensure consistent deployments across environments.
- **Integration with CI/CD pipelines:** By integrating pod creation automation with CI/CD pipelines, developers can achieve continuous integration and delivery, allowing for faster and more reliable deployments.

### Utilizing Kubernetes Hooks:
_See: [Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/), [Validating Admission Policy](https://kubernetes.io/docs/reference/access-authn-authz/validating-admission-policy/), [Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) for additional reading_

Kubernetes API provides various hooks that allow injecting custom logic at specific points during the pod lifecycle. These hooks offer powerful capabilities for:

- **Pre-creation and post-creation validation:** Utilize hooks to perform additional checks on pod specifications before and after creation, ensuring they adhere to security or compliance requirements.
- **Resource injection:** Inject environment variables, secrets, or configuration files into pods during creation using hooks, simplifying configuration management.
- **Integration with external tools:** Leverage hooks to trigger external tools or workflows upon pod creation or deletion, enabling actions like sending notifications or updating monitoring systems.

### Additional learning: Policy Enforcement with Tools like Open Policy Agent (OPA):

[OPA](https://www.openpolicyagent.org/docs/latest/) is a popular policy engine that can integrate with Kubernetes to enforce policies during pod creation. Its uses the different Kubernetes hooks to validate configuration and enforce standards.
By leveraging hooks and OPA, you can implement:

- **Security policies:** Define rules to restrict pod creation based on image sources, resource usage limits, or other security criteria.
- **Compliance checks:** Enforce compliance with organizational policies or regulations by evaluating pod specifications against predefined rules.
- **Resource quotas:** Set limits on the number of pods or resources that can be created within a namespace, ensuring efficient resource utilization and preventing resource exhaustion.

## Conclusion

Unveiling the intricate dance of pod creation in Kubernetes empowers both DevOps engineers and developers. This knowledge equips you to design efficient applications, automate deployments with confidence, and leverage powerful tools like hooks and OPA for enhanced security and control. As you delve deeper into the world of containerized applications, remember that understanding the foundations is key to building and managing robust and scalable deployments in the ever-evolving landscape of Kubernetes.
