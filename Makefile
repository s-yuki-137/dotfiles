.PHONY: init-react help

init-react: ## init react app
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
		npm install -g eslint && \
		npm install redux && \
		npm install react-redux && \
		npx -p @storybook/cli sb init
endef

define show_help
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
        | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[35m%-13s\033[0m %s\n", $$1, $$2}'
endef