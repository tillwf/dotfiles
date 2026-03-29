#!/usr/bin/env bash
set -euo pipefail

# Picture viewer that randomly browses image folders using feh.
# Usage: picture_viewer.sh [directory]

IMAGE_EXTS='jpg|jpeg|png|gif|bmp|webp'

# --- Dependency check ---
if ! command -v feh &>/dev/null; then
    echo "feh is not installed. Install with: sudo apt install feh" >&2
    exit 1
fi

# --- Root directory ---
ROOT_DIR="${1:-.}"
ROOT_DIR="$(realpath "$ROOT_DIR")"
if [[ ! -d "$ROOT_DIR" ]]; then
    echo "Not a directory: $ROOT_DIR" >&2
    exit 1
fi

# --- Discover image folders ---
mapfile -t FOLDERS < <(
    find "$ROOT_DIR" -type f -regextype posix-extended \
        -iregex ".*\\.($IMAGE_EXTS)" -printf '%h\n' | sort -u
)

if [[ ${#FOLDERS[@]} -eq 0 ]]; then
    echo "No images found in $ROOT_DIR" >&2
    exit 1
fi

echo "Found ${#FOLDERS[@]} image folder(s) in $ROOT_DIR"

# --- State ---
declare -A VISITED
HISTORY=()          # stack of folder indices (back)
FORWARD=()          # stack of folder indices (forward)
CURRENT_IDX=-1
ACTION="random"     # "random" = pick new folder, "prev" = pop history, "next" = pop forward

# --- Temp files ---
TMPDIR_FEH="$(mktemp -d)"
CTRL="$TMPDIR_FEH/ctrl"
FEH_CONFIG="$TMPDIR_FEH/feh_config"

cleanup() {
    rm -rf "$TMPDIR_FEH"
}
trap cleanup EXIT
trap 'exit 0' INT

# --- feh keys config ---
mkdir -p "$FEH_CONFIG/feh"
cat > "$FEH_CONFIG/feh/keys" <<'EOF'
next_img Right
prev_img Left
zoom_fit f
zoom_fill w
scroll_up Up
scroll_down Down space
toggle_info i
quit
action_1 b
action_2 q Escape
action_3 n
EOF

# --- Pick random unvisited folder ---
pick_random() {
    local available=()
    for i in "${!FOLDERS[@]}"; do
        if [[ -z "${VISITED[$i]+x}" ]]; then
            available+=("$i")
        fi
    done

    # All visited — reset, but exclude current to avoid immediate repeat
    if [[ ${#available[@]} -eq 0 ]]; then
        VISITED=()
        if [[ $CURRENT_IDX -ge 0 ]]; then
            VISITED[$CURRENT_IDX]=1
        fi
        for i in "${!FOLDERS[@]}"; do
            if [[ -z "${VISITED[$i]+x}" ]]; then
                available+=("$i")
            fi
        done
        # Single folder edge case
        if [[ ${#available[@]} -eq 0 ]]; then
            available=(0)
        fi
    fi

    local rand_pos=$(( RANDOM % ${#available[@]} ))
    CURRENT_IDX="${available[$rand_pos]}"
    VISITED[$CURRENT_IDX]=1
}

# --- Launch feh for current folder ---
show_folder() {
    local folder="${FOLDERS[$CURRENT_IDX]}"
    local -a images
    mapfile -t images < <(
        find "$folder" -maxdepth 1 -type f -regextype posix-extended \
            -iregex ".*\\.($IMAGE_EXTS)" | sort
    )

    if [[ ${#images[@]} -eq 0 ]]; then
        return 1
    fi

    local rel_path="${folder#"$ROOT_DIR"}"
    rel_path="${rel_path#/}"
    if [[ -z "$rel_path" ]]; then
        rel_path="$(basename "$ROOT_DIR")"
    fi

    rm -f "$CTRL"

    local -a feh_args=(
        --fullscreen
        --auto-zoom
        --image-bg black
        --scroll-step 80
        --on-last-slide quit
        --info "echo '${rel_path}  (%u/%l)'"
        --action1 "echo prev > '${CTRL}'; kill \$PPID"
        --action2 "echo quit > '${CTRL}'; kill \$PPID"
        --action3 "echo next > '${CTRL}'; kill \$PPID"
    )

    XDG_CONFIG_HOME="$FEH_CONFIG" feh "${feh_args[@]}" "${images[@]}" || true
}

# --- Main loop ---
while true; do
    case "$ACTION" in
        random)
            # Save current to history before picking new (if we have a current)
            if [[ $CURRENT_IDX -ge 0 ]]; then
                HISTORY+=("$CURRENT_IDX")
            fi
            # Check forward stack first, otherwise pick random
            if [[ ${#FORWARD[@]} -gt 0 ]]; then
                CURRENT_IDX="${FORWARD[-1]}"
                unset 'FORWARD[-1]'
            else
                FORWARD=()
                pick_random
            fi
            ;;
        prev)
            if [[ ${#HISTORY[@]} -gt 0 ]]; then
                # Push current onto forward stack so we can return to it
                if [[ $CURRENT_IDX -ge 0 ]]; then
                    FORWARD+=("$CURRENT_IDX")
                fi
                CURRENT_IDX="${HISTORY[-1]}"
                unset 'HISTORY[-1]'
            else
                # No history — just pick random
                pick_random
            fi
            ;;
    esac

    if ! show_folder; then
        ACTION="random"
        continue
    fi

    # Handle control file from feh actions
    if [[ -f "$CTRL" ]]; then
        ctrl_cmd="$(cat "$CTRL")"
        if [[ "$ctrl_cmd" == "quit" ]]; then
            exit 0
        elif [[ "$ctrl_cmd" == "prev" ]]; then
            ACTION="prev"
            continue
        elif [[ "$ctrl_cmd" == "next" ]]; then
            ACTION="random"
            continue
        fi
    fi
    ACTION="random"
done
