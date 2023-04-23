      program main
        parameter (iSizeMax=2147483646)
        common /array/ fArray(iSizeMax)
        character filename*50
        
        call getarg(1,filename)
        open(1,file="out.txt")
        open(4, file="service_par.txt")
        open(10,file=trim(filename), access='direct', form='unformatted'
     &,recl=4)

        ! Input service par
        read(4, *) iDiag, iTape
        write(*, *) "Input tipe of file: 1 - matrix, 2 - diag or vect"
        read(*, *) in
        iOffset = 1
        
        ! Convert
        if(in .eq. 1) then
            do j=1,iDiag
                do i=1,iTape
                    read(10, rec=iOffset) fArray(i)
                    iOffset = iOffset + 1
                enddo
                write(1, *)(fArray(k), k=1,iTape)
            enddo
        else if(in .eq. 2) then
            do j = 1,iDiag
                read(10, rec=iOffset) fArray(j)
                iOffset = iOffset + 1
            enddo
            write(1, *) (fArray(i), i=1,iDiag)
        endif

        close(1)
        close(4)
        close(10)

      end