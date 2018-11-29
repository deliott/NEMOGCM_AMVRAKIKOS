MODULE dtassh
   !!======================================================================
   !!                     ***  MODULE  dtassh  ***
   !! Ocean data  :  read ocean ssh data fromgridded data 
   !!======================================================================

   !!----------------------------------------------------------------------
   !!   dta_ssh      : read and time interpolated ocean ssh data
   !!----------------------------------------------------------------------
   USE oce             ! ocean dynamics and tracers
   USE dom_oce         ! ocean space and time domain
   USE fldread         ! read input fields
   USE in_out_manager  ! I/O manager
   USE phycst          ! physical constants
   USE lib_mpp         ! MPP library
   USE wrk_nemo        ! Memory allocation
   USE timing          ! Timing

   IMPLICIT NONE
   PRIVATE

   PUBLIC   dta_ssh_init   ! called by opa.F90
   PUBLIC   dta_ssh        ! called by istate.F90 and tradmp.90

   LOGICAL , PUBLIC ::   ln_ssh_init      !: ssh data flag
   LOGICAL , PUBLIC ::   ln_ssh_sshdmp    !: internal damping toward input data flag

   TYPE(FLD), ALLOCATABLE, DIMENSION(:) ::   sf_ssh   ! structure of input SSH (file informations, fields read)

   !! * Substitutions
#  include "domzgr_substitute.h90"
   !!----------------------------------------------------------------------
   !! NEMO/OPA 3.3 , NEMO Consortium (2010)
   !! $Id: dtatem.F90 2392 2010-11-15 21:20:05Z gm $ 
   !! Software governed by the CeCILL licence     (NEMOGCM/NEMO_CeCILL.txt)
   !!----------------------------------------------------------------------
CONTAINS

   SUBROUTINE dta_ssh_init( ld_sshdmp )
      !!----------------------------------------------------------------------
      !!                   ***  ROUTINE dta_ssh_init  ***
      !!                    
      !! ** Purpose :   initialisation of ssh input data 
      !! 
      !! ** Method  : - Read namssh namelist
      !!              - allocates ssh data structure 
      !!----------------------------------------------------------------------
      LOGICAL, INTENT(in), OPTIONAL ::   ld_sshdmp   ! force the initialization when tradp is used
      !
      INTEGER ::   ierr0, ierr1                      ! temporary integers
      !
      CHARACTER(len=100)            ::   cn_dir      ! Root directory for location of ssr files
      TYPE(FLD_N), DIMENSION( 1)    ::   slf_i       ! array of namelist informations on the fields to read
      TYPE(FLD_N)                   ::   sn_ssh
      !!
      NAMELIST/namssh/   ln_ssh_init, ln_ssh_sshdmp, cn_dir, sn_ssh
      INTEGER  ::   ios
      !!----------------------------------------------------------------------
      !
      IF( nn_timing == 1 )  CALL timing_start('dta_ssh_init')
      !
      !  Initialisation
      ierr0 = 0  ;  ierr1 = 0  
      !
      REWIND( numnam_ref )              ! Namelist namssh in reference namelist : 
      READ  ( numnam_ref, namssh, IOSTAT = ios, ERR = 901)
901   IF( ios /= 0 ) CALL ctl_nam ( ios , 'namtsd in reference namelist', lwp )

      REWIND( numnam_cfg )              ! Namelist namssh in configuration namelist : Parameters of the run
      READ  ( numnam_cfg, namssh, IOSTAT = ios, ERR = 902 )
