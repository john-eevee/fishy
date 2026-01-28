function emu_create --description "Create a new Android emulator"
    if test (count $argv) -lt 2
        echo "Usage: emu_create <name> <api_level> [system-image-type]"
        echo ""
        echo "Example: emu_create my-pixel-5 30 google_apis"
        echo ""
        echo "System image types: default, google_apis, google_apis_playstore"
        return 1
    end
    
    set -l name $argv[1]
    set -l api $argv[2]
    set -l image_type (test -n "$argv[3]"; and echo $argv[3]; or echo "google_apis")
    
    if not command -v avdmanager &>/dev/null
        echo "Error: avdmanager not found. Ensure Android SDK is installed."
        return 1
    end
    
    echo "Creating emulator: $name"
    echo "  API Level: $api"
    echo "  System Image: $image_type"
    echo ""
    
    set -l image_name "system-images;android-$api;$image_type;x86_64"
    
    avdmanager create avd \
        -n "$name" \
        -k "$image_name" \
        -d "pixel_5" \
        --force
    
    if test $status -eq 0
        echo "✓ Emulator '$name' created successfully!"
        echo ""
        echo "Start it with: emu_start $name"
    else
        echo "✗ Failed to create emulator."
        return 1
    end
end
