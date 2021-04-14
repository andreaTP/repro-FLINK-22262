
## Dependencies:

 - docker
 - sbt
 - bash
 - jq
 - kubectl
 - helm
 - flink cli

a running K8s cluster

## Steps:

 - Clone this project
 - change the values in `docker.sbt` to target a Docker registry/repo you and the cluster have access to
 - run `sbt buildApp`
 - create "hello-world" namespace: `kubectl create ns hello-world`
 - run `./setup-example-rbac.sh`
 - create an NFS provisioner: `helm upgrade -i nfs-server-provisioner stable/nfs-server-provisioner --set storageClass.provisionerName=cloudflow-nfs --namespace hello-world`
 - create a PVC for Flink: `kubectl apply -f flink-pvc.yaml -n hello-world`
 - create needed secrets: `kubectl apply -f hello-world.yaml`
 - deploy with `deploy.sh`
 - wait for the job to be running

 if you do:
 - cancel the job: `flink cancel --target kubernetes-application -Dkubernetes.cluster-id=hello-world -Dkubernetes.namespace=hello-world 00000000000000000000000000000000`
 - NOTE: the JobManager enter in `CrashLoopBackoff`
 - delete the deployment: `kubectl delete deployment hello-world --namespace hello-world`
 - deploy with `deploy.sh`
 - job manager throws: `java.util.concurrent.ExecutionException: org.apache.flink.runtime.messages.FlinkJobNotFoundException: Could not find Flink job`
 - cannot recover


