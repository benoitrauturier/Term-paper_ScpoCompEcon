module student

  using PyPlot


  function makedata(lambda,gamma,ef,eh,pf,ph,r,w,alow,ahigh,beta,p=1.0)
    #=This functions simply returns a dictionary with the parameters of the model (given in argument)
    as well as the cutoff values for the different choices of education=#
    a1=(1 .+r).*(pf.-ph)./((lambda.*p.*(w.-1).+1).*(ef.^beta)-(gamma.*p.*(w.-1).+1).*(eh.^beta))
    a2=(1 .+r).*pf./((lambda.*p.*(w.-1).+1).*(ef.^beta))
    a3=(1 .+r).*ph./((gamma.*p.*(w.-1).+1).*(eh.^beta))
    return Dict("lambda"=>lambda,"gamma"=>gamma,"p"=>p,"ef"=>ef,"eh"=>eh,"pf"=>pf,"ph"=>ph,"r"=>r,"w"=>w,"alow"=>alow,"ahigh"=>ahigh,"beta"=>beta,"a1"=>a1,"a2"=>a2,"a3"=>a3)
  end
  function checktransi(d)
    #This funtion returns the results of the transitivity checks
    result=false
    typ="FAIL"
    if ((d["a1"]<=d["a2"]) & (d["a1"]<=d["a3"]) & (d["a2"]<=d["a3"]))
      result=true
      typ="NH"
    elseif ((d["a1"]>=d["a2"]) & (d["a1"]>=d["a3"]) & (d["a2"]>=d["a3"]))
      result=true
      typ="ALL"
    end
    return Dict("result"=>result,"type"=>typ)
  end
  function homecheck()
    #this function checks that moving the parameters related to the home country does not yield any transitivity issue
    gamma=collect(linspace(0,0.099999999,100))
    #eh cannot be equal to zero!
    eh=collect(linspace(0.00001,1.499999999,100))
    ph=collect(linspace(0.0,2.9999999999,100))
    result=true
    for i in 1:length(gamma)
      for j in 1:length(eh)
        for k in 1:length(ph)
          d=makedata(0.1,gamma[i],1.5,eh[j],3.0,ph[k],0.02,1.25,0.0,5.0,0.9)
          transitivity=checktransi(d)
          if transitivity["result"]==false
            result=false
          end
        end
      end
    end
    if result
      print("No transitivity issues")
    else
      print("Problem with transitivity")
    end
    return result
  end
  function abroadcheck()
    #this function checks that moving the parameters related to the recieving countries does not yield any transitivity issue
    lambda=collect(linspace(0.1,1,100))
    #eh cannot be equal to zero!
    ef=collect(linspace(1.0000001,3.0,100))
    pf=collect(linspace(1.0000001,6.0,100))
    result=true
    for i in 1:length(lambda)
      for j in 1:length(ef)
        for k in 1:length(pf)
          d=makedata(lambda[i],0.09,ef[j],1.0,pf[k],1.0,0.02,1.25,0.0,5.0,0.9)
          transitivity=checktransi(d)
          if transitivity["result"]==false
            result=false
          end
        end
      end
    end
    if result
      print("No transitivity issues")
    else
      print("Problem with transitivity")
    end
    return result
  end
  function probacheck()
    #this function checks that moving the probability does not yield any transitivity issue
    lambda=collect(linspace(0.000001,1,100))
    #eh cannot be equal to zero!
    p=collect(linspace(0,1.0,100))
    result=true
    for i in 1:length(p)
      for j in 1:length(lambda)
        gamma=collect(linspace(0,lambda[j]-0.000001,100))
        for k in 1:length(gamma)
          d=makedata(lambda[j],gamma[k],1.5,1.0,3.0,1.0,0.02,1.25,0.0,5.0,0.9,p[i])
          transitivity=checktransi(d)
          if transitivity["result"]==false
            result=false
          end
        end
      end
    end
    if result
      println("No transitivity issues")
    else
      println("Problem with transitivity")
    end
    return result
  end
  function graphevid()
    #This function aims to provide a graphical evidence of the transitivity check.
    ##Impact of p
    lambda=collect(linspace(0.1000001,1,1000))
    a1=zeros(1000)
    a2=zeros(1000)
    a3=zeros(1000)
    for i in 1:length(lambda)
      d=makedata(lambda[i],0.1,1.3,1.0,7.0,5.0,0.02,1.25,0.0,5.0,1.0)
      a1[i]=d["a1"]
      a2[i]=d["a2"]
      a3[i]=d["a3"]
    end
    figure("Graphical evidence along some paramters")
    subplot(221)
    plot(lambda,a1, color="green",label="a1")
    plot(lambda,a2, color="blue",label="a2")
    plot(lambda,a3, color="red",label="a3")
    title("Along lambda")
    xlabel("lambda")
    ylabel("a")
    #impact of gamma
    gamma=collect(linspace(0.00000001,0.3999999999,1000))
    a1g=zeros(1000)
    a2g=zeros(1000)
    a3g=zeros(1000)
    for i in 1:length(gamma)
      d=makedata(0.4,gamma[i],1.3,1.0,7.0,5.0,0.02,1.25,0.0,5.0,1.0)
      a1g[i]=d["a1"]
      a2g[i]=d["a2"]
      a3g[i]=d["a3"]
    end
    subplot(222)
    plot(gamma,a1g, color="green")
    plot(gamma,a2g, color="blue")
    plot(gamma,a3g, color="red")
    title("Along gamma")
    xlabel("gamma")
    ylabel("a")
    #Impact of Ph
    Ph=collect(linspace(1.0,6.9999999999999,1000))
    a1p=zeros(1000)
    a2p=zeros(1000)
    a3p=zeros(1000)
    for i in 1:length(Ph)
      d=makedata(0.4,0.1,1.3,1.0,7.0,Ph[i],0.02,1.25,0.0,5.0,1.0)
      a1p[i]=d["a1"]
      a2p[i]=d["a2"]
      a3p[i]=d["a3"]
    end
    subplot(223)
    plot(Ph,a1p, color="green")
    plot(Ph,a2p, color="blue")
    plot(Ph,a3p, color="red")
    title("Along Ph")
    xlabel("Ph")
    ylabel("a")
    #Impact of ef
    ef=collect(linspace(1.0000001,3.0,1000))
    a1e=zeros(1000)
    a2e=zeros(1000)
    a3e=zeros(1000)
    for i in 1:length(ef)
      d=makedata(0.4,0.1,ef[i],1.0,7.0,5.0,0.02,1.25,0.0,5.0,1.0)
      a1e[i]=d["a1"]
      a2e[i]=d["a2"]
      a3e[i]=d["a3"]
    end
    subplot(224)
    plot(ef,a1e, color="green",label="a1")
    plot(ef,a2e, color="blue",label="a2")
    plot(ef,a3e, color="red",label="a3")
    title("Along ef")
    xlabel("ef")
    ylabel("a")
    legend(loc="best")
    subplots_adjust(hspace=0.5)
  end

  function runall()
    hck=homecheck()
    ack=abroadcheck()
    pck=abroadcheck()
    if (hck & ack & pck)
      println("All transitivity check passed successfully")
    end
    graphevid()
  end

end
