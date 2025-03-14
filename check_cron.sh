#!/bin/bash

USER=$(whoami)
WORKDIR="/home/${USER}/.nezha-agent"
FILE_PATH="/home/${USER}/.s5"
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >/dev/null 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
PM2_PATH="/home/${USER}/.npm-global/lib/node_modules/pm2/bin/pm2"
CRON_JOB="*/12 * * * * $PM2_PATH resurrect >> /home/$(whoami)/pm2_resurrect.log 2>&1"
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
    (crontab -l | grep -F "@reboot ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") || (crontab -l; echo "@reboot ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") | crontab -
    (crontab -l | grep -F "*/30 * * * * ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") || (crontab -l; echo "*/30 * * * * ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") | crontab -
  elif [ -e "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
  elif [ -e "${FILE_PATH}/config.json" ]; then
    echo "添加 socks5 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_S5}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_S5}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/12 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    #(crontab -l | grep -F "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "@reboot bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
    (crontab -l | grep -F "@reboot ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") || (crontab -l; echo "@reboot ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") | crontab -
    (crontab -l | grep -F "*/30 * * * * ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") || (crontab -l; echo "*/30 * * * * ps aux | grep serv00sb | grep -v "grep" >/dev/null  ||  nohup /home/$(whoami)/serv00-play/singbox/serv00sb run -c /home/$(whoami)/serv00-play/singbox/config.json >/dev/null 2>&1") | crontab -
    #(crontab -l | grep -F "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") || (crontab -l; echo "*/30 * * * * bash /home/$(whoami)/serv00-play/singbox/start.sh > /dev/null 2>&1") | crontab -
  fi
fi
