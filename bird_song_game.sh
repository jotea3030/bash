#!/bin/sh

# Bird Song Game - Bash Version
# Requires: curl, jq, and an audio player (afplay on macOS, mpg123/ffplay/mplayer on Linux)

set -euo pipefail

# Wingspan Birds - All birds from base game and all expansions
declare -a WINGSPAN_BIRDS=(
    # Base Game - North America (170 birds)
    "Acorn Woodpecker" "American Avocet" "American Bittern" "American Coot"
    "American Crow" "American Goldfinch" "American Kestrel" "American Redstart"
    "American Robin" "American Tree Sparrow" "American White Pelican" "American Wigeon"
    "American Woodcock" "Anna's Hummingbird" "Bald Eagle" "Baltimore Oriole"
    "Band-tailed Pigeon" "Barn Owl" "Barn Swallow" "Barred Owl"
    "Belted Kingfisher" "Bewick's Wren" "Black Skimmer" "Black Vulture"
    "Black-bellied Plover" "Black-billed Magpie" "Black-capped Chickadee" "Black-chinned Hummingbird"
    "Blue Grosbeak" "Blue Jay" "Blue-gray Gnatcatcher" "Boat-tailed Grackle"
    "Brewer's Blackbird" "Broad-winged Hawk" "Brown Creeper" "Brown Pelican"
    "Brown-headed Cowbird" "Bushtit" "Cackling Goose" "California Condor"
    "California Gull" "Canada Goose" "Canvasback" "Carolina Wren"
    "Chestnut-backed Chickadee" "Chihuahuan Raven" "Chimney Swift" "Chipping Sparrow"
    "Clark's Grebe" "Common Grackle" "Common Loon" "Common Merganser"
    "Common Nighthawk" "Common Raven" "Common Yellowthroat" "Cooper's Hawk"
    "Dark-eyed Junco" "Dickcissel" "Double-crested Cormorant" "Downy Woodpecker"
    "Dunlin" "Eastern Bluebird" "Eastern Kingbird" "Eastern Meadowlark"
    "Eastern Phoebe" "Eastern Screech-Owl" "Eastern Towhee" "Eastern Wood-Pewee"
    "Evening Grosbeak" "Ferruginous Hawk" "Fish Crow" "Forster's Tern"
    "Fox Sparrow" "Franklin's Gull" "Gadwall" "Golden Eagle"
    "Golden-crowned Kinglet" "Gray Catbird" "Great Black-backed Gull" "Great Blue Heron"
    "Great Crested Flycatcher" "Great Egret" "Great Gray Owl" "Great Horned Owl"
    "Greater Prairie-Chicken" "Greater Roadrunner" "Greater Scaup" "Greater White-fronted Goose"
    "Greater Yellowlegs" "Green Heron" "Green-winged Teal" "Hairy Woodpecker"
    "Hermit Thrush" "Hooded Merganser" "Horned Grebe" "Horned Lark"
    "House Finch" "House Sparrow" "House Wren" "Indigo Bunting"
    "Killdeer" "Least Flycatcher" "Least Sandpiper" "Lesser Scaup"
    "Lesser Yellowlegs" "Lincoln's Sparrow" "Loggerhead Shrike" "Long-billed Curlew"
    "Long-billed Dowitcher" "Mallard" "Marbled Godwit" "Marsh Wren"
    "Mountain Bluebird" "Mourning Dove" "Mute Swan" "Northern Bobwhite"
    "Northern Cardinal" "Northern Flicker" "Northern Gannet" "Northern Harrier"
    "Northern Mockingbird" "Northern Pintail" "Northern Shoveler" "Osprey"
    "Painted Bunting" "Painted Whitestart" "Peregrine Falcon" "Pied-billed Grebe"
    "Pileated Woodpecker" "Prairie Falcon" "Purple Martin" "Pyrrhuloxia"
    "Red Crossbill" "Red Knot" "Red-bellied Woodpecker" "Red-breasted Merganser"
    "Red-breasted Nuthatch" "Red-headed Woodpecker" "Red-shouldered Hawk" "Red-tailed Hawk"
    "Red-winged Blackbird" "Ring-billed Gull" "Ring-necked Duck" "Ring-necked Pheasant"
    "Rock Pigeon" "Roseate Spoonbill" "Rose-breasted Grosbeak" "Royal Tern"
    "Ruby-crowned Kinglet" "Ruby-throated Hummingbird" "Ruddy Duck" "Ruddy Turnstone"
    "Ruffed Grouse" "Rufous Hummingbird" "Sanderling" "Sandhill Crane"
    "Savannah Sparrow" "Scaled Quail" "Scissor-tailed Flycatcher" "Sharp-shinned Hawk"
    "Short-eared Owl" "Snow Goose" "Snowy Egret" "Song Sparrow"
    "Spotted Sandpiper" "Spotted Towhee" "Steller's Jay" "Swainson's Hawk"
    "Tree Swallow" "Trumpeter Swan" "Tufted Titmouse" "Turkey Vulture"
    "Veery" "Vesper Sparrow" "Virginia Rail" "Western Grebe"
    "Western Gull" "Western Meadowlark" "Western Sandpiper" "Western Tanager"
    "White-breasted Nuthatch" "White-crowned Sparrow" "White-throated Sparrow" "Wild Turkey"
    "Willet" "Wilson's Snipe" "Wood Duck" "Wood Thrush"
    "Yellow Warbler" "Yellow-bellied Sapsucker" "Yellow-breasted Chat" "Yellow-rumped Warbler"
    
    # European Expansion (81 birds)
    "Audouin's Gull" "Black Redstart" "Black Woodpecker" "Black-headed Gull"
    "Black-tailed Godwit" "Black-throated Diver" "Bluethroat" "Bonelli's Eagle"
    "Bullfinch" "Carrion Crow" "Cetti's Warbler" "Coal Tit"
    "Common Blackbird" "Common Buzzard" "Common Chaffinch" "Common Chiffchaff"
    "Common Cuckoo" "Common Goldeneye" "Common Kingfisher" "Common Little Bittern"
    "Common Moorhen" "Common Nightingale" "Common Starling" "Common Swift"
    "Corsican Nuthatch" "Dunnock" "Eastern Imperial Eagle" "Eleonora's Falcon"
    "Eurasian Collared-Dove" "Eurasian Golden Oriole" "Eurasian Green Woodpecker" "Eurasian Hobby"
    "Eurasian Jay" "Eurasian Magpie" "Eurasian Nutcracker" "Eurasian Nuthatch"
    "Eurasian Sparrowhawk" "Eurasian Tree Sparrow" "European Bee-Eater" "European Goldfinch"
    "European Honey Buzzard" "European Robin" "European Roller" "European Turtle Dove"
    "Goldcrest" "Great Crested Grebe" "Great Tit" "Greater Flamingo"
    "Grey Heron" "Greylag Goose" "Griffon Vulture" "Hawfinch"
    "Hooded Crow" "House Sparrow" "Lesser Whitethroat" "Little Bustard"
    "Little Owl" "Long-tailed Tit" "Moltoni's Warbler" "Montagu's Harrier"
    "Mute Swan" "Northern Gannet" "Northern Goshawk" "Parrot Crossbill"
    "Red Kite" "Red Knot" "Red-backed Shrike" "Red-legged Partridge"
    "Ruff" "Savi's Warbler" "Short-toed Treecreeper" "Snow Bunting"
    "Snowy Owl" "Squacco Heron" "Thekla's Lark" "White Stork"
    "White Wagtail" "White-backed Woodpecker" "White-throated Dipper" "Wilson's Storm-Petrel"
    "Yellowhammer"
    
    # Oceania Expansion (95 birds)
    "Abbott's Booby" "Australasian Pipit" "Australasian Shoveler" "Australian Ibis"
    "Australian Magpie" "Australian Owlet-Nightjar" "Australian Raven" "Australian Reed Warbler"
    "Australian Shelduck" "Australian Zebra Finch" "Black Noddy" "Black Swan"
    "Black-shouldered Kite" "Blyth's Hornbill" "Brolga" "Brown Falcon"
    "Budgerigar" "Cockatiel" "Count Raggi's Bird-of-Paradise" "Crested Pigeon"
    "Crimson Chat" "Eastern Rosella" "Eastern Whipbird" "Emu"
    "Galah" "Golden-headed Cisticola" "Gould's Finch" "Green Pygmy-Goose"
    "Grey Butcherbird" "Grey Shrike-thrush" "Grey Teal" "Grey Warbler"
    "Grey-headed Mannikin" "Horsfield's Bronze-Cuckoo" "Horsfield's Bushlark" "Kakapo"
    "Kea" "Kelp Gull" "Kereru" "Korimako"
    "Laughing Kookaburra" "Lesser Frigatebird" "Lewin's Honeyeater" "Little Penguin"
    "Little Pied Cormorant" "Magpie-lark" "Major Mitchell's Cockatoo" "Malleefowl"
    "Maned Duck" "Many-colored Fruit-Dove" "Masked Lapwing" "Mistletoebird"
    "Musk Duck" "New Holland Honeyeater" "Noisy Miner" "North Island Brown Kiwi"
    "Orange-footed Scrubfowl" "Pacific Black Duck" "Peaceful Dove" "Pesquet's Parrot"
    "Pheasant Coucal" "Pink-eared Duck" "Plains-wanderer" "Princess Stephanie's Astrapia"
    "Pukeko" "Rainbow Lorikeet" "Red Wattlebird" "Red-backed Fairywren"
    "Red-capped Robin" "Red-necked Avocet" "Red-winged Parrot" "Regent Bowerbird"
    "Royal Spoonbill" "Rufous Banded Honeyeater" "Rufous Night Heron" "Rufous Owl"
    "Sacred Kingfisher" "Silvereye" "South Island Robin" "Southern Cassowary"
    "Spangled Drongo" "Splendid Fairywren" "Spotless Crake" "Stubble Quail"
    "Sulphur-crested Cockatoo" "Superb Lyrebird" "Tawny Frogmouth" "Tui"
    "Wedge-tailed Eagle" "Welcome Swallow" "White-bellied Sea-Eagle" "White-breasted Woodswallow"
    "White-faced Heron" "Willie Wagtail" "Wrybill"
    
    # Asia Expansion (90 birds)
    "Ashy Drongo" "Asian Barred Owlet" "Asian Emerald Cuckoo" "Asian Fairy-bluebird"
    "Asian Koel" "Asian Openbill" "Baikal Teal" "Bar-headed Goose"
    "Black Drongo" "Black Kite" "Black-crowned Night Heron" "Black-naped Monarch"
    "Black-naped Oriole" "Blue Rock Thrush" "Blue Whistling Thrush" "Cattle Egret"
    "Chinese Bamboo Partridge" "Chinese Grosbeak" "Cinereous Vulture" "Common Hoopoe"
    "Common Iora" "Common Kingfisher" "Common Myna" "Common Tailorbird"
    "Coppersmith Barbet" "Crested Serpent Eagle" "Crested Wood Partridge" "Dollarbird"
    "Eurasian Curlew" "Eurasian Hoopoe" "Forest Owlet" "Great Hornbill"
    "Great Indian Bustard" "Greater Adjutant" "Greater Coucal" "Greater Painted-Snipe"
    "Green Imperial Pigeon" "Hill Myna" "House Crow" "Indian Cormorant"
    "Indian Grey Hornbill" "Indian Peafowl" "Indian Pitta" "Indian Pond Heron"
    "Indian Roller" "Indian Vulture" "Japanese Bush Warbler" "Japanese Tit"
    "Jungle Crow" "Kalij Pheasant" "Large-billed Crow" "Long-tailed Minivet"
    "Long-tailed Shrike" "Mandarin Duck" "Narcissus Flycatcher" "Nutmeg Mannikin"
    "Oriental Magpie-Robin" "Oriental White-eye" "Pied Bushchat" "Pied Myna"
    "Pin-tailed Snipe" "Plain Prinia" "Puff-throated Babbler" "Purple Heron"
    "Purple Sunbird" "Red Junglefowl" "Red-billed Blue Magpie" "Red-vented Bulbul"
    "Red-wattled Lapwing" "Red-whiskered Bulbul" "Rock Pigeon" "Rook"
    "Rose-ringed Parakeet" "Rufous Treepie" "Scaly-breasted Munia" "Siberian Crane"
    "Spot-billed Duck" "Spotted Dove" "Striated Heron" "Tufted Duck"
    "Violet Cuckoo" "White Wagtail" "White-breasted Kingfisher" "White-rumped Shama"
    "White-throated Kingfisher" "Yellow-billed Babbler" "Yellow-browed Bunting" "Yellow-footed Green Pigeon"
)

