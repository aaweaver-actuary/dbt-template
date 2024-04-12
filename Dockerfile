FROM ubuntu:noble-20240225

WORKDIR /app

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get full-upgrade -y \
    && apt-get install -y \
        zsh \
        git \
        curl \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        python3-setuptools \
        python3-wheel\
\
    && python3 -m venv /app/.venv \
    && . /app/.venv/bin/activate \
    && pip install dbt-core dbt-snowflake \
\
    && exec zsh \
\
    && git clone http://github.com/aaweaver-actuary/dotfiles \
    && cp ./dotfiles/install_dotfiles /usr/bin/install_dotfiles \
    && chmod 777 /usr/bin/install_dotfiles \
    && rm -rf ./dotfiles \
\
    && install_dotfiles /app .ruff.toml .mypy.ini pytest.ini .prettierrc \
    && install_dotfiles $HOME install_oh_my_zsh

SHELL ["/bin/zsh"]

RUN install_dotfiles /app install_oh_my_zsh \
    && chmod +x /app/install_oh_my_zsh

RUN . /app/install_oh_my_zsh \
    && rm /app/install_oh_my_zsh \
    && install_dotfiles $HOME .zshrc .zsh_aliases \
    && exec zsh

CMD ["/bin/zsh"]
