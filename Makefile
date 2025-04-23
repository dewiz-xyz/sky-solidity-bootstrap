PATH := ~/.solc-select/artifacts/solc-0.8.24:$(PATH)
certora-counter:; PATH=${PATH} certoraRun certora/Counter.conf$(if $(rule), --rule $(rule),)

