      programe main
C first work with fortran array
       common /array/ fArr(100)
       common /apt/ fEx
       istart = 1
       iend = 10

       fEx = -55.0
C       call example(1, 10)
C       call example2(11, 20)
C       call example3

        call read_file

      end


      subroutine read_file()
        common /array/ fArr(100)

        iSize_j = 3
        iSize_i = 6
        open(1, file="on.txt", iostat=ioOpen)

        if(ioOpen .eq. 0) then
            print *, "Good"
        else
            print *, "Bad file"
        endif
        
        do j=1,iSize_j
            read(1, *, iostat=ioRead)(fArr((j-1)*iSize_i+i),i=1,iSize_i)
            if(ioRead > 0) then
                print *, "Error read"
            endif
        enddo

        do j=1,iSize_j
            do i=1,iSize_i
                print '(f6.0 $)', fArr((j-1)*iSize_i +i)
            enddo
            print *, ""
        enddo

        close(1)
      
      end


      subroutine example(istart, iend)
        common /array/ fArr(100)
        
        do i=istart,iend
            fArr(i) = i
        enddo
      end

      subroutine example2(istart, iend)
        common /array/ fArr(100)
        do i=istart,iend
            fArr(i) = -1*i
        enddo
      end


      subroutine example3()
        common /array/ fArr(100)
        dimension FMatrix(2,10)

        do i=1,2
            do j=1,10
                FMatrix(i,j) = fArr((i-1)*10+j)
                print '(E11.4 $)' , fArr((i-1)*10+j)
            enddo
            print *, ''
        enddo
        
        print *, FMatrix(2,1)
      end