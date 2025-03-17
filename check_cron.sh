#!/bin/bash

USER=$(whoami)
WORKDIR="/home/${USER}/.nezha-agent"
FILE_PATH="/home/${USER}/.s5"
FILE_PATH1="/home/${USER}/serv00-play/singbox"
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >/dev/null 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
PM2_PATH="/home/${USER}/.npm-global/lib/node_modules/pm2/bin/pm2"
CRON_JOB="*/12 * * * * $PM2_PATH resurrect >> /home/$(whoami)/pm2_resurrect.log 2>&1"
CRON_SB="nohup ${FILE_PATH1}/serv00sb run -c ${FILE_PATH1}/config.json >/dev/null 2>&1 &"
REBOOT_COMMAND="@reboot pkill -kill -u $(whoami) && $PM2_PATH resurrect >> /home/$(whoami)/pm2_resurrect.log 2>&1"

echo "检查并添加 crontab 任务"

if [ "$(command -v pm2)" == "/home/${USER}/.npm-global/bin/pm2" ]; then
  echo "已安装 pm2，并返回正确路径，启用 pm2 保活任务"
  (crontab -l | grep -F "$REBOOT_COMMAND") || (crontab -l; echo "$REBOOT_COMMAND") | crontab -
  (crontab -l | grep -F "$CRON_JOB") || (crontab -l; echo "$CRON_JOB") | crontab -
else
  if [ -e "${WORKDIR}/start.sh" ] && [ -e "${FILE_PATH}/config.json" ]; then
    echo "添加 nezha & socks5 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_S5} && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_S5} && ${CRON_NEZHA}") | crontab -
    #(crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/12 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    #(crontab -l | grep -F "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
    #(crontab -l | grep -F "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
    #(crontab -l | grep -F "@reboot top  | grep serv00sb > /dev/null  || eval  ${CRON_SB}") ||   (crontab -l; echo "@reboot top  | grep serv00sb > /dev/null ||eval  ${CRON_SB}") | crontab -
    #(crontab -l | grep -F "*/5 * * * * top  | grep serv00sb > /dev/null || eval  ${CRON_SB}")||  (crontab -l; echo "*/5 * * * * top  | grep serv00sb > /dev/null || eval  ${CRON_SB}") | crontab -
  
  elif [ -e "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
  elif [ -e "${FILE_PATH}/config.json" ]; then
    echo "添加 socks5 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_S5}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_S5}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/12 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    #(crontab -l | grep -F "@reboot top  | grep serv00sb > /dev/null  || eval  ${CRON_SB}") ||   (crontab -l; echo "@reboot top  | grep serv00sb > /dev/null ||eval  ${CRON_SB}") | crontab -
    #(crontab -l | grep -F "*/5 * * * * top  | grep serv00sb > /dev/null || eval  ${CRON_SB}")||  (crontab -l; echo "*/5 * * * * top  | grep serv00sb > /dev/null || eval  ${CRON_SB}") | crontab -
    #(crontab -l | grep -F "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
    #(crontab -l | grep -F "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
  elif [ -e "${FILE_PATH1}/config.json" ]; then
    echo "添加 sb 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && bash ${FILE_PATH1}/sb.sh") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && bash ${FILE_PATH1}/sb.sh") | crontab -
    (crontab -l | grep -F "*/5 * * * * bash ${FILE_PATH1}/sb.sh") || (crontab -l; echo "*/5 * * * * bash ${FILE_PATH1}/sb.sh") | crontab -
     bash ${FILE_PATH1}/sb.sh
  fi
fi
echo "检查并添加和启动 sb 任务"
if [ -e "${FILE_PATH1}/config.json" ]; then
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && (cd ${FILE_PATH1} && /bin/bash ${FILE_PATH1}/sb.sh > /dev/null)") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && (cd ${FILE_PATH1} && /bin/bash ${FILE_PATH1}/sb.sh > /dev/null)") | crontab -
    (crontab -l | grep -F "*/5 * * * * cd ${FILE_PATH1} && /bin/bash ${FILE_PATH1}/sb.sh") || (crontab -l; echo "*/5 * * * * cd ${FILE_PATH1} && /bin/bash ${FILE_PATH1}/sb.sh") | crontab -
    cd ${FILE_PATH1} && bash ${FILE_PATH1}/sb.sh
  fi
