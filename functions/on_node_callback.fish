function on_node_callback --description "Actions to perform when entering a Node.js project directory"
    if test -f "package.json"
        # Check if node_modules exists; if not, run npm install
        if not test -d "node_modules"
            log -l info "node_modules not found. Running 'npm install'..."
            npm install
            log -l info "'npm install' completed."
        end

        # Optionally, you can add more Node.js specific setup here
    end
end
