.PHONY : clean cleanall

clean:
	rm -f dummy *.cnt *.cpt *.snts *.coast

cleanall: clean
	rm -f dummy *.stns *.txt *.ps *.orig