902   IF( ios /= 0 ) CALL ctl_nam ( ios , 'namtsd in configuration namelist', lwp )
      IF(lwm) WRITE ( numond, namssh )

      IF( PRESENT( ld_sshdmp ) )   ln_ssh_sshdmp = .TRUE.     ! forces the initialization when tradmp is used
      
      IF(lwp) THEN                  ! control print
         WRITE(numout,*)
         WRITE(numout,*) 'dta_ssh_init : ssh data '
         WRITE(numout,*) '~~~~~~~~~~~~ '
         WRITE(numout,*) '   Namelist namssh'
         WRITE(numout,*) '      Initialisation of ocean ssh with ssh input data   ln_ssh_init   = ', ln_ssh_init
         WRITE(numout,*) '      damping of ocean ssh toward ssh input data        ln_ssh_sshdmp = ', ln_ssh_sshdmp
         WRITE(numout,*)
         IF( .NOT.ln_ssh_init .AND. .NOT.ln_ssh_sshdmp ) THEN
            WRITE(numout,*)
            WRITE(numout,*) '   ssh data not used'
         ENDIF
      ENDIF
      !
      IF( ln_rstart .AND. ln_ssh_init ) THEN
         CALL ctl_warn( 'dta_ssh_init: ocean restart and ssh data intialisation, ',   &
            &           'we keep the restart ssh values and set ln_ssh_init to FALSE' )
         ln_ssh_init = .FALSE.
      ENDIF
      !
      !                             ! allocate the arrays (if necessary)
      IF(  ln_ssh_init .OR. ln_ssh_sshdmp  ) THEN
         !
         ALLOCATE( sf_ssh(1), STAT=ierr0 )
         IF( ierr0 > 0 ) THEN
            CALL ctl_stop( 'dta_ssh_init: unable to allocate sf_ssh structure' )   ;   RETURN
         ENDIF
         !
                                ALLOCATE( sf_ssh(1)%fnow(jpi,jpj,1)   , STAT=ierr0 )
         IF( sn_ssh%ln_tint )   ALLOCATE( sf_ssh(1)%fdta(jpi,jpj,1,2) , STAT=ierr1 )
         !
         IF( ierr0 + ierr1 > 0 ) THEN
            CALL ctl_stop( 'dta_ssh : unable to allocate ssh data arrays' )   ;   RETURN
         ENDIF
         !                         ! fill sf_ssh with sn_ssh and control print
         slf_i(1) = sn_ssh  
         CALL fld_fill( sf_ssh, slf_i, cn_dir, 'dta_ssh', 'SSH data', 'namssh' )
         !
      ENDIF
      !
      IF( nn_timing == 1 )  CALL timing_stop('dta_ssh_init')
      !
   END SUBROUTINE dta_ssh_init


   SUBROUTINE dta_ssh( kt, pssh )
      !!----------------------------------------------------------------------
      !!                   ***  ROUTINE dta_ssh  ***
      !!                    
      !! ** Purpose :   provides SSH data at kt
      !! 
      !! ** Method  : - call fldread routine
      !!              - ORCA_R2: add some hand made alteration to read data  
      !!              - 'key_orca_lev10' interpolates on 10 times more levels
      !!              - s- or mixed z-s coordinate: vertical interpolation on model mesh
      !!              - ln_ssh_sshdmp=F: deallocates the SSH data structure
      !!                as SSH data are no are used
      !!
      !! ** Action  :   pssh   SSH data on medl mesh and interpolated at time-step kt
      !!----------------------------------------------------------------------
      INTEGER                           , INTENT(in   ) ::   kt     ! ocean time-step
      REAL(wp), DIMENSION(jpi,jpj)      , INTENT(  out) ::   pssh   ! SSH data
      !
      !!----------------------------------------------------------------------
      !
      IF( nn_timing == 1 )  CALL timing_start('dta_ssh')
      !
      CALL fld_read( kt, 1, sf_ssh )      !==   read SSH data at kt time step   ==!
      !
      !
      pssh(:,:) = sf_ssh(1)%fnow(:,:,1)    ! NO mask
      !
      pssh(:,:) = pssh(:,:) * tmask(:,:,1)    ! Mask
      !
      IF( lwp .AND. kt == nit000 ) THEN
         WRITE(numout,*) ' SSH in the ATL '
         WRITE(numout,*)
         CALL prihre( pssh(:,:), jpi, jpj, 1, jpi, 20, 1, jpj, 20, 1., numout )
      ENDIF
      !
      IF( .NOT.ln_ssh_sshdmp ) THEN                   !==   deallocate SSH structure   ==! 
         !                                              (data used only for initialisation)
         IF(lwp) WRITE(numout,*) 'dta_ssh: deallocte SSH arrays as they are only use to initialize the run'
                                        DEALLOCATE( sf_ssh(1)%fnow )         ! SSH arrays in the structure
         IF(lwp) WRITE(numout,*) 'DEALLOCATION first part is done ok'
         IF( sf_ssh(1)%ln_tint )        DEALLOCATE( sf_ssh(1)%fdta )
         IF(lwp) WRITE(numout,*) 'DEALLOCATION second part is done ok'
                                        DEALLOCATE( sf_ssh         )         ! the structure itself
         IF(lwp) WRITE(numout,*) 'DEALLOCATION is dta_ssh is done ok'
      ENDIF
      !
      IF( nn_timing == 1 )  CALL timing_stop('dta_ssh')
      !
   END SUBROUTINE dta_ssh

   !!======================================================================
END MODULE dtassh
