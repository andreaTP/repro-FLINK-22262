lazy val helloWorld =  (project in file("."))
    .enablePlugins(CloudflowApplicationPlugin, CloudflowFlinkPlugin, CloudflowNativeFlinkPlugin)
    .settings(
      scalaVersion := "2.12.11",
      name := "hello-world",
      resolvers += "Flink 13.0 RC0".at("https://repository.apache.org/content/repositories/orgapacheflink-1417/"),
      baseDockerInstructions := flinkNativeCloudflowDockerInstructions.value,
      libraryDependencies ~= fixFlinkNativeCloudflowDeps
  )
