C     毕设子程序
C     
C     M_VF   马氏体体积分数
C     A_VF   奥氏体体积分数
C
C     M_YS   马氏体屈服强度
C     A_YS   奥氏体屈服强度
C     MIX_YS 混合体屈服强度
C************************************************
C************************************************
C     单元测试从这开始
C     变量部分定义
      REAL MIX_YS,M_VF,M_YS,A_VF,A_YS
      REAL h,EQ_STRESS
      REAL Tp_strain,K,F_M,Sij
      REAL P_eq,T_r,n,M_s,T,k_vf,KTIME
C     K_TStrain相变转变子程序运行参数 TRUE 计算相变塑性应变
C     DEBUG_SIGN为调式代码运行参数  TRUE 输出调试输出部分
C     CALL_SIGN为子程序调用提示参数 TRUE 输出调用情况
C     为TRUE时调用子程序计算温度导致相变产生的应变
      LOGICAL K_TStrain,DEBUG_SIGN,CALL_SIGN
      K_TStrain=TRUE
      IF(K_TStrain==TRUE) CALL CAL_USER_SUBS
C 用于计算混合屈服强度
C      CALL CAL_MIX_YS(MIX_YS,M_VF,M_YS,A_VF,A_YS)
C 用于计算h(等效应力/混合屈服应力)
C      CALL CAL_h(h,EQ_STRESS,MIX_YS)
C 用于计算相变塑性系数
C      CALL CAL_K(A_YS,MA_th_strain_Diff)
C 用于计算相变塑性相变
C      CALL CAL_Tp_strain(Tp_strain,K,F_M,Sij,h)
C     
C      CALL CAL_VFS(M_VF,A_VF,P_eq,T_r,n,M_s,KTIME,k_vf,T)

C      PRINT *,MIX_YS,M_VF,M_YS,A_VF,A_YS
      END
C     单元测试结束
C************************************************
C************************************************
      Subroutine CAL_USER_SUBS()
            PRINT *, '[开始调用用户自定义子程序]'
            CALL CAL_VFS(M_VF,A_VF,P_eq,T_r,n,M_s,KTIME,k_vf,T)
            CALL CAL_MIX_YS(MIX_YS,M_VF,M_YS,A_VF,A_YS)
            CALL CAL_K(A_YS,MA_th_strain_Diff)
            CALL CAL_h(h,EQ_STRESS,MIX_YS)
            CALL CAL_Tp_strain(Tp_strain,K,F_M,Sij,h)
            PRINT *, '[用户自定义子程序调用结束]'
            RETURN
      END
C************************************************
C************************************************
C     计算混合屈服强度MIX_YS的子程序
      Subroutine CAL_MIX_YS(MIX_YS,M_VF,M_YS,A_VF,A_YS)
            REAL MIX_YS,M_VF,M_YS,A_VF,A_YS
            PRINT *, '[调用CAL_MIX_YS计算混合材料的屈服强度]'
C 测试用临时赋值     
            M_YS=500.0
            A_YS=300.0
            M_VF=0.2
            A_VF=1.0-M_VF

C           ******调试用代码*****
C            PRINT *, M_VF,A_VF
C           **********************

C M_TMP_YS 计算混合屈服强度的临时变量M
C A_TMP_YS 计算混合屈服强度的临时变量A
            A_TMP_YS=A_VF*A_YS
            M_TMP_YS=M_VF*M_YS
C           ******调试用代码*****
C            PRINT *, MIX_YS
C           **********************
            MIX_YS = A_TMP_YS+M_TMP_YS
            PRINT *, '---[调试输出]52行 MIX_YS=',MIX_YS      
            
            RETURN
      END
C************************************************
C************************************************
C     计算h(等效应力/混合屈服应力)的子程序
C     EQ_STRESS   等效应力
C     MIX_YS      混合屈服应力
      Subroutine CAL_h(h,EQ_STRESS,MIX_YS)
C           s_r 为临时变量储存比值
            REAL h,EQ_STRESS,MIX_YS,s_r
            PRINT *, '[调用CAL_h计算非线性系数]'
            EQ_STRESS=600
            MIX_YS=800
C ***********
C            PRINT *,EQ_STRESS/MIX_YS
C            PRINT *,1.0/2.0
C ***********
C     求并判断比值大小
            s_r=EQ_STRESS/MIX_YS
            IF(s_r <= 0.5000) h=1
            IF(s_r > 0.5000) h=1+(7.0/2.0)*(EQ_STRESS/MIX_YS-1.0/2.0)
            PRINT *, '--[调试输出]73行 h=',h
            RETURN
      END
C************************************************
C************************************************
C     计算相变塑性系数K的子程序
C     A_YS              奥氏体屈服强度
C     MA_th_strain_Diff 马氏体相变引起的奥氏体与马氏体的热应变之差
      Subroutine CAL_K(A_YS,MA_th_strain_Diff)
            REAL K,A_YS,MA_th_strain_Diff
            PRINT *, '[调用CAL_K计算相变塑性系数]'
            K=2*MA_th_strain_Diff/A_YS
            RETURN
      END
