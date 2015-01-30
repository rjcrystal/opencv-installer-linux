if ! [ $(id -u) = 0 ]; then
   echo "This installer must be run as root :/"
   exit 1
fi
mkdir setup
cd setup
cores=$(grep -c ^processor /proc/cpuinfo)
cores=$(($cores * 2))
echo -n "update sources and install Dependencies (y for yes : n for no )> "
read text
if [ "$text" = "y" ]; then
	echo "updating repos"
	sudo apt-get update
	echo "removing old ffmpeg and x264"
	sudo apt-get remove ffmpeg x264 libx264-dev
	echo "installing dependencies for ffmpeg and x264"
	sudo apt-get install build-essential checkinstall git cmake libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev 		libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev
	echo "installing gstreamer and gtk"
	sudo apt-get install libgstreamer0.10-0 libgstreamer0.10-dev gstreamer0.10-tools gstreamer0.10-plugins-base libgstreamer-plugins-base0.10-dev         		gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg libgtk2.0-0 libgtk2.0-dev libjpeg8 libjpeg8-dev axel
	echo "installing cmake"
	sudo apt-get install cmake cmake-curses-gui
fi
echo -n "download and compile x264 ? (y for yes : n for no )> "
read text
if [ "$text" = "y" ]; then
	echo "downloading x264"
	axel ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
	echo "extracting x264"
	tar jxf last_x264.tar.bz2
	echo "setting up x264"
	cd x264*
	Sourcesystem=$(uname -m)
	if [ "$Sourcesystem" = "x86_64" ]; then 
		echo "configuring for 64-bit system"
		./configure --enable-shared --enable-pic
	else
		echo "configuring for 32-bit system"
		./configure --enable-static  
	fi;
	echo "compiling x264"
	make -j$cores   
	echo "installing x264"
	sudo make install 
	cd ..
fi
echo -n "download and compile ffmpeg ? (y for yes : n for no )> "
read text
if [ "$text" = "y" ]; then

	echo "downloading ffmpeg "
	axel http://www.ffmpeg.org/releases/ffmpeg-2.5.3.tar.gz
	echo "ffmpeg download complete"
	tar xzf ffmpeg-2.5.3.tar.gz
	cd ffmpeg*
	if [ "$Sourcesystem" = "x86_64" ]; then 
		echo "configuring for 64-bit system"
		./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora 			--enable-libvorbis --enable-libx264 --enable-libxvid --enable-nonfree --enable-postproc --enable-version3 --enable-x11grab --enable-shared 			--enable-pic	
	else
		echo "configuring for 32-bit system"
		./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora 			--enable-libvorbis --enable-libx264 --enable-libxvid --enable-nonfree --enable-postproc --enable-version3 --enable-x11grab
	fi;
	echo "compiling x264"
	make -j$cores   
	echo "installing x264"
	sudo make install
	cd ..
fi
echo -n "download and compile video for linux utils ? (y for yes : n for no )>  "
read text
if [ "$text" = "y" ]; then
	echo "downloading v4l-utils"
	axel http://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.6.2.tar.bz2
	echo "v4l-utils download complete"
	tar xjf v4l-utils-1.6.2.tar.bz2
	cd v4l-utils*
	./configure
	echo "compiling v4l-utils"
	make -j$cores   
	echo "installing v4l-utils"
	sudo make install
	cd ..
fi
echo -n "download and compile opencv 2.4.10 ? (y for yes : n for no )>  "
read text
if [ "$text" = "y" ]; then
	echo -n "download from ? (s for sourceforge (archive) : g for github (clone git repo))>  "
	read text
	if [ "$text" = "s" ]; then
		axel http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip/download
	else 
		git clone git://github.com/Itseez/opencv.git
		cd opencv*
		git checkout 2.4.10
		
	



