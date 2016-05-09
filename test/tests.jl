


module transitest

	using FactCheck, student

	context("checking the result of the transitivity check function") do

		facts("violation of the transitivity assumption") do
			d=Dict("a1"=>10.0,"a2"=>13.0,"a3"=>8.0)
			res=student.checktransi(d)
			@fact res["result"] --> false
			d=Dict("a1"=>10.0,"a2"=>8.0,"a3"=>12.0)
			res=student.checktransi(d)
			@fact res["result"] --> false
			d=Dict("a1"=>12.0,"a2"=>8.0,"a3"=>10.0)
			res=student.checktransi(d)
			@fact res["result"] --> false
			d=Dict("a1"=>8.0,"a2"=>12.0,"a3"=>10.0)
			res=student.checktransi(d)
			@fact res["result"] --> false
		end
		facts("Transitivity not violated") do
			d=Dict("a1"=>16.0,"a2"=>13.0,"a3"=>8.0)
			res=student.checktransi(d)
			@fact res["result"] --> true
			@fact res["type"] --> "ALL"
			d=Dict("a1"=>7.0,"a2"=>13.0,"a3"=>15.0)
			res=student.checktransi(d)
			@fact res["result"] --> true
			@fact res["type"] --> "NH"
		end

	end



end
