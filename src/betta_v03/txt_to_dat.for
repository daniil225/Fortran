      program main
        dimension fa(20000000)
        open(1,file="diag.txt")
        open(2,file="mat.txt")
        open(3,file="vect.txt")
        open(4,file="service_par.txt")
        open(10,file="data.dat", access='direct', form='unformatted'
     &,recl=4)

        ! 5 - first diag size  3 - second  tape width
        read(4, *) iDiag, iTape

        

        write(10, rec=1) iDiag
        write(10, rec=2) iTape
        iRecIndex = 3


        ! Mat read 
        do i=1,iDiag
            read(2,*) (fa(j),j=1,iTape)
            do j=1,iTape
                write(10, rec=iRecIndex) fa(j)
                iRecIndex = iRecIndex + 1
            enddo
        enddo

        ! Diag read
        read(1, *) (fa(i), i=1,iDiag)
        do i=1,iDiag
            write(10, rec=iRecIndex) fa(i)
            iRecIndex = iRecIndex + 1
        enddo


        ! Vect read
        read(3, *) (fa(i), i=1,iDiag)
        do i=1,iDiag
            write(10, rec=iRecIndex) fa(i)
            iRecIndex = iRecIndex + 1
        enddo

        close(1)
        close(2)
        close(3)
        close(4)
        close(10)

        
      end