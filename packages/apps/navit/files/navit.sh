#!/bin/sh

APP_DIR=$(dirname $0)
if [ "x${APP_DIR}" == "x." ]
then
	APP_DIR=$(pwd)
fi

eval $(${APP_DIR}/bin/pdl-helper)

export NAVIT_USER_DATADIR=${PDL_DataFilePath}
export LD_LIBRARY_PATH=${APP_DIR}/lib:/media/internal/.widk/usr/lib

unset LC_ALL
export LANG=${PDL_Language}.UTF-8

if [ -e ${NAVIT_USER_DATADIR}/lang-override ]
then
	export LANG=$(cat ${NAVIT_USER_DATADIR}/lang-override)
fi

export SPEECHD_SOCKET=/tmp/speechd-sock

export NAVIT_LOGFILE=${NAVIT_USER_DATADIR}/navit.log

test -d ${NAVIT_USER_DATADIR} || mkdir -p ${NAVIT_USER_DATADIR}/maps

# Rotate logs (in background)
for i in 8 7 6 5 4 3 2 1
do
	mv ${NAVIT_LOGFILE}.${i}.gz ${NAVIT_LOGFILE}.$((i+1)).gz || true
done
mv ${NAVIT_LOGFILE} ${NAVIT_LOGFILE}.1 && gzip --best ${NAVIT_LOGFILE}.1 || true
touch ${NAVIT_LOGFILE}

#test startup command
rm -f ${NAVIT_USER_DATADIR}/command1.txt
if [ -e ${NAVIT_USER_DATADIR}/command.txt ]
then
        #first line is the target position, second line are the commands
        mv  ${NAVIT_USER_DATADIR}/command.txt ${NAVIT_USER_DATADIR}/command1.txt
        CMD="-s ${NAVIT_USER_DATADIR}/command1.txt"
        rm -f ${NAVIT_USER_DATADIR}/command.txt
fi

echo "------------------------- Start Navit ----------------------------------" >> ${NAVIT_LOGFILE}
date >> ${NAVIT_LOGFILE}
echo "exec ${APP_DIR}/bin/navit ${CMD} -c ${NAVIT_USER_DATADIR}/navit.xml" >> ${NAVIT_LOGFILE}

if [ ! -e ${NAVIT_USER_DATADIR}/navit.xml ]
then
	DEVICE=$(grep "^BUILDNAME=" /etc/palm-build-info | sed -re "s/.*=Nova-[^-]+-(.*)/\1/")
	cp -R ${APP_DIR}/dist_files/* ${NAVIT_USER_DATADIR}/
	cp -R ${APP_DIR}/dist_files.${DEVICE}/* ${NAVIT_USER_DATADIR}/
	find ${NAVIT_USER_DATADIR} -name "*.xml" | \
		while read l
		do
			md5sum ${l} > ${l}.md5sum
		done
fi

pgrep "^navit$" || exec ${APP_DIR}/bin/navit ${CMD} -c ${NAVIT_USER_DATADIR}/navit.xml

