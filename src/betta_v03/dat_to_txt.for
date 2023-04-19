      program main
        common /array/ fArray(20000000)
        open(1,file="diag.txt")
        open(2,file="mat.txt")
        open(3,file="vect.txt")
        open(4,file="service_par.txt")
        open(10,file="data.dat", access='direct', form='unformatted'
     &,recl=4)

        ! service_data | mat | diag | vect
        
        read(10, rec=1) iDiag
        read(10, rec=2) iTape
        write(4, *) iDiag, iTape


        iOffset = 3 
        do j=1,iDiag
            do i=1,iTape
                read(10, rec=iOffset) fArray(i)
                iOffset = iOffset + 1
            enddo
            write(2, *)(fArray(k), k=1,iTape)
        enddo

        do j = 1,iDiag
            read(10, rec=iOffset) fArray(j)
            iOffset = iOffset + 1
        enddo
        write(1, *) (fArray(i), i=1,iDiag)

        do j=1,iDiag
            read(10, rec=iOffset) fArray(j)
            iOffset = iOffset + 1
        enddo

        write(3, *) (fArray(i), i=1,iDiag)
    
        close(1)
        close(2)
        close(3)
        close(4)

      end