Full exceptions text:
```
2021-04-14 16:42:54,398 ERROR cloudflow.runner.Runner$                                     [] - A fatal error has occurred. The streamlet is going to shutdown
java.util.concurrent.ExecutionException: org.apache.flink.runtime.messages.FlinkJobNotFoundException: Could not find Flink job (00000000000000000000000000000000)
	at java.util.concurrent.CompletableFuture.reportGet(CompletableFuture.java:357) ~[?:1.8.0_272]
	at java.util.concurrent.CompletableFuture.get(CompletableFuture.java:1908) ~[?:1.8.0_272]
	at org.apache.flink.client.program.StreamContextEnvironment.getJobExecutionResult(StreamContextEnvironment.java:123) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.client.program.StreamContextEnvironment.execute(StreamContextEnvironment.java:80) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.streaming.api.environment.StreamExecutionEnvironment.execute(StreamExecutionEnvironment.java:1839) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.streaming.api.scala.StreamExecutionEnvironment.execute(StreamExecutionEnvironment.scala:801) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at cloudflow.flink.FlinkStreamletLogic.executeStreamingQueries(FlinkStreamlet.scala:413) ~[contrib-flink_2.12-0.0.1.jar:0.0.1]
	at cloudflow.flink.FlinkStreamlet$ClusterFlinkJobExecutor$.$anonfun$execute$3(FlinkStreamlet.scala:284) ~[contrib-flink_2.12-0.0.1.jar:0.0.1]
	at scala.util.Try$.apply(Try.scala:209) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at cloudflow.flink.FlinkStreamlet$ClusterFlinkJobExecutor$.execute(FlinkStreamlet.scala:284) ~[contrib-flink_2.12-0.0.1.jar:0.0.1]
	at cloudflow.flink.FlinkStreamlet.run(FlinkStreamlet.scala:238) ~[contrib-flink_2.12-0.0.1.jar:0.0.1]
	at cloudflow.flink.FlinkStreamlet.run(FlinkStreamlet.scala:71) ~[contrib-flink_2.12-0.0.1.jar:0.0.1]
	at cloudflow.streamlets.Streamlet.run(Streamlet.scala:106) ~[cloudflow-streamlets_2.12-2.0.26-RC14.jar:2.0.26-RC14]
	at cloudflow.runner.Runner$.run(Runner.scala:68) ~[cloudflow-runner.jar:2.0.26-RC14]
	at cloudflow.runner.Runner$.main(Runner.scala:46) ~[cloudflow-runner.jar:2.0.26-RC14]
	at cloudflow.runner.Runner.main(Runner.scala) ~[cloudflow-runner.jar:2.0.26-RC14]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[?:1.8.0_272]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[?:1.8.0_272]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[?:1.8.0_272]
	at java.lang.reflect.Method.invoke(Method.java:498) ~[?:1.8.0_272]
	at org.apache.flink.client.program.PackagedProgram.callMainMethod(PackagedProgram.java:355) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.client.program.PackagedProgram.invokeInteractiveModeForExecution(PackagedProgram.java:222) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.client.ClientUtils.executeProgram(ClientUtils.java:114) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.client.deployment.application.ApplicationDispatcherBootstrap.runApplicationEntryPoint(ApplicationDispatcherBootstrap.java:242) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.client.deployment.application.ApplicationDispatcherBootstrap.lambda$runApplicationAsync$1(ApplicationDispatcherBootstrap.java:212) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511) [?:1.8.0_272]
	at java.util.concurrent.FutureTask.run(FutureTask.java:266) [?:1.8.0_272]
	at org.apache.flink.runtime.concurrent.akka.ActorSystemScheduledExecutorAdapter$ScheduledFutureTask.run(ActorSystemScheduledExecutorAdapter.java:159) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.TaskInvocation.run(AbstractDispatcher.scala:40) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.ForkJoinExecutorConfigurator$AkkaForkJoinTask.exec(ForkJoinExecutorConfigurator.scala:44) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.forkjoin.ForkJoinTask.doExec(ForkJoinTask.java:260) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.forkjoin.ForkJoinPool$WorkQueue.runTask(ForkJoinPool.java:1339) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.forkjoin.ForkJoinPool.runWorker(ForkJoinPool.java:1979) [flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.dispatch.forkjoin.ForkJoinWorkerThread.run(ForkJoinWorkerThread.java:107) [flink-dist_2.12-1.13.0.jar:1.13.0]
Caused by: org.apache.flink.runtime.messages.FlinkJobNotFoundException: Could not find Flink job (00000000000000000000000000000000)
	at org.apache.flink.runtime.dispatcher.Dispatcher.lambda$requestJobStatus$15(Dispatcher.java:608) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at java.util.Optional.orElseGet(Optional.java:267) ~[?:1.8.0_272]
	at org.apache.flink.runtime.dispatcher.Dispatcher.requestJobStatus(Dispatcher.java:602) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[?:1.8.0_272]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[?:1.8.0_272]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[?:1.8.0_272]
	at java.lang.reflect.Method.invoke(Method.java:498) ~[?:1.8.0_272]
	at org.apache.flink.runtime.rpc.akka.AkkaRpcActor.handleRpcInvocation(AkkaRpcActor.java:305) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.runtime.rpc.akka.AkkaRpcActor.handleRpcMessage(AkkaRpcActor.java:212) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.runtime.rpc.akka.FencedAkkaRpcActor.handleRpcMessage(FencedAkkaRpcActor.java:77) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at org.apache.flink.runtime.rpc.akka.AkkaRpcActor.handleMessage(AkkaRpcActor.java:158) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.japi.pf.UnitCaseStatement.apply(CaseStatements.scala:26) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.japi.pf.UnitCaseStatement.apply(CaseStatements.scala:21) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at scala.PartialFunction.applyOrElse(PartialFunction.scala:123) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at scala.PartialFunction.applyOrElse$(PartialFunction.scala:122) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.japi.pf.UnitCaseStatement.applyOrElse(CaseStatements.scala:21) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at scala.PartialFunction$OrElse.applyOrElse(PartialFunction.scala:171) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at scala.PartialFunction$OrElse.applyOrElse(PartialFunction.scala:172) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at scala.PartialFunction$OrElse.applyOrElse(PartialFunction.scala:172) ~[flink-dist_2.12-1.13.0.jar:1.13.0]
	at akka.actor.Actor.aroundReceive(Actor.scala:517) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.actor.Actor.aroundReceive$(Actor.scala:515) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.actor.AbstractActor.aroundReceive(AbstractActor.scala:225) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.actor.ActorCell.receiveMessage(ActorCell.scala:592) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.actor.ActorCell.invoke(ActorCell.scala:561) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.dispatch.Mailbox.processMailbox(Mailbox.scala:258) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.dispatch.Mailbox.run(Mailbox.scala:225) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	at akka.dispatch.Mailbox.exec(Mailbox.scala:235) ~[akka-actor_2.12-2.5.31.jar:1.13.0]
	... 4 more
```