C************************************************
C************************************************
C     计算相变塑性应变Tp_strain的子程序
C     K           相变塑性系数
C     F_M         马氏体相变速率
C     Sij         偏应变张量
C     Tp_strain   相变塑性应变
      Subroutine CAL_Tp_strain(Tp_strain,K,F_M,Sij,h)
            REAL K,F_M,Sij,h
            PRINT *, '[调用CAL_Tp_strain计算相变塑性应变]'
            Tp_strain=-(3.0/2.0)*K*log(F_M)*Sij*h*F_M
            RETURN
      END
C************************************************
C************************************************
C     计算体积分数 A_VF,M_VF 的子程序 
C     M_VF 马氏体体积分数
C     A_VF 奥氏体体积分数 
C     P_eq 平衡状态奥氏体体积转变分数
C     T_r  为与形核率有关的量
C     n     Avrami 指数
C     M_s   马氏体相变起始温度，计算时取400度 (C)
C     T     当前温度
C     k_vf     常数
C     KTIME 时间（防混淆）
      Subroutine CAL_VFS(M_VF,A_VF,P_eq,T_r,n,M_s,KTIME,k_vf,T)
            REAL M_VF,A_VF,P_eq,T_r,n,M_s,T,k_vf,KTIME
            PRINT *, '[调用CALL_VFS计算体积分数]'
C            PRINT *, EXP(1.0)**2
            P_eq=20.0
            KTIME=100.0
            T_r=300.0
            n=0.5
            k_vf=0.5
            M_s=500.0
            T=499
            A_VF=P_eq*(1-EXP(-(KTIME/T_r)**n))
            M_VF=1-EXP(k_vf*(M_s-T))
            RETURN
            PRINT *, '[调试输出]126行 T=',T
      END

C************************************************
C************************************************
C     ABAQUS UMAT子程序
      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,RPL,DDSDDT, 
     1 DRPLDE,DRPLDT,STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED, 
     2 CMNAME,NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT, 
     3 PNEWDT,CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,KSTEP,KINC) 
C     逻辑测试时将下面一行注释掉
C      INCLUDE 'ABA_PARAM.INC' 
      CHARACTER*8 CMNAME 
      DIMENSION STRESS(NTENS),STATEV(NSTATV),DDSDDE(NTENS,NTENS), 
     1 DDSDDT(NTENS),DRPLDE(NTENS),STRAN(NTENS),DSTRAN(NTENS), 
     2 TIME(2),PREDEF(1),DPRED(1),PROPS(NPROPS),COORDS(3),DROT(3,3), 
     3 DFGRD0(3,3),DFGRD1(3,3) 
C UMAT FOR ISOTROPIC ELASTICITY 
C CANNOT BE USED FOR PLANE STRESS 
C --------- 
C PROPS(1) - E 
C PROPS(2) - NU 
C ---------- 
C 
C 弹性属性 lambda G 
      EMOD=PROPS(1) 
      ENU=PROPS(2) 
      EBULK3=EMOD/(1-2*ENU) 
      EG2=EMOD/(1+ENU) 
      EG=EG2/2 
      EG3=3*EG 
      ELAM=(EBULK3-EG2)/3 
      
C 
C ELASTIC STIFFNESS 
C 

      DO K1=1, NDI 
            DO K2=1, NDI 
            DDSDDE(K2, K1)=ELAM 
            END DO 
            DDSDDE(K1, K1)=EG2+ELAM 
      END DO 
      DO K1=NDI+1, NTENS 
            DDSDDE(K1 ,K1)=EG 
      END DO 
C 
C 计算应力
C 
      DO K1=1, NTENS 
            DO K2=1, NTENS 
            STRESS(K2)=STRESS(K2)+DDSDDE(K2, K1)*DSTRAN(K1)
            END DO 
      END DO 
C 
      RETURN 
      END
C************************************************
C************************************************
C     ABAQUS DFLUX子程序
      SUBROUTINE DFLUX(FLUX,SOL,JSTEP,KINC,NOEL,NPT,COORDS,JLTYP,
     1                 TEMP,PRESS,SNAME)
C     逻辑测试时将下面一行注释掉
      INCLUDE 'ABA_PARAM.INC'

      parameter(one=1.d0)
      DIMENSION COORDS(3),FLUX(2),TIME(2)
      CHARACTER*80 SNAME

      q=8000
      v=0
      d=v*TIME(2)

      x=COORDS(1)
      y=COORDS(2)
      z=COORDS(3)

      x0=0
      y0=0
      z0=0

      a=0.002
      b=0.002
      c=0.002
      PI=3.1415
      PRINT *, '正在运行子程序'
      PRINT *, '---[调试输出]236行 x=',x
      PRINT *, '---[调试输出]237行 y=',y
      PRINT *, '---[调试输出]238行 z=',z
      heat=6*sqrt(3.0)*q/(a*b*c*PI*sqrt(PI))
      shape=exp(-3*(x-x0)**2/c**2-3*(y-y0-d)**2/a**2-3*(z-z0)**2/b**2)
C JLTYP=1 表示为体热源
      JLTYP=1
      PRINT *, '---[调试输出]243行 shape=',shape
      if(JSTEP.eq.one) then
      FLUX(1)=heat*shape
      endif
      RETURN
      END
