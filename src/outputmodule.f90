MODULE SWBM_output

  USE define_fields
  USE irrigation
  
  IMPLICIT NONE
  
  TYPE budget_terms
    REAL :: pET, aET, gw_irr, irr_sw, irr_gw, total_irr, recharge, storage, deficiency
  END TYPE 
  
  REAL, ALLOCATABLE, DIMENSION(:) :: landcover_total_irr, landcover_sw_irr, landcover_gw_irr, landcover_area
  REAL, ALLOCATABLE, DIMENSION(:) :: landcover_effprecip, landcover_pET, landcover_deficiency
  REAL, ALLOCATABLE, DIMENSION(:) :: landcover_recharge, landcover_aET, landcover_delta_s
  TYPE(budget_terms), ALLOCATABLE, DIMENSION(:) :: stream_WB
   
  CONTAINS
  
  SUBROUTINE output_files(model_name, daily_out_flag)
  
    LOGICAL, INTENT(IN) :: daily_out_flag
    CHARACTER(20), INTENT(IN) :: model_name
    INTEGER, DIMENSION(npoly) :: field_ids
    REAL :: ann_spec_ag_vol, ann_spec_muni_vol
    INTEGER :: i
    CHARACTER(14), DIMENSION(npoly)  :: header_text
    CHARACTER(14) :: temp_text
    
    
    ALLOCATE(stream_WB(nSubws))
    field_ids= (/ (i, i = 1, npoly) /)
    do i=1, npoly
      write(temp_text,'(i4)') field_ids(i)
      header_text(i) = 'SWBM_id_'//adjustl(temp_text)
    end do     
    open(unit=900, file='Recharge_Total.dat', status = 'replace')   
    write(900,*)'Total_Recharge_m^3/day  Total_Recharge_m^3'            
    ! open(unit=84, file=trim(model_name)//'.rch', Access = 'append', status='old')                                                  
    open(unit=90, file='monthly_effective_precip_linear.dat', status = 'replace')              
    write(90,*)'Monthly precip applied to each field normalized to the field area (m)'
    write(90,'(a14,a1,9999a14)')' Stress_Period',' ', header_text
    open(unit=91, file='monthly_GW_pumping_linear.dat', status = 'replace')              
    write(91,*)'Monthly groundwater applied to each field normalized to the field area (m)'
    write(91,'(a14,a1,9999a14)')' Stress_Period',' ', header_text
    open(unit=92, file='monthly_total_tot_irr_linear.dat', status = 'replace')
    write(92,*)'Monthly total tot_irr applied to each field normalized to the field area (m)'
    write(92,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=93, file='monthly_pET_linear.dat', status = 'replace')
    write(93,*)'Monthly potential ET for each field normalized to the field area (m)'
    write(93,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=94, file='monthly_GW_recharge_linear.dat', status = 'replace')
    write(94,*)'Monthly groundwater recharge from each field normalized to the field area (m)'
    write(94,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=95, file='monthly_storage_linear.dat', status = 'replace')
    write(95,*)'Storage at the end of the month for each field normalized to the field area (m)'
    write(95,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=96, file='monthly_aET_linear.dat', status = 'replace')
    write(96,*)'Monthly actual ET for each field normalized to the field area (m)'
    write(96,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=97, file='monthly_deficiency_linear.dat', status = 'replace')
    write(97,*)'Monthly groundwater recharge from each field normalized to the field area (m)'
    write(97,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    
    open(unit=200, file='monthly_GW_pumping_volume.dat', status = 'replace')              
    write(200,*)'Monthly groundwater volume applied to each field (m^3)'
    write(200,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=201, file='monthly_total_tot_irr_volume.dat', status = 'replace')
    write(201,*)'Monthly tot_irr volume applied to each field (m^3)'
    write(201,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=202, file='monthly_pET_volume.dat', status = 'replace')
    write(202,*)'Monthly potential ET for each field (m^3)'
    write(202,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=203, file='monthly_GW_recharge_volume.dat', status = 'replace')
    write(203,*)'Monthly groundwater recharge from each field (m^3)'
    write(203,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=204, file='monthly_storage_volume.dat', status = 'replace')
    write(204,*)'Storage at the end of the month for each field (m^3)'
    write(204,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=205, file='monthly_aET_volume.dat', status = 'replace')
    write(205,*)'Monthly actual ET for each field (m^3)'
    write(205,'(a14,a1,9999a14)')' Stress_Period',' ', header_text    
    open(unit=206, file='monthly_deficiency_volume.dat', status = 'replace')
    write(206,*)'Monthly groundwater recharge from each field (m^3)'
    write(206,'(a14,a1,9999a14)')' Stress_Period',' ', header_text 
    open(unit=207, file='monthly_effective_precip_volume.dat', status = 'replace')
    write(207,*)'Monthly effective precip volume applied to each field (m^3)'
    write(207,'(a14,a1,9999a14)')' Stress_Period',' ', header_text       
                               
    
    if (daily_out_flag) then
      open(unit=530, file='daily_gw_irr.dat', status = 'replace')
      write(530, *)"Daily gw_irr volume (m^3) for each well"
      ! write(530,'(9999i6)')ag_wells(:)%well_id
      write(530,*) ag_wells(:)%well_name
    endif
    open(unit=531, file='Monthly_Ag_GW_Pumping_Volume_By_Well.dat', status = 'replace')
    write(531,*)'Monthly Ag Groundwater Pumping Volume (m^3) by Well'
    ! write(531,'(9999i6)')ag_wells(:)%well_id
    write(531,*) ag_wells(:)%well_name
    open(unit=532, file='Monthly_Ag_GW_Pumping_Rate_By_Well.dat')
    write(532,*)'Monthly Agricultural Groundwater Pumping Rate (m^3/day) by Well'
    ! write(532,'(9999i6)')ag_wells(:)%well_id
    write(532,*) ag_wells(:)%well_name
    
    open(unit=533, file='Monthly_Muni_GW_Pumping_Volume_By_Well.dat', status = 'replace')
    write(533,*)'Monthly Municipal Groundwater Pumping Volume (m^3) by Well'
    ! write(533,'(9999i6)')ag_wells(:)%well_id
    write(533,*) muni_wells(:)%well_name
    open(unit=534, file='Monthly_Muni_GW_Pumping_Rate_By_Well.dat')
    write(534,*)'Monthly Municipal Groundwater Pumping Rate (m^3/day) by Well'
    ! write(534,'(9999i6)')ag_wells(:)%well_id
    write(534,*) muni_wells(:)%well_name    
    
    open(unit=535, file='Annual_Groundwater_Pumping_Totals.dat')
    write(535,*)'WaterYear  Est_Ag_Vol_m3  Specified_Ag_Vol_m3  Specified_Muni_Vol_m3  Total_Vol_m3'
    
    open(unit=130, file='ET_Active_Days.dat')                       
    write(130,'("Number of Days ET is Active in each polyon")')    
  
    ! open(unit=101, file='monthly_SW_irr_by_stream.dat')        
    ! open(unit=102, file='monthly_GW_irr_by_stream.dat')      
    ! open(unit=103, file='monthly_total_irr_by_stream.dat')     
    ! open(unit=104, file='monthly_pET_by_stream.dat')     
    ! open(unit=105, file='monthly_aET_by_stream.dat')  
    ! open(unit=106, file='monthly_recharge_by_stream.dat')  
    ! open(unit=107, file='monthly_deficiency_by_stream.dat')
    ! open(unit=108, file='monthly_storage_by_stream.dat')  
    ! 
    ! do i=101,108
    !   write(i,'(999A30)')'Stress_Period  ',seg_name(:)
    ! enddo
    open(unit=116, file='monthly_vol_eff_precip_by_landcover.dat')     
    open(unit=117, file='monthly_vol_SW_irr_by_landcover.dat')           
    open(unit=118, file='monthly_vol_GW_irr_by_landcover.dat')           
    open(unit=119, file='monthly_vol_total_irr_by_landcover.dat')        
    open(unit=120, file='monthly_vol_pET_by_landcover.dat')              
    open(unit=121, file='monthly_vol_aET_by_landcover.dat')              
    open(unit=122, file='monthly_vol_recharge_by_landcover.dat')         
    open(unit=123, file='monthly_vol_deficiency_by_landcover.dat')       
    open(unit=124, file='monthly_vol_change_in_storage_by_landcover.dat')
       
    do i=116,124
      write(i,'(999A30)')'Stress_Period  ',crops(:)%landcover_name
    enddo
    
    open(unit=125, file='monthly_water_budget.dat')
    write(125,*)'Stress_Period Precip SW_Irr GW_Irr ET Recharge Runoff Storage Error'
   
    open(unit=540,file='5daysdeficiency.dat', status = 'replace')
    
    ! open(unit=60, file='subwatershed_area_m2.dat', status = 'replace')
    ! write(60,'(" Month Scott French Etna Patterson Kidder Moffet Mill Shackleford Tailings")')
    open(unit=61, file='landcover_area_m2.dat', status = 'replace')
    write(61,'(999A30)')'Stress_Period  ',crops(:)%landcover_name
   
  END SUBROUTINE output_files
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SUBROUTINE monthly_SUM
  
   ! Minor issue with change in storage and swc. Change in storage is really the running total, need to fix it by differencing from month to month and also year to year.
   
   monthly%tot_irr = monthly%tot_irr + daily%tot_irr                         ! Add daily linear tot_irr to monthly total
   monthly%gw_irr = monthly%gw_irr + daily%gw_irr                                  ! Add daily linear gw_irr to monthly total
   monthly%recharge = monthly%recharge + daily%recharge                               ! Add daily linear recharge to monthly total
   monthly%swc = monthly%swc + daily%change_in_storage                                ! Add daily linear swc to yearly total
   monthly%pET = monthly%pET + daily%pET                                              ! Add daily linear potential ET to monthly total
   monthly%aET = monthly%aET + daily%aET                                              ! Add daily linear aET to monthly total
   monthly%deficiency = monthly%deficiency + daily%deficiency                         ! Add daily linear deficiency to monthly total
   monthly%ET_active = monthly%ET_active + daily%ET_active                            ! Add daily linear ET to monthly total    
   monthly%effprecip = monthly%effprecip + daily%effprecip                            ! Add daily linear effective precip to monthly total    
   monthly%change_in_storage = monthly%change_in_storage + daily%change_in_storage    ! Add daily linear change in storage to monthly total    
   monthly%MAR_vol = monthly%MAR_vol + daily%MAR_vol                                  ! Add daily linear MAR volume to monthly total
   monthly%runoff = monthly%runoff + daily%runoff                                    
  
  END SUBROUTINE monthly_SUM
  
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SUBROUTINE annual_SUM
  
   yearly%tot_irr = yearly%tot_irr + daily%tot_irr                       ! Add daily linear tot_irr to yearly total
   yearly%gw_irr = yearly%gw_irr + daily%gw_irr                                ! Add daily linear gw_irr to yearly total   
   yearly%recharge = yearly%recharge + daily%recharge                             ! Add daily linear recharge to yearly total  
   yearly%swc = yearly%swc + daily%change_in_storage                              ! Add daily linear swc to yearly total  
   yearly%pET = yearly%pET + daily%pET                                            ! Add daily linear ET to yearly total        
   yearly%aET = yearly%aET + daily%aET                                            ! Add daily linear aET to yearly total  
   yearly%deficiency = yearly%deficiency + daily%deficiency                       ! Add daily linear deficiency to yearly total
   yearly%ET_active = yearly%ET_active + daily%ET_active                          ! Add daily linear ET to yearly total    
   yearly%effprecip = yearly%effprecip + daily%effprecip                          ! Add daily linear effective precip to yearly total    
   yearly%change_in_storage = yearly%change_in_storage + daily%change_in_storage  ! Add daily linear change in storage to yearly total    
   yearly%MAR_vol = yearly%MAR_vol + daily%MAR_vol                                ! Add daily linear MAR to annual total
  
  END SUBROUTINE annual_SUM
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SUBROUTINE print_monthly_output(im, nlandcover, nSubws)
    
    INTEGER, INTENT(IN) :: im, nlandcover, nSubws
    INTEGER :: i, landcover_id
       
    if (im==1) then
    	ALLOCATE(landcover_total_irr(nlandcover)) 
    	ALLOCATE(landcover_sw_irr(nlandcover))    
    	ALLOCATE(landcover_gw_irr(nlandcover))    
    	ALLOCATE(landcover_area(nlandcover))
    	ALLOCATE(landcover_effprecip(nlandcover))
    	ALLOCATE(landcover_pET(nlandcover))
    	ALLOCATE(landcover_aET(nlandcover))
    	ALLOCATE(landcover_deficiency(nlandcover))
    	ALLOCATE(landcover_recharge(nlandcover))
    	ALLOCATE(landcover_delta_s(nlandcover))
    endif

    
    ! subwnsw           = 0.
    ! subwat_gw_irr         = 0.                            
    ! subwat_tot_irr        = 0.                         
    ! subwnevapo        = 0.                          
    ! subwat_aET     = 0.                       
    ! subwnrecharge     = 0.                    
    ! subwndeficiency   = 0.                 
    ! subwnmoisture     = 0.                  
    
    landcover_effprecip  = 0.
    landcover_pET        = 0.
    landcover_aET        = 0.
    landcover_total_irr  = 0.
    landcover_gw_irr     = 0.
    landcover_sw_irr     = 0.
    landcover_recharge   = 0.
    landcover_deficiency = 0.
    landcover_delta_s    = 0.  
    landcover_area       = 0.
    
    do i = 1, npoly
      landcover_id = fields(i)%landcover_id
      
      landcover_effprecip(landcover_id) = landcover_effprecip(landcover_id) + monthly(i)%effprecip_vol
      landcover_pET(landcover_id) = landcover_pET(landcover_id) + monthly(i)%pET_vol
      landcover_aET(landcover_id) = landcover_aET(landcover_id) + monthly(i)%aET_vol
      landcover_total_irr(landcover_id) = landcover_total_irr(landcover_id) + monthly(i)%tot_irr_vol
      landcover_gw_irr(landcover_id) = landcover_gw_irr(landcover_id) + monthly(i)%gw_irr_vol
      ! landcover_sw_irr handled outside of loop
      landcover_recharge(landcover_id) = landcover_recharge(landcover_id) + monthly(i)%recharge_vol
      landcover_deficiency(landcover_id) = landcover_deficiency(landcover_id) + monthly(i)%deficiency_vol
      landcover_delta_s(landcover_id) = landcover_delta_s(landcover_id) + monthly(i)%change_in_storage_vol
      landcover_area(landcover_id) = landcover_area(landcover_id) + fields(i)%area 
    
    ! subwnsw(fields(i)%subwn)         = subwnsw(fields(i)%subwn) &
    !                                   + (monthly(i)%tot_irr_vol - monthly(i)%gw_irr_vol)
    ! subwat_gw_irr(fields(i)%subwn)       = subwat_gw_irr(fields(i)%subwn)       + monthly(i)%gw_irr_vol  
    ! subwat_tot_irr(fields(i)%subwn)      = subwat_tot_irr(fields(i)%subwn)      + monthly(i)%tot_irr_vol
    ! subwnevapo(fields(i)%subwn)      = subwnevapo(fields(i)%subwn)      + monthly(i)%pET_vol
    ! subwat_aET(fields(i)%subwn)   = subwat_aET(fields(i)%subwn)   + monthly(i)%aET_vol
    ! subwnrecharge(fields(i)%subwn)   = subwnrecharge(fields(i)%subwn)   + monthly(i)%recharge_vol
    ! subwndeficiency(fields(i)%subwn) = subwndeficiency(fields(i)%subwn) + monthly(i)%deficiency_vol   
    ! subwnmoisture(fields(i)%subwn)   = subwnmoisture(fields(i)%subwn)   + monthly(i)%swc_vol
    ! 
    ! select case (fields(i)%SWBM_LU)
    !   case (11)   !alfalfa / grain
    !     if (fields(i)%irr_type == 555 .or. fields(i)%water_source == 4 .or. fields(i)%water_source == 5) then  ! If n* or SUB or DRY
    !       ilanduse = 4  ! ET_noIRRIG
    !     else
    !       if (fields(i)%rotation==11) ilanduse = 1  ! Alfalfa
    !       if (fields(i)%rotation==12) ilanduse = 2  ! Grain 
    !     endif
    !   case (2)
    !     if (fields(i)%irr_type == 555 .or. fields(i)%water_source == 4 .or. fields(i)%water_source == 5) then  ! If n* or SUB or DRY
    !       ilanduse = 4  ! ET_noIRRIG
    !     else
    !       ilanduse = 3 ! pasture
    !     endif
    !   case(3)
    !      ilanduse = 4  ! ET_noIRRIG
    !      if (daily(i)%tot_irr .GT. 0) write(800,*)'Polygon',i
    !      if (monthly(i)%tot_irr_vol .GT. 0) write(800,*)'Polygon',i
    !   case (4)
    !      ilanduse = 5  ! noET_noIRRIG     
    !   end select 
    ! 
    !  landcover_sw_irr(ilanduse)         = landcover_sw_irr(ilanduse)  &
    !                                + (monthly(i)%tot_irr_vol - monthly(i)%gw_irr_vol)
    !  landcover_gw_irr(ilanduse)       = landcover_gw_irr(ilanduse)       + monthly(i)%gw_irr_vol 
    !  landcover_total_irr(ilanduse)      = landcover_total_irr(ilanduse)      + monthly(i)%tot_irr_vol
    !  landcover_pET(ilanduse)      = landcover_pET(ilanduse)      + monthly(i)%pET_vol
    !  landcover_recharge(ilanduse)   = landcover_recharge(ilanduse)   + monthly(i)%recharge_vol
    !  landcover_deficiency(ilanduse) = landcover_deficiency(ilanduse) + monthly(i)%deficiency_vol
    !  landcover_aET(ilanduse)   = landcover_aET(ilanduse)   + monthly(i)%aET_vol   
    !  landcover_swc(ilanduse)   = landcover_swc(ilanduse)   + monthly(i)%swc_vol
    enddo    
    landcover_sw_irr = landcover_total_irr - landcover_gw_irr    
                                    
    ! write(101,'(i4,9F20.2)') month, subwnsw(:)                         
    ! write(102,'(i4,9F20.2)') month, subwat_gw_irr(:)                     
    ! write(103,'(i4,9F20.2)') month, subwat_tot_irr(:)                    
    ! write(104,'(i4,9F20.2)') month, subwnevapo(:)                    
    ! write(105,'(i4,9F20.2)') month, subwat_aET(:)                 
    ! write(106,'(i4,9F20.2)') month, subwnrecharge(:)                 
    ! write(107,'(i4,9F20.2)') month, subwndeficiency(:)               
    ! write(108,'(i4,9F20.2)') month, subwnmoisture(:)                 
    
    write(116,'(i4,999F20.2)') im, landcover_effprecip(:)    
    write(117,'(i4,999F20.2)') im, landcover_sw_irr(:)    
    write(118,'(i4,999F20.2)') im, landcover_gw_irr(:)    
    write(119,'(i4,999F20.2)') im, landcover_total_irr(:)     
    write(120,'(i4,999F20.2)') im, landcover_pET(:)           
    write(121,'(i4,999F20.2)') im, landcover_aET(:)           
    write(122,'(i4,999F20.2)') im, landcover_recharge(:)      
    write(123,'(i4,999F20.2)') im, landcover_deficiency(:)    
    write(124,'(i4,999F20.2)') im, landcover_delta_s(:)
    write(61,'(i4,999F20.2)') im, landcover_area(:)

    write(125,'(i4,8F20.0)') im, sum(monthly%effprecip_vol), (sum(monthly%tot_irr_vol)-sum(monthly%gw_irr_vol)), &
    sum(monthly%gw_irr_vol), -sum(monthly%aET_vol), -sum(monthly%recharge_vol), &
    -sum(monthly%runoff_vol), -sum(monthly%change_in_storage_vol) ,&
    sum(monthly%effprecip_vol + monthly%tot_irr_vol - monthly%aET_vol - monthly%recharge_vol - &
    monthly%runoff_vol - monthly%change_in_storage_vol)
    
    
     
  END SUBROUTINE print_monthly_output
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
     
  SUBROUTINE groundwater_pumping(jday, nAgWells, npoly, numdays, daily_out_flag, ag_wells_specified)
       
     INTEGER, INTENT(IN) :: jday, nAgWells, npoly, numdays
     LOGICAL, INTENT(IN) :: daily_out_flag, ag_wells_specified
     INTEGER :: i, well_idx
     
     ag_wells%daily_vol = 0.                  ! set daily value to zero
     if (jday==1) then                       ! If first day of month, reset monthly values to zero
       ag_wells%monthly_vol = 0.
       ag_wells%monthly_rate = 0.
     endif 
     
     do i=1, npoly
     	 if(fields(i)%water_source==1 .or. fields(i)%irr_type==555 .or. fields(i)%well_idx==0) then     ! If SW irrigated field or non-irrigated
     	 	 ! do nothing
     	 else 
     	   ag_wells(fields(i)%well_idx)%daily_vol =   daily(i)%gw_irr*fields(i)%area               ! assign daily gw_irr volume   
         ag_wells(fields(i)%well_idx)%monthly_vol = ag_wells(fields(i)%well_idx)%monthly_vol + &
         ag_wells(fields(i)%well_idx)%daily_vol    ! Add daily volume to monthly counter
       endif
     enddo      
     
     if(daily_out_flag) write(530,'(200es20.8)') ag_wells%daily_vol
     
     if (jday==numdays) then
       ag_wells%specified_rate = ag_wells%specified_volume / numdays
       muni_wells%specified_rate = muni_wells%specified_volume / numdays
       
       if (ag_wells_specified) then
         write(531,'(172es20.8)') ag_wells%specified_volume
         write(532,'(172es20.8)') ag_wells%specified_rate        
       else 
     	   write(531,'(172es20.8)') ag_wells%monthly_vol
         ag_wells%monthly_rate = ag_wells%monthly_vol / numdays
         write(532,'(172es20.8)') ag_wells%monthly_rate
       endif
       write(533,'(172es20.8)') muni_wells%specified_volume
       write(534,'(172es20.8)') muni_wells%specified_rate
      
     endif
       
  END SUBROUTINE groundwater_pumping 
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SUBROUTINE write_MODFLOW_WEL(im, month, nAgWells, n_wel_param, model_name)
    
  INTEGER, INTENT(IN) :: im, month, nAgWells, n_wel_param
  CHARACTER, INTENT(IN) :: model_name
  INTEGER :: i, well_idx
  
  open(unit=536, file=trim(model_name)//'.wel', Access = 'append', status='old')
  if (month == 1 .or. month == 2 .or. month == 3 .or. month == 4 .or. &                              ! If October-March
      month == 5 .or. month == 6) then
    write(536,'(I10,I10,A28,I4)')nAgWells, n_wel_param-2, '               Stress Period',im         ! Only MFR is active, subtract number of ditches represented 
  else if (month == 7 .or. month == 8) then                                                            ! If April-May
    write(536,'(I10,I10,A28,I4)')nAgWells, n_wel_param, '               Stress Period',im           ! MFR and Ditches are active, use all WEL parameters
  else if (month == 9 .or. month == 10) then                                                           ! If June - July
    write(536,'(I10,I10,A28,I4)')nAgWells, n_wel_param-7, '               Stress Period',im         ! Only Ditches are active, subtract number of MFR segments represented
  else if (month == 11 .or. month == 0) then                                                           ! If August-September
    write(536,'(I10,I10,A28,I4)')nAgWells, n_wel_param-9, '               Stress Period',im         ! Only Ditches are active, subtract number of MFR and Ditch segments represented                                              
  end if
    
  do i=1,nAgWells
  	! well_idx = fields(i)%well_idx
    write(536,'(3I10,ES15.3)')ag_wells(well_idx)%layer, ag_wells(well_idx)%well_row, &
     ag_wells(well_idx)%well_col, -1*ag_wells(well_idx)%monthly_rate
  enddo
    
  if (month == 1 .or. month == 2 .or. month == 3 .or. month == 4 .or. &                              ! If October-March MFR is active
      month == 5 .or. month == 6) then                                                           
    write(536,*)'  MFR5'
    write(536,*)'  MFR6'
    write(536,*)'  MFR7'
    write(536,*)'  MFR8'
    write(536,*)'  MFR9'
    write(536,*)'  MFR10'
    write(536,*)'  MFR11'
  else if (month == 7 .or. month == 8) then                                                            ! If April-May MFR and Ditches are active
    write(536,*)'  MFR5'                                            
    write(536,*)'  MFR6'
    write(536,*)'  MFR7'
    write(536,*)'  MFR8'
    write(536,*)'  MFR9'
    write(536,*)'  MFR10'
    write(536,*)'  MFR11'
    write(536,*)'  FRMRSDitch'
    write(536,*)'  SVIDDitch'
  else if (month == 9 .or. month == 10) then                                                           ! If June-July ditches are active
    write(536,*)'  FRMRSDitch'
    write(536,*)'  SVIDDitch'
  end if
    
  END SUBROUTINE  write_MODFLOW_WEL
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
  SUBROUTINE write_MODFLOW_MNW2(im, nAgWells, nMuniWells, ag_wells_specified)
   
    INTEGER, INTENT(IN) :: im, nAgWells, nMuniWells
    LOGICAL, INTENT(IN) :: ag_wells_specified
    INTEGER :: i, counter
    
    counter = 0
    if (ag_wells_specified) then
    	do i=1, nAgWells
    	  if(ag_wells(i)%specified_rate > 0) then  
    		  counter = counter + 1
    	  endif
      enddo
    else
    	do i=1, nAgWells
    	  if(ag_wells(i)%monthly_rate > 0) then  
    		  counter = counter + 1
    	  endif
      enddo
    endif
        
    do i=1, nMuniWells
    	if(muni_wells(i)%specified_rate > 0) then
    		counter = counter + 1
    	endif
    enddo
    
    if (counter<9) then
      write(801,'(I1, A35, I5, A6)') counter, '      ! Data Set 3 - Stress Period ',im,'; ITMP'
    elseif (counter < 100) then
    	write(801,'(I2, A35, I5, A6)') counter, '      ! Data Set 3 - Stress Period ',im,'; ITMP'
    else
    	write(801,'(I3, A35, I5, A6)') counter, '      ! Data Set 3 - Stress Period ',im,'; ITMP'
    endif
        
    if (ag_wells_specified) then        ! If ag pumping rates are specified, use specified pumping rates for ag wells and municipal wells 
      do i=1, nAgWells
      	if(ag_wells(i)%specified_rate > 0) then
      		write(801,'(A20, ES12.2, A4)')ag_wells(i)%well_name, -ag_wells(i)%specified_rate, '-1'
      	endif
      enddo
      do i=1, nMuniWells
        if(muni_wells(i)%specified_rate > 0) then
      		write(801,'(A20, ES12.2, A4)')muni_wells(i)%well_name, -muni_wells(i)%specified_rate, '-1'
      	endif
      enddo 	
    else                                ! If ag pumping rates are not specified, use estimated pumping rates for ag wells and specified rates for municipal wells 
      do i=1, nAgWells
      	if(ag_wells(i)%monthly_rate > 0) then
      		write(801,'(A20, ES12.2, A4)')ag_wells(i)%well_name, -ag_wells(i)%monthly_rate, '-1'
      	endif
      enddo
      do i=1, nMuniWells
        if(muni_wells(i)%specified_rate > 0) then
      		write(801,'(A20, ES12.2, A4)')muni_wells(i)%well_name, -muni_wells(i)%specified_rate, '-1'
      	endif
      enddo 
    endif 
   
  END SUBROUTINE write_MODFLOW_MNW2
  
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
  
   SUBROUTINE daily_out(num_daily_out,ip_daily_out)
     
     INTEGER, INTENT(in) ::  num_daily_out
     INTEGER, DIMENSION(num_daily_out), INTENT(in) :: ip_daily_out
     INTEGER  :: unit_num, i
     
     do i=1,num_daily_out
       unit_num = 599+i
       write(unit_num,'(i5,12F10.6,3i4)') ip_daily_out(i), daily(ip_daily_out(i))%effprecip, &
         surfaceWater(fields(ip_daily_out(i))%subws_ID)%avail_sw_vol,&
         daily(ip_daily_out(i))%tot_irr - daily(ip_daily_out(i))%gw_irr,&
         daily(ip_daily_out(i))%gw_irr, daily(ip_daily_out(i))%tot_irr, daily(ip_daily_out(i))%recharge, &
         daily(ip_daily_out(i))%swc, daily(ip_daily_out(i))%pET,  daily(ip_daily_out(i))%aET, &
         daily(ip_daily_out(i))%deficiency, daily(ip_daily_out(i))%residual,fields(ip_daily_out(i))%whc*&
         crops(fields(ip_daily_out(i))%landcover_id)%RootDepth,fields(ip_daily_out(i))%subws_ID, &
         fields(ip_daily_out(i))%SWBM_LU, fields(ip_daily_out(i))%landcover_id
     enddo                                                                                              ! Field IDs for Daily Output
   END SUBROUTINE daily_out
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   SUBROUTINE monthly_out_by_field(im)                                  
                                                             
     INTEGER, INTENT(in) :: im                            
     
     write(90,'(i4,9999g20.3)') im, monthly%effprecip
     write(91,'(i4,9999g20.3)') im, monthly%gw_irr                
     write(92,'(i4,9999g20.3)') im, monthly%tot_irr      
     write(93,'(i4,9999g20.3)') im, monthly%pET                   
     write(94,'(i4,9999g20.3)') im, monthly%recharge        
     write(95,'(i4,9999g20.3)') im, daily%swc                    ! daily value used because that is the state of the field at the end of the month 
     write(96,'(i4,9999g20.3)') im, monthly%aET        
     write(97,'(i4,9999g20.3)') im, monthly%deficiency                           
     write(130,'(i4,9999i4)') im, monthly%ET_active        
                                                                          
     write(200,'(i4,9999g20.3)') im, monthly%gw_irr_vol          
     write(201,'(i4,9999g20.3)') im, monthly%tot_irr_vol 
     write(202,'(i4,9999g20.3)') im, monthly%pET_vol                  
     write(203,'(i4,9999g20.3)') im, monthly%recharge_vol   
     write(204,'(i4,9999g20.3)') im, daily%swc*fields%area       ! daily value used because that is the state of the field at the end of the month 
     write(205,'(i4,9999g20.3)') im, monthly%aET_vol                    
     write(206,'(i4,9999g20.3)') im, monthly%deficiency_vol
     write(207,'(i4,9999g20.3)') im, monthly%effprecip_vol
         
   END SUBROUTINE monthly_out_by_field
   
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
   
   SUBROUTINE print_annual(WY, ag_wells_specified)
   
   INTEGER, INTENT(IN) :: WY
   LOGICAL, INTENT(IN) :: ag_wells_specified
   CHARACTER(6) :: WYtext
     
   write(WYtext, '(A2,I4)') 'WY', WY
   if (ag_wells_specified) then                               ! Sum specified ag and muni pumping for total
     write(535,*)WYtext, sum(yearly(:)%gw_irr_vol), ann_spec_ag_vol, ann_spec_muni_vol, &
     ann_spec_ag_vol + ann_spec_muni_vol
   else                                                       ! Sum estimated ag and muni pumping for total
   	 write(535,*)WYtext, sum(yearly(:)%gw_irr_vol), ann_spec_ag_vol, ann_spec_muni_vol, &
   	 sum(yearly(:)%gw_irr_vol) + ann_spec_muni_vol
   endif
   
   END SUBROUTINE print_annual
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     SUBROUTINE write_MODFLOW_ETS(im,month,nday,nrows,ncols,rch_zones,Total_Ref_ET,Discharge_Zone_Cells, npoly)
     
     INTEGER, INTENT(IN) :: im,month,nrows,ncols, npoly
     INTEGER, INTENT(IN) :: rch_zones(nrows,ncols), nday(0:11), Discharge_Zone_Cells(nrows,ncols)
     REAL, INTENT(IN) :: Total_Ref_ET
     REAL :: Avg_Ref_ET
     REAL, DIMENSION(npoly) :: ET_fraction
     INTEGER :: ip
     REAL, DIMENSION(nrows,ncols) :: Extinction_depth_matrix, ET_matrix_out
     
     ET_matrix_out = 0.
     Avg_Ref_ET = Total_Ref_ET/real(nday(month))                                                   ! Calculate average Reference ET for populating ET package
     
     do ip=1,npoly
       ET_fraction(ip) = monthly(ip)%ET_active / real(nday(month)) 
       where (rch_zones(:,:) == ip)
         ET_matrix_out(:,:) = Avg_Ref_ET * (1 - ET_fraction(ip))  ! Scale Average monthly ET by the number of days ET was not active on the field.
         Extinction_depth_matrix(:,:) = 0.5
       end where
     enddo
     
     ET_matrix_out = ET_matrix_out * Discharge_Zone_Cells
     Extinction_depth_matrix = Extinction_depth_matrix 
     
     if (im==1) then
     	open(unit=83, file='SVIHM.ets', status = 'old', position = 'append')
     	write(83, *)"       20   1.00000(10e14.6)                   -1     ET RATE"
       write(83,'(10e14.6)') ET_matrix_out                ! Write Max ET Rates 
       write(83,*)'       20   1.00000(10e14.6)                   -1     ET DEPTH'
       write(83,'(10e14.6)') Extinction_depth_matrix  ! Write ET Extinction Depth
       write(83,*)'        05.0000e-01(20F6.3)                    -1     PXDP Segment 1'    ! Linear decrease in ET from land surface to 0.5 m below surface
       write(83,*)'        05.0000e-01(20F6.3)                    -1     PETM Segment 1'    ! Linear decrease in ET from land surface to 0.5 m below surface
     else
       write(83,*)'       -1         1         1        -1        -1'	   !  INETSS  INETSR  INETSX  INIETS  INSGDF
       write(83, *)"       20   1.00000(10e14.6)                   -1     ET RATE"
       write(83,'(10e14.6)') ET_matrix_out                ! Write Max ET Rates 
       write(83,*)'       20   1.00000(10e14.6)                   -1     ET DEPTH'
       write(83,'(10e14.6)') Extinction_depth_matrix  ! Write ET Extinction Depth
     end if
     END SUBROUTINE write_MODFLOW_ETS	
     
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
     SUBROUTINE write_MODFLOW_RCH(im,numdays,nrows,ncols,rch_zones)  ! Recharge file            
     
       
       INTEGER, INTENT(IN) :: im,nrows,ncols, numdays
       INTEGER, INTENT(IN) :: rch_zones(nrows,ncols)
       REAL, ALLOCATABLE, DIMENSION(:,:) ::  recharge_matrix
       INTEGER :: ip
       INTEGER, SAVE :: SP = 1
       REAL :: ttl_rch
       CHARACTER(40) :: filename, rch_mat_format
     
       ALLOCATE(recharge_matrix(nrows,ncols))
       recharge_matrix = 0.
       write(rch_mat_format, '(A1,I3,A7)')'(', ncols, 'G14.4)'    
       ! write(84,*)'1'
       ! write(84,*)' OPEN/CLOSE .\recharge\rch_SP'
                  
         do ip = 1, npoly
           where (rch_zones(:,:) == ip) 
             recharge_matrix(:,:) = monthly(ip)%recharge / numdays
           end where
         enddo
         if (SP < 10) then
           write(filename, '(A22,I1,A4)') '.\recharge\recharge_SP_',SP,'.txt'
         elseif (SP < 100) then
         	write(filename, '(A22,I2,A4)') '.\recharge\recharge_SP_',SP,'.txt'
         else
        	write(filename, '(A22,I3,A4)') '.\recharge\recharge_SP_',SP,'.txt'
         endif
         open(unit=84, file=trim(filename), status = 'replace')
         
         write(84,rch_mat_format) recharge_matrix  
         ttl_rch = sum(recharge_matrix*sum(fields%area))
         write(900,*) ttl_rch, ttl_rch*numdays
         SP = SP + 1
         
     END SUBROUTINE write_MODFLOW_RCH
     
!  ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
!      SUBROUTINE write_MODFLOW_RCH_w_MAR(im,month,nday,nrows,ncols,rch_zones,MAR_Matrix)  ! Recharge file  with MAR added during Jan Feb and Mar          
!    
!        
!        INTEGER, INTENT(IN) :: im,month,nrows,ncols
!        INTEGER, INTENT(IN) :: rch_zones(nrows,ncols), nday(0:11)
!        REAL, INTENT(IN) :: MAR_Matrix(nrows,ncols)
!        REAL, ALLOCATABLE, DIMENSION(:,:) ::  recharge_matrix
!        INTEGER :: ip
!        REAL :: rch_sum, MAR_sum, ttl_rch
!    
!        ALLOCATE(recharge_matrix(nrows,ncols))
!        recharge_matrix = 0.
!        
!        if (im == 1) then
!        write(84,'(a31)')'# Recharge File written by SWBM'
!        write(84,*)'PARAMETER  0'
!        write(84,*)'3  50'
!        end if
!        
!        write(84,*)'1  0'
!        write(84,'(a63)')'        18   1.00000(10e14.6)                   -1     RECHARGE'
!         
!          do ip = 1, npoly
!            where (rch_zones(:,:) == ip) 
!              recharge_matrix(:,:) = monthly(ip)%recharge / nday(month)
!            end where
!          enddo
!          if (month == 4 .or. month == 5 .or. month == 6) then          ! If Jan-Mar add recharge from MAR
!            rch_sum = sum(recharge_matrix*10000)                           ! Total of normal recharge rate in m^3/day
!            MAR_sum = sum(MAR_Matrix*10000)                                ! Total of MAR rate in m^3/day
!            ttl_rch = rch_sum + MAR_sum                                    ! Total recharge rate applied to MODFLOW
!            write(*,'(a15,f12.0,a8)')'Non-MAR rate = ',rch_sum,' m^3/day'
!            write(800,'(a15,f12.0,a8)')'Non-MAR rate = ',rch_sum,' m^3/day'
!            recharge_matrix(:,:) = recharge_matrix(:,:) + MAR_Matrix
!            write(*,'(a11,f12.0,a8)')'MAR rate = ',MAR_sum,' m^3/day'
!            write(800,'(a11,f12.0,a8)')'MAR rate = ',MAR_sum,' m^3/day'
!            write(*,'(a22,f12.0,a8)')'Total recharge rate = ',ttl_rch, ' m^3/day'
!            write(800,'(a22,f12.0,a8)')'Total recharge rate = ',ttl_rch, ' m^3/day'
!            write(*,*)''
!            write(800,*),''
!          else
!            ttl_rch = sum(recharge_matrix*10000)
!          end if
!        write(84,'(10e14.6)') recharge_matrix      
!        write(900,*) ttl_rch
!      END SUBROUTINE write_MODFLOW_RCH_w_MAR
!    
! !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	   
   SUBROUTINE convert_length_to_volume
     
     monthly%tot_irr_vol	=	monthly%tot_irr*fields%area
     monthly%pET_vol	=	monthly%pET*fields%area
     monthly%swc_vol	=	monthly%swc*fields%area
     monthly%aET_vol	=	monthly%aET*fields%area
     monthly%recharge_vol	=	monthly%recharge*fields%area
     monthly%gw_irr_vol	=	monthly%gw_irr*fields%area
     monthly%deficiency_vol	=	monthly%deficiency*fields%area
     monthly%effprecip_vol	=	monthly%effprecip*fields%area
     monthly%change_in_storage_vol	=	monthly%change_in_storage*fields%area
     monthly%runoff_vol = monthly%runoff*fields%area
     			
     yearly%tot_irr_vol	=	yearly%tot_irr*fields%area
     yearly%pET_vol	=	yearly%pET*fields%area
     yearly%swc_vol	=	yearly%swc*fields%area
     yearly%aET_vol	=	yearly%aET*fields%area
     yearly%recharge_vol	=	yearly%recharge*fields%area
     yearly%gw_irr_vol	=	yearly%gw_irr*fields%area
     yearly%deficiency_vol	=	yearly%deficiency*fields%area
     yearly%effprecip_vol	=	yearly%effprecip*fields%area
     yearly%change_in_storage_vol	=	yearly%change_in_storage*fields%area
     yearly%runoff_vol = yearly%runoff*fields%area
     
     
   END SUBROUTINE convert_length_to_volume
     
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   SUBROUTINE write_MODFLOW_SFR(im, nmonths, nSegs, model_name)
 
   INTEGER, INTENT(IN) :: im, nmonths, nSegs
   CHARACTER(20), INTENT(IN) :: model_name
   CHARACTER(24) :: sfr_file
   INTEGER :: i
   
   sfr_file = trim(model_name) // '.sfr'
   
   if (im==1) then
     open(unit=213, file=trim(sfr_file), Access = 'append', status='old')
     write(213,'(I4,A12)')nSegs,'  1  0  0  0'      ! Positive value after nSegs suppresses printing of SFR input data to listing file
   else
     write(213,'(I4,A12)')nSegs,'  1  0  0  0'      ! Positive value after nSegs suppresses printing of SFR input data to listing file
   end if
   
   do i = 1, nSegs
     if(SFR_Routing(i)%FLOW<0) SFR_Routing(i)%FLOW = 0   ! Remove negative flow rates caused by rounding errors
     if(SFR_Routing(i)%IUPSEG == 0) then
        write(213,'(I3,I3,I5,I5,2es10.2,A8,F5.3)')SFR_Routing(i)%NSEG, SFR_Routing(i)%ICALC, SFR_Routing(i)%OUTSEG,&
             SFR_Routing(i)%IUPSEG, SFR_Routing(i)%FLOW, SFR_Routing(i)%RUNOFF,'  0  0  ', SFR_Routing(i)%MANNING_N
      elseif(SFR_Routing(i)%IUPSEG > 0) then
        write(213,'(I5,I3,I5,I5,I3,2es10.2,A8,F5.3)')SFR_Routing(i)%NSEG, SFR_Routing(i)%ICALC,& 
          SFR_Routing(i)%OUTSEG, SFR_Routing(i)%IUPSEG, SFR_Routing(i)%IPRIOR, SFR_Routing(i)%FLOW, &
          SFR_Routing(i)%RUNOFF,'  0  0  ', SFR_Routing(i)%MANNING_N
      endif
      write(213,'(F7.2)')SFR_Routing(i)%WIDTH1
      write(213,'(F7.2)')SFR_Routing(i)%WIDTH2
   enddo
     
   END SUBROUTINE  write_MODFLOW_SFR
 ! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   SUBROUTINE write_UCODE_SFR_template(im, nmonths, nSegs, model_name)
 
   INTEGER, INTENT(IN) :: im, nmonths, nSegs
   CHARACTER(20), INTENT(IN) :: model_name
   CHARACTER(24) :: sfr_jtf_file
   INTEGER :: i
   
   sfr_jtf_file = trim(model_name) // '_sfr.jtf'
   
   if (im==1) then
     open(unit=214, file=trim(sfr_jtf_file), Access = 'append', status='old')
     write(214,'(I4,A12)')nSegs,'  1  0  0  0'      ! Positive value after nSegs suppresses printing of SFR input data to listing file
   else
     write(214,'(I4,A12)')nSegs,'  1  0  0  0'      ! Positive value after nSegs suppresses printing of SFR input data to listing file
   end if
   
   do i = 1, nSegs   	
   	    if(SFR_Routing(i)%FLOW<0) SFR_Routing(i)%FLOW = 0   ! Remove negative flow rates caused by rounding errors
   	    if(SFR_Routing(i)%IUPSEG == 0) then
           write(214,'(I3,I3,I5,I5,es10.2,A11,A1,A20,A1)')SFR_Routing(i)%NSEG, SFR_Routing(i)%ICALC, SFR_Routing(i)%OUTSEG,&
                SFR_Routing(i)%IUPSEG, SFR_Routing(i)%FLOW,'  0  0  0  ', '@',SFR_Routing(i)%Manning_n_Param, '@'
         elseif(SFR_Routing(i)%IUPSEG > 0) then
           write(214,'(I5,I3,I5,I5,I3,es10.2,A11,A1,A20,A1)')SFR_Routing(i)%NSEG, SFR_Routing(i)%ICALC,& 
                SFR_Routing(i)%OUTSEG, SFR_Routing(i)%IUPSEG, SFR_Routing(i)%IPRIOR, SFR_Routing(i)%FLOW,'  0  0  0  ',&
                '@', SFR_Routing(i)%Manning_n_Param, '@'
         endif
         write(214,'(F7.2)')SFR_Routing(i)%WIDTH1
         write(214,'(F7.2)')SFR_Routing(i)%WIDTH2
   enddo
     
   END SUBROUTINE  write_UCODE_SFR_template
     
END MODULE
     