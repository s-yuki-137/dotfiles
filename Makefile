.PHONY: echo help

echo: ## sample
	@echo sample

help: ## show help
	$(call show_help)

define show_help
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  \
        | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[35m%-13s\033[0m %s\n", $$1, $$2}'
endef