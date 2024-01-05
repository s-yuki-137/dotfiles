.PHONY: npm-g-install init-brew install-go init-react help

npm-g-install: ## npm -g install
	@npm install -g eslint

init-brew: ## init brew
	@xcode-select --install && \
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

install-go:
	@brew install asdf && \
	echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zprofile && \
	source .zprofile && \
	asdf plugin-add golang https://github.com/kennyp/asdf-golang.git && \
	asdf install golang 1.18.1 && \
	asdf global golang 1.18.1 && \
	go version

init-react: ## init react app with redux, storybook (args:name="productName")
ifdef name
	$(call init_react, ${name})
else
	$(call init_react, "default-react-app")
endif

help: ## show help
	$(call show_help)

define init_react
	@cd .. && \
		npm init react-app $(1) && \
		cd $(1) && \
		npm install redux && \
		npm install react-redux && \
		npx -p @storybook/cli sb init
endef

define show_help
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
        | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[35m%-13s\033[0m %s\n", $$1, $$2}'
endef