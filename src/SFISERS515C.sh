#! /bin/ksh

cd $HOME_SERVICIOS 

echo ""                                                                       > SFISERS515C.LOG
echo "**********************************************************************" >> SFISERS515C.LOG
echo "|************************** SFISERS515C.SH **************************|" >> SFISERS515C.LOG
echo "| FECHA : `date +'%Y-%m-%d %H:%M:%S'`"                                  >> SFISERS515C.LOG
echo "| WHOAMI: `whoami`"                                                     >> SFISERS515C.LOG
echo "| GROUPS: `groups`"                                                     >> SFISERS515C.LOG
echo "|********************************************************************|" >> SFISERS515C.LOG
echo "|--------------------------------------------------------------------|" >> SFISERS515C.LOG
echo "|                                                                    |" >> SFISERS515C.LOG
echo "| Cambio a directorio [$HOME_SERVICIOS]"                                >> SFISERS515C.LOG
echo "|--------------------------------------------------------------------|" >> SFISERS515C.LOG
echo "|                                                                    |" >> SFISERS515C.LOG
. ./VariablesEntorno.sh
echo "|                                                                    |" >> SFISERS515C.LOG
echo "|--------------------------------------------------------------------|" >> SFISERS515C.LOG

cd $HOME_SERVICIOS

echo "| Cambio a directorio [$HOME_SERVICIOS]"                                >> SFISERS515C.LOG
echo "| -------------------------------------------------------------------|" >> SFISERS515C.LOG
echo "|      Invocacion SFISERS515C.sh1 - inicio   "                          >> SFISERS515C.LOG
echo "|    /-------------------------------------\ "                          >> SFISERS515C.LOG
echo "|"                                                                      >> SFISERS515C.LOG

nohup ./SFISERS515C.sh1 >> SFISERS515C.LOG &

echo "|                                                                    |" >> SFISERS515C.LOG
echo "|    \-------------------------------------/ "                          >> SFISERS515C.LOG
echo "|      Invocacion SFISERS515C.sh1 - fin      "                          >> SFISERS515C.LOG
echo "|--------------------------------------------------------------------|" >> SFISERS515C.LOG
echo "**********************************************************************" >> SFISERS515C.LOG
echo ""
echo ""