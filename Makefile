.PHONY : clean cleanall

cruise-plan.ps: 
	./plan.s

cruise-plan.png: cruise-plan.ps
	convert -resample 300x300 $< $@


clean:
	@rm -f dummy *.cnt *.cpt *.snts *.coast *.centres

cleanall: clean
	@rm -f dummy *.stns *.txt *.ps *.orig