# Game state
SCORE=0
TOTAL_QUESTIONS=0
CURRENT_AUDIO=""
TEMP_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
    if [[ -n "$CURRENT_AUDIO" ]] && [[ -f "$CURRENT_AUDIO" ]]; then
        rm -f "$CURRENT_AUDIO"
    fi
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

# Check dependencies
check_dependencies() {
    local missing=()
    
    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi
    
    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi
    
    # Check for audio player
    local has_player=false
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v afplay &> /dev/null; then
            has_player=true
        fi
    else
        for player in mpg123 ffplay mplayer play; do
            if command -v "$player" &> /dev/null; then
                has_player=true
                break
            fi
        done
    fi
    
    if [[ "$has_player" == "false" ]]; then
        missing+=("audio player (mpg123, ffplay, mplayer, or sox)")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies:"
        printf '  - %s\n' "${missing[@]}"
        exit 1
    fi
}

# Get a random bird
get_random_bird() {
    local count=${#WINGSPAN_BIRDS[@]}
    local index=$((RANDOM % count))
    echo "${WINGSPAN_BIRDS[$index]}"
}

# Fetch recording from Xeno-canto API
get_recording() {
    local bird_name="$1"
    local quality="$2"
    local base_url="https://xeno-canto.org/api/2/recordings"
    
    local query="$bird_name"
    if [[ -n "$quality" ]]; then
        query="$bird_name q:$quality"
    fi
    
    local encoded_query=$(echo -n "$query" | jq -sRr @uri)
    local url="${base_url}?query=${encoded_query}"
    
    local response=$(curl -s --max-time 60 "$url")
    
    # Filter for valid recordings (prefer xeno-canto.org URLs)
    local file_url=$(echo "$response" | jq -r '.recordings[] | select(.file != null and .file != "" and (.file | contains("xeno-canto.org"))) | .file' | head -n 1)
    
    # If no xeno-canto.org URL found, accept any valid URL
    if [[ -z "$file_url" ]]; then
        file_url=$(echo "$response" | jq -r '.recordings[] | select(.file != null and .file != "") | .file' | head -n 1)
    fi
    
    if [[ -n "$file_url" ]]; then
        # Get full recording info
        echo "$response" | jq -r --arg url "$file_url" '.recordings[] | select(.file == $url)'
    fi
}

# Download audio file
download_audio() {
    local audio_url="$1"
    local temp_file="${TEMP_DIR}/bird-$RANDOM.mp3"
    
    echo "Debug: Downloading from: $audio_url" >&2
    echo "Debug: Saving to: $temp_file" >&2
    
    if curl -v --max-time 60 -o "$temp_file" "$audio_url" 2>&1 | grep -q "HTTP.*200"; then
        if [[ -s "$temp_file" ]]; then
            echo "Debug: File downloaded successfully, size: $(stat -f%z "$temp_file" 2>/dev/null || stat -c%s "$temp_file" 2>/dev/null) bytes" >&2
            echo "$temp_file"
            return 0
        else
            echo "Debug: File downloaded but is empty" >&2
        fi
    else
        echo "Debug: curl failed or non-200 response" >&2
    fi
    
    rm -f "$temp_file"
    return 1
}

# Play audio file
play_audio() {
    local filename="$1"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - afplay doesn't need timeout, it stops automatically
        afplay "$filename" 2>/dev/null || true
    else
        # Try different players
        if command -v mpg123 &> /dev/null; then
            if command -v timeout &> /dev/null; then
                timeout 12s mpg123 -q "$filename" 2>/dev/null || true
            else
                mpg123 -q "$filename" 2>/dev/null || true
            fi
        elif command -v ffplay &> /dev/null; then
            ffplay -nodisp -autoexit -t 10 "$filename" 2>/dev/null || true
        elif command -v mplayer &> /dev/null; then
            mplayer "$filename" 2>/dev/null || true
        elif command -v play &> /dev/null; then
            play "$filename" 2>/dev/null || true
        else
            echo "No audio player found"
            return 1
        fi
    fi
}

# Generate multiple choice options
generate_options() {
    local correct_bird="$1"
    local options=("$correct_bird")
    
    while [[ ${#options[@]} -lt 4 ]]; do
        local count=${#WINGSPAN_BIRDS[@]}
        local index=$((RANDOM % count))
        local random_bird="${WINGSPAN_BIRDS[$index]}"
        
        # Check if already in options
        local found=false
        for opt in "${options[@]}"; do
            if [[ "$opt" == "$random_bird" ]]; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == "false" ]]; then
            options+=("$random_bird")
        fi
    done
    
    # Shuffle options (Fisher-Yates shuffle)
    for ((i=${#options[@]}-1; i>0; i--)); do
        j=$((RANDOM % (i+1)))
        temp="${options[i]}"
        options[i]="${options[j]}"
        options[j]="$temp"
    done
    
    printf '%s\n' "${options[@]}"
}

# Play one round
play_round() {
    # Clean up previous audio
    if [[ -n "$CURRENT_AUDIO" ]] && [[ -f "$CURRENT_AUDIO" ]]; then
        rm -f "$CURRENT_AUDIO"
        CURRENT_AUDIO=""
    fi
    
    # Select random bird
    local correct_bird=$(get_random_bird)
    
    echo "Fetching bird call for question $((TOTAL_QUESTIONS + 1))..."
    
    # Try to get recording with retries
    local recording=""
    local max_retries=5
    
    for ((attempt=1; attempt<=max_retries; attempt++)); do
        # Try quality A first, then B, then any
        for quality in "A" "B" ""; do
            recording=$(get_recording "$correct_bird" "$quality")
            if [[ -n "$recording" ]]; then
                break 2
            fi
        done
        
        if [[ $attempt -lt $max_retries ]]; then
            echo "Retry $attempt/$((max_retries - 1))..."
            sleep 1
        fi
    done
    
    if [[ -z "$recording" ]]; then
        echo "Error: Could not fetch recording for $correct_bird after $max_retries attempts"
        echo "Skipping this round..."
        return 0
    fi
    
    local file_url=$(echo "$recording" | jq -r '.file')
    echo "Found recording: $file_url"
    echo "Downloading audio (this may take a moment)..."
    
    # Download with retries
    local audio_file=""
    for ((attempt=1; attempt<=max_retries; attempt++)); do
        audio_file=$(download_audio "$file_url")
        if [[ -n "$audio_file" ]]; then
            break
        fi
        if [[ $attempt -lt $max_retries ]]; then
            echo "Download retry $attempt/$max_retries..."
            sleep 1
        fi
    done
    
    if [[ -z "$audio_file" ]]; then
        echo "Error downloading audio after $max_retries attempts"
        echo "Skipping this round..."
        return 0
    fi
    
    CURRENT_AUDIO="$audio_file"
    
    local file_size=$(stat -f%z "$audio_file" 2>/dev/null || stat -c%s "$audio_file" 2>/dev/null)
    echo "✓ Audio ready ($((file_size / 1024)) KB)"
    
    # Generate options (FIXED LINE - compatible with older bash)
    local IFS=$'\n'
    options=($(generate_options "$correct_bird"))
    
    # Play audio
    echo ""
    echo "🎵 Playing bird call..."
    play_audio "$audio_file"
    
    # Quiz loop
    while true; do
        echo ""
        echo "Which bird species is this?"
        echo ""
        
        for i in "${!options[@]}"; do
            echo "$((i + 1)). ${options[$i]}"
        done
        echo "R. Replay bird call"
        
        echo ""
        read -p "Your answer (1-4 or R to replay): " answer
        answer=$(echo "$answer" | tr '[:lower:]' '[:upper:]' | xargs)
        
        if [[ "$answer" == "R" ]]; then
            echo "🎵 Replaying bird call..."
            play_audio "$audio_file"
            continue
        fi
        
        if [[ ! "$answer" =~ ^[1-4]$ ]]; then
            echo "Invalid input! Please enter 1-4 or R"
            continue
        fi
        
        ((TOTAL_QUESTIONS++))
        
        local user_choice="${options[$((answer - 1))]}"
        
        if [[ "$user_choice" == "$correct_bird" ]]; then
            ((SCORE++))
            echo "✅ Correct! Well done!"
        else
            echo "❌ Incorrect! The correct answer was: $correct_bird"
        fi
        
        # Show recording info
        local loc=$(echo "$recording" | jq -r '.loc // ""')
        local cnt=$(echo "$recording" | jq -r '.cnt // ""')
        if [[ -n "$loc" ]] && [[ -n "$cnt" ]]; then
            echo "   Recording location: $loc, $cnt"
        fi
        
        local quality=$(echo "$recording" | jq -r '.q // ""')
        local length=$(echo "$recording" | jq -r '.length // ""')
        if [[ -n "$quality" ]]; then
            printf "   Quality: %s" "$quality"
            if [[ -n "$length" ]]; then
                printf " | Length: %s" "$length"
            fi
            echo ""
        fi
        
        # Option to replay after answering
        while true; do
            echo ""
            read -p "Listen again? (y/n): " replay
            replay=$(echo "$replay" | tr '[:upper:]' '[:lower:]' | xargs)
            
            if [[ "$replay" == "y" ]]; then
                echo "🎵 Replaying bird call..."
                play_audio "$audio_file"
            else
                break
            fi
        done
        
        break
    done
}

# Main function
main() {
    check_dependencies
    
    echo "🦅 Welcome to the Wingspan Bird Quiz! 🦅"
    echo "========================================"
    echo "Featuring birds from all Wingspan expansions!"
    echo "Listen to bird calls and guess the species!"
    echo ""
    
    while true; do
        play_round
        
        echo ""
        echo "Current Score: $SCORE/$TOTAL_QUESTIONS"
        echo ""
        
        read -p "Play another round? (y/n): " response
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]' | xargs)
        
        if [[ "$response" != "y" ]]; then
            break
        fi
        echo ""
    done
    
    echo ""
    echo "========================================"
    if [[ $TOTAL_QUESTIONS -gt 0 ]]; then
        local percentage=$(awk "BEGIN {printf \"%.1f\", ($SCORE / $TOTAL_QUESTIONS) * 100}")
        echo "Final Score: $SCORE/$TOTAL_QUESTIONS ($percentage%)"
    fi
    echo "Thanks for playing!"
}

main
