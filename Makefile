# Makefile

# Архітектура 
ARCHITECTURES = linux arm macos windows

# Вибір архітектури
.PHONY: $(ARCHITECTURES)

# Збирання контейнеру
define build_target
$(1):
	@echo "Building for $(1)..."
	@docker build -t myproject:$(1) --build-arg TARGET=$(1) .
endef

# Виклик цілі для кожної архітектури
$(foreach arch,$(ARCHITECTURES),$(eval $(call build_target,$(arch))))

# Видалення
clean:
	@echo "Cleaning up..."
	@docker rmi <IMAGE_TAG>:latest 