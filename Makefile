all:
	@echo "Nothing to compile."

# Run default (my username and password)
run:
	./crawler ching.b 6974dd7def9dd483b3aa3b5b9d65f34ea201582524fb585311fb9e224f8baed3

clean:
	rm -f __pycache__ *.pyc