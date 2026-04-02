alias c='clear'
alias ll='ls -la'
alias ls='ls --color'
alias l='ls --color'
alias l.='ls -d .* --color=auto'
alias c="clear"
alias l.='ls -d .* --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias duh='du -sh'
alias dus='du -sh * |sort -n'
alias findname='find . -name '
alias findloc='/usr/local/bin/findloc.sh'
alias findcs='find . -name "*.cs"'
alias findjs2='find . -name "*.js"'
alias findjs='find . -name "*.js" |grep -v "jquery" |grep -v "plugin" |grep -v "Lib" |grep -v "bootstrap" '
alias findpy='find . -name "*.py"'
alias findsln='find . -name "*.sln" && find . -name "*.csproj"'
alias findbak='find . -name "*.back" && find . -name "*.bak"'
alias grepcs='find . -name "*.cs" | xargs grep -rni '
alias grepcs2='find . -name "*.cs" | xargs grep -rn '
alias grr='grep -r'
alias grl='grep -rl'
alias grli='grep -rli'
alias grn='grep -rn'
alias grni='grep -rni'

alias api='sudo apt-get install -y '
alias sourcebash='source ~/.bash_aliases'
alias hist='history'

# Networks
alias netpentl='sudo netstat -pentl'
#



# System

alias gst='git status'
alias gitst='git status |grep -v "OtherApps" '
alias gitpom='git push origin master'
alias gitpuo='git pull origin '
alias gitpo='git push origin '
alias gitp='git pull'
alias gitpuo='git pull origin '
alias gitco='git checkout'
alias gitdf='git diff'
alias gitlog='git log'
alias gitcm='git commit -m '
alias gitcmnr='git log |grep commit |wc -l'
alias gitfc='git show --pretty="format:" --name-only ' # show commit files change only
alias gitpf='git push -f origin '
alias gitdn='git diff --name-only '


# Docker
alias dkrmi='sudo docker rmi '
alias dkrm='sudo docker rm '
alias dkim='sudo docker images'
alias dkstp='sudo docker stop '
alias dkima='sudo docker images -a'
alias dkps='sudo docker ps'
alias dkpsa='sudo docker ps -a'
alias dkinspt='sudo docker inspect '
alias dkprunea='sudo docker system prune -a '
alias dkhist='sudo docker history '
alias dkrename='sudo docker remame '
alias dkbash='sudo docker exec -i -t $1 /bin/bash'
alias dkst='sudo docker stats '
alias dkhlp='cat ~/.COPY/.dockerone'
alias dkvl='sudo docker volume ls '
alias dkvlisp='sudo docker volume inspect '
alias dk='sudo docker '
alias dkhist='sudo docker history '
alias dknetw='sudo docker network ls'
alias dkattach='sudo docker attach '


alias cal3='cal -3 && ncal 2026'

#Kubernetes k8s k3s
alias kc='sudo kubectl '
alias mkc='sudo microk8s kubectl '
alias mkc-st='sudo microk8s status'
