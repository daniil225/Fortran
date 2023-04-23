      program main
        
        ! Get dimension of the test
        read(*, *) iDiag, iTape

     
        open(1, file="mat.dat", access="direct", form="unformatted",
     & recl=4)
        open(2, file="diag.dat", access="direct", form="unformatted",
     & recl=4)
        open(3, file="vect.dat", access="direct", form="unformatted",
     & recl=4)
        open(4, file="service_par.txt")
     

        write(4, *) iDiag, iTape
        
        close(4)
        
        iOffset = 1

        ! Make matrix

        do i=1,iDiag-iTape
            do j=1,iTape
                write(1, rec=iOffset) 1.0
                iOffset = iOffset + 1
            enddo
        enddo

        do i=1,iTape
            do j = 1, iTape-i
                write(1, rec=iOffset) 1.0
                iOffset = iOffset + 1
            enddo
            do j = 1, i
                write(1, rec=iOffset) 0.0
                iOffset = iOffset + 1
            enddo
        enddo

        ! Make diag
        iOffset = 1
        do i=1,iDiag
            write(2, rec=iOffset) 2.0
            iOffset = iOffset + 1
        enddo

        iOffset = 1
        ! Make vector
        do i=1,iDiag
            write(3, rec=iOffset) 1.0
            iOffset = iOffset + 1
        enddo
        close(1)
        close(2)
        close(3)

      end