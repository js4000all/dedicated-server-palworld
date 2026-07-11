FROM cm2network/steamcmd
LABEL maintainer="js4000all@gmail.com" version="0.1.0"

ARG PAL_HOME=/opt/palworld

WORKDIR ${PAL_HOME}
RUN set -x \
  && /home/steam/steamcmd/steamcmd.sh +force_install_dir "${PAL_HOME}" +login anonymous +app_update 2394010 validate +quit \
  && mkdir -p ${PAL_HOME}/Pal/Saved
CMD [ "./PalServer.sh" ]
VOLUME [ "${PAL_HOME}/Pal/Saved" ]
