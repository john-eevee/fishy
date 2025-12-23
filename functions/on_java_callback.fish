function on_java_callback --description "Actions to perform when entering a Java project directory"
    if test -f "pom.xml"
        # Maven project detected
        if not test -d "target"
            log -l info "Maven target directory not found. Running 'mvn clean install -DskipTest'..."
            ./mvnw clean install
            log -l info "'mvn clean install -DskipTest' completed."
        end
    else if test -f "build.gradle" -o -f "build.gradle.kts"
        # Gradle project detected
        if not test -d "build"
            log -l info "Gradle build directory not found. Running 'gradle build'..."
            ./gradlew build
            log -l info "'gradle build' completed."
        end
    end
    # Optionally, you can add more Java-specific setup here
    # For example, setting environment variables or aliases
end
