      program main

        common /array/ fa(2147483646)
        character filename*50
        
        call getarg(1,filename)
        open(1,file="out.dat")
        open(4, file="service_par.txt")
        open(10,file=trim(filename), access='direct', form='unformatted'
     &,recl=4)

        
        ! Input service par
        read(4, *) iDiag, iTape
        write(*, *) "Input tipe of file: 1 - matrix, 2 - diag or vect"
        read(*, *) in
        
        iRecIndex = 1

        if(in .eq. 1) then
            do i=1,iDiag
                read(1,*) (fa(j),j=1,iTape)
                do j=1,iTape
                    write(10, rec=iRecIndex) fa(j)
                    iRecIndex = iRecIndex + 1
                enddo
            enddo
        else if (in.eq.2) then
            read(1, *) (fa(i), i=1,iDiag)
            do i=1,iDiag
                write(10, rec=iRecIndex) fa(i)
                iRecIndex = iRecIndex + 1
            enddo
        endif
        

        close(1)
        close(4)
        close(10)
        
      end