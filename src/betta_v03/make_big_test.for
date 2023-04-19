      program main
        
        ! Get dimension of the test
        read(*, *) iDiag, iTape

     
        open(1, file="data.dat", access="direct", form="unformatted",
     & recl=4)

        write(1, rec=1) iDiag
        write(1, rec=2) iTape
        iOffset = 3

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
        do i=1,iDiag
            write(1, rec=iOffset) 2.0
            iOffset = iOffset + 1
        enddo

        ! Make vector
        do i=1,iDiag
            write(1, rec=iOffset) 1.0
            iOffset = iOffset + 1
        enddo
        close(1)
 

      end