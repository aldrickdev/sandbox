sandbox() {
    local name="$1"
    local dest_dir="$PWD"

    # check if the sandbox root exists
    if [ ! -d "$SANDBOX_HOME" ]; then
        echo "Sandbox root not found: $SANDBOX_HOME"
        return 1
    fi

    # if no name is provided, list the available sandboxes
    if [ -z "$name" ]; then
        echo "Usage: sandbox <directory_name> [optional: destination_name]"
        echo "Available sandboxes in $SANDBOX_HOME:"
        dirs=$(find "$SANDBOX_HOME" -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec basename {} \; | sort)
        if [ -z "$dirs" ]; then
            echo "(none)"
        else
            printf '%s\n' "$dirs"
        fi
        return 1
    fi

    # check if the sandbox selected exists
    local src="$SANDBOX_HOME/$name"
    if [ ! -d "$src" ]; then
        echo "Sandbox '$name' not found in $SANDBOX_HOME"
        echo "Available sandboxes:"
        dirs=$(find "$SANDBOX_HOME" -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec basename {} \; | sort)
        if [ -z "$dirs" ]; then
            echo "(none)"
        else
            printf '%s\n' "$dirs"
        fi
        return 1
    fi

    # if no destination name is provided, use the sandbox name
    local dest_name="${2:-$name}"
    local dest_path="$dest_dir/$dest_name"

    # check if the destination path already exists
    if [ -e "$dest_path" ]; then
        echo "Destination '$dest_path' already exists; aborting."
        return 1
    fi

    # copy the sandbox to the destination path
    echo "Copying '$src' -> '$dest_path'..."
    cp -R "$src" "$dest_path"
    echo "Done."
}