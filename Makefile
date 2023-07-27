CACHE_DIR := ./cache
VENV_DIR := ./venv

cache/bin/receptor:
	@echo "Downloading receptor..."
	mkdir -p $(CACHE_DIR)/
	curl -s -L -o $(CACHE_DIR)/receptor.tar.gz https://github.com/ansible/receptor/releases/download/v1.4.1/receptor_1.4.1_linux_amd64.tar.gz
	tar -xzf $(CACHE_DIR)/receptor.tar.gz -C $(CACHE_DIR)/
	mkdir -p cache/bin/
	mv $(CACHE_DIR)/receptor $(CACHE_DIR)/bin/receptor
	rm -f $(CACHE_DIR)/receptor.tar.gz
	chmod +x $(CACHE_DIR)/bin/receptor

venv:
	@echo "Creating virtualenv..."
	python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install --upgrade pip setuptools wheel
	$(VENV_DIR)/bin/pip install -r requirements.txt

clean:
	rm -rf $(CACHE_DIR)/

watch-status:
	watch -c -d -t -n 1  $(VENV_DIR)/bin/receptorctl --socket /tmp/receptorctltest/simple/node1.sock status

watch-files:
	watch -c -d -t -n 1 tree -shC /tmp/receptorctltest/

example-work-submit:
	receptorctl --socket /tmp/receptorctltest/simple/node1.sock \
		work submit -f --node node3 --payload-literal "I like coffee" echo-uppercase
