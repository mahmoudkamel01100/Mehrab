allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureProject = Runnable {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val method = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                method.invoke(android, 36)
            } catch (e: Exception) {
                // Ignore
            }
        }
    }
    
    if (project.state.executed) {
        configureProject.run()
    } else {
        project.afterEvaluate {
            configureProject.run()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
