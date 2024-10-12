#!/bin/bash

# Making a youtube downloader from a list
# This will accept a path to a file and a path to where to download, follow the instructions
# Yes i will make a hungarian version cause GF
# This is just a beta, probably the next one will have a TUI as well

# For yt-dlp all credits go to 

# It will what linux you have and it will check if you have yt-dlp, if not it will install it for you

release=/etc/os-release  #use this with the command -v option to check  if yt-dlp is present

os_type="Unknown"  #set this for the os type, to install yt-dlp

tool=yt-dlp

dependency=ffmpeg

tool_found=0 # This will be used in the check_tool() function. If 0 then no tool is present, if 1 the tool is there

lang=0 #Setting lang variable from here, otherwise weird shit is going down :O

pathoption=-P # Path to where to download the song(s) to
path_to_download_to=~/Music #Adding a default path if none is specified



if [ ! -f $release ]
then
    echo "No os-release file found on the system!!!"
    echo "Exiting now..."

    echo "Nem tudok futni ezen a rendszeren, szolj a hosszuhajunak ;) "
    echo "Jo legyel es szobatiszta :)))"

    exit 1
fi

# Function to set the tool_found to 0 if there is no tool and to 1 if there is a tool
check_tool()
{
    echo "Checking tool"

    if command -v $tool
    then
        tool_found=1
        echo "$tool Tool found, on to downloads..."

    else
        echo "$tool Tool not found, installing..."
        tool_found=0
    fi

    return $tool_found

}

check_tool_hun()
{
    echo "Szukseges programok ellenorzese"

    if command -v $tool
    then
        tool_found=1
        echo "$tool Megvan a szajre, lehet vergodni a letoltesekkel..."

    else
        echo "$tool Nincs cucc, fel kell csapni a gepre..."
        tool_found=0
    fi

    return $tool_found

}


# Check OS type to know how to install the tool in case it is needed
check_os_and_install ()
{

    if grep -q "Garuda Linux" $release #Find out the release type
    then

        echo "You are running Garuda Linux"
        echo "Installing yt-dlp and ffmpeg"


        echo "Update initiated for answer yes ..."

        garuda-update

        sudo pacman -S $tool $dependency


    elif grep -q "Arch" $release
    then

        echo "You are running an Arch based Linux distro"
        echo "Installing yt-dlp and ffmpeg"

        sudo pacman -Syu
        sudo pacman -S $tool $dependency


    elif grep -q "Debian" $release || grep -q "Ubuntu" $release || grep -q "Linux Mint" $release
    then
        echo "You are running a Debian/Ubuntu based Linux distro"
        echo "Installing yt-dlp and ffmpeg"

        sudo apt update
        sudo apt $tool $dependency


    fi

    
}

check_os_and_install_hun ()
{

    if grep -q "Garuda Linux" $release #Find out the release type
    then

        echo "Jelenleg eppen fut a Garuda Linux"
        echo "Csapjuk felfele a yt-dlp es ffmpeg programokat"

        garuda-update

        sudo pacman -S $tool $dependency


    elif grep -q "Arch" $release
    then

        echo "Vastag-faszu Arch alapu Linux distro szaladgal a joszagodon"
        echo "Telepitjuk a  yt-dlp es az ffmpeg progikat"

        sudo pacman -Syu
        sudo pacman -S $tool $dependency


    elif grep -q "Debian" $release || grep -q "Ubuntu" $release || grep -q "Linux Mint" $release
    then
        echo "Ezen a gyonyoru gepen repeszt a Debian/Ubuntu alapu Linux distro"
        echo "Felcsapjuk a fasza yt-dlp es ffmpeg progikat"

        sudo apt update
        sudo apt $tool $dependency


    fi

    
}


#The actual body of the downloader
download_function()
{
    echo "Wanna download some youtube stuff? y/n"

    read answer

    if [[ $answer == "y" || $answer == "Y" ]]
    then
        echo "You selected Yes"
        echo "Save all your links in a txt file, in a new line"
        echo "You may save playlists or single songs"
        echo "Lemme know when you're finished"

        read pausing

    elif [[ $answer == "n" || $answer == "N" ]]
    then
        echo "You selected No"
        echo "Bye!"

        exit 1

    else
        echo "Unavailable option"
        echo "Bye"

        exit 1

    fi



    echo "Give me the path to the txt file"
    echo "if the file is in the same folder with the script then just the filename"
    echo "if the file is in another place, relative paths are not supported... yet... :)"
    echo "Ensure it is correct"

    read zelist

    if [ -f $zelist ]
    then
        echo "File exists, we're in business"

    else
        echo "No file exists by this description, exiting, bye..."

        exit 1

    fi


    echo "Now give the path to where to download to, default is the Music folder in your home directory"

    read zepath

    if [ -d $zepath ]
    then
        echo "Path to download to is existent"

        # yt-dlp -x --audio-format mp3 -a test_song.txt
        $tool -x --audio-format mp3 -a $zelist $pathoption $zepath

    else
        echo "Path is non-existent, resorting to default download path, your Music folder"
        $tool -x --audio-format mp3 -a $zelist $pathoption $path_to_download_to

    fi
}

download_function_hun()
{
    echo "Leszurcsoljuk a youtube zeneket? y/n"

    read answer

    if [[ $answer == "y" || $answer == "Y" ]]
    then
        echo "Ha yes akkor legyen YES"
        echo "Csapd pe az osszes linket egy txt fajlba, aztan majd lassalak itt ujbol ;)"
        echo "A txt fajlba tehetsz playlist linket vagy egyedi szamok linkjet, mindet kulon sorba mentsd el, kulomben baszhatod"
        echo "Megvarlak, de nem jovo hetig, ha lehet..."

        read pausing

    elif [[ $answer == "n" || $answer == "N" ]]
    then
        echo "Nem kell a jo elet, akkor erigy kapalni :)"
        echo "Csa!"

        exit 1

    else
        echo "Ezt az opciot melyik reszebol az agyadnak rantottad ki?"
        echo "Cso vaz!"

        exit 1

    fi



    echo "Ird ide a txt fajl pontos helyet"
    echo "Ugy csinald hogy jo legyen es ne BAZD el a txt fajl utvonalat"

    read zelist

    if [ -f $zelist ]
    then
        echo "Letezik a fajl, ugyes vagy, tudsz irni es olvasni"

    else
        echo "Elbasztad, a fajl nem talalhato ..."

        exit 1

    fi


    echo "Most mond meg nekem hova rakjam azt a sok, remelhetoleg nem szar, zenet :)"

    read zepath

    if [ -d $zepath ]
    then
        echo "Megcsinaltad, megy ez mint az agybaszaras"
        echo "Jonnek le mindjart az fasza kis dalok"

        # yt-dlp -x --audio-format mp3 -a test_song.txt
        $tool -x --audio-format mp3 -a $zelist $pathoption $zepath

    else
        echo "Elbasztad, nincs ilyen hely, nah nem baj, megoldom en... :|"
        $tool -x --audio-format mp3 -a $zelist $pathoption $path_to_download_to

    fi
}




echo "Hi, english or magyar ;) "
echo "Type 1 for English, 2 for Magyar"

read lang

if [ $lang -eq 1 ]
then
    echo "Language chosen is English"

    check_tool

    if [ $tool_found -eq 0 ]
    then
        echo "Tool not found, should it be installed?"
        echo "Y or N"

        read answer

        if [[ $answer == "y" || $answer == "Y" ]]
        then
            echo "You selected Yes"
            check_os_and_install
        
        elif [[ $answer == "n" || $answer == "N" ]]
        then
            echo "Tool will not be installed"
            echo "Bye!"

            exit 1

        else
            echo "Unavailable option"
            echo "Bye"
            
            exit 1

        fi

    fi

    echo "Tool check OK"

    while :
    do

        download_function
    
    done


elif [ $lang -eq 2 ]
then
    echo "A Magyar nyelvet valasztottad"

        check_tool_hun

    if [ $tool_found -eq 0 ]
    then
        echo "Nincs meg a cucc, felcsapjam?"
        echo "Y or N"

        read answer

        if [[ $answer == "y" || $answer == "Y" ]]
        then
            echo "Mivel kell a szajre, nekiugrok"
            check_os_and_install_hun
        
        elif [[ $answer == "n" || $answer == "N" ]]
        then
            echo "Akkor mehetsz kapalni"
            echo "Bye!"

            exit 1

        else
            echo "Az ujjadbol szoptad ezt ki?"
            echo "Bye"
            
            exit 1

        fi

    fi

    echo "Minden fasza, kezdjetjuk faszikam :))"

    while :
    do

        download_function_hun
    
    done

fi

