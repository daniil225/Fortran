      program main
        common /array/ fArray(200000000)
        common /Size/ iSize_i, iSize_j

        ! Set dimension
        call SetDimension
        call Check_Dimensinality
        ! Work with file
        call LoadData

        ! call main operation 
        call Mul_Matrix_Vector(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1),fArray(iSize_i*iSize_j+2*iSize_j+1))

      end

      subroutine Mul_Matrix_Vector(fAl, fDiag, fVect, fRes)
        common /Size/ iSize_i, iSize_j

        dimension fAl(iSize_i, iSize_j), fDiag(iSize_j)
        dimension fVect(iSize_j),fRes(iSize_j)
        do j=1,iSize_j-iSize_i
            do i=1,iSize_i
                fRes(j) = fRes(j) + fAl(i,j)*fVect(i+j)
                fRes(i+j) = fRes(i+j) + fAl(i,j)*fVect(j)
            enddo
        enddo
      
        do i=1,iSize_j
            fRes(i) = fRes(i) + fVect(i)*fDiag(i)
        enddo

        iOffset = iSize_j-iSize_i

        do i=1,iSize_i-1
            do j=1,iSize_i-i
                fRes(i+iOffset) = fRes(i+iOffset) + 
     &fAl(j, i+iOffset)*fVect(iOffset+i+j)
                fRes(i+iOffset+j) = fRes(i+iOffset+j) +
     & fAl(j, i+iOffset)*fVect(i+iOffset) 
            enddo
        enddo

C print Res
        open(1, file="res.txt")
        write(1, *) (fRes(i), i=1,iSize_j)
        close(1)
      end


      subroutine SetDimension()
        common /Size/ iSize_i, iSize_j

       open(1, file="data.dat", access="direct", form="unformatted",
     & recl=4, iostat=ioOpen)


        call Check_File_Open(ioOpen, 1)
C hear its ok read from file
C format second = m - tape width first = n - diag len 
        read(1, rec=1, iostat=ioRead) iSize_j
        call Check_File_Read(ioRead, 1)
        read(1, rec=2,iostat=ioRead) iSize_i
        call Check_File_Read(ioRead, 1)
        close(1)
      end
     
      subroutine Check_Dimensinality()
        common /Size/ iSize_i, iSize_j

        iRes = iSize_i*iSize_j + 3*iSize_j

        if(iRes .gt. 200000000) then
            print *, "Memory Allocated Error"
            stop
        endif
      end

      subroutine Check_File_Open(ioOpen, iFile_descriptor)
        if(ioOpen .ne. 0) then
            print *, "File cannot open"
            close(iFile_descriptor)
            stop
        endif
      end

      subroutine Check_File_Read(ioRead, iFile_descriptor)
        if(ioRead .lt. 0) then
            print *, "Warning parametr less than nead"
            close(iFile_descriptor)
            stop
        else if(ioRead .gt. 0) then
            print *, "Error read file"
            close(iFile_descriptor)
            stop
        endif
      end


      subroutine LoadData()
        common /array/ fArray(200000000)
        common /Size/ iSize_i, iSize_j
        open(1, file="data.dat", access="direct", form="unformatted",
     & recl=4, iostat=ioOpen)

        call Check_File_Open(ioOpen, 1)
        
        ! Start offset for read from file
        iOffset = 3


        do j=1,iSize_j
            do i=1,iSize_i
                read(1, rec=iOffset, iostat=ioRead) 
     &fArray((j-1)*iSize_i + i)
                iOffset = iOffset + 1
            enddo
        enddo

        call Check_File_Read(ioRead, 1)
        
        do i=1,iSize_j
            read(1, rec=iOffset, iostat=ioRead)fArray(iSize_i*iSize_j+i)
            iOffset = iOffset + 1
        enddo

        call Check_File_Read(ioRead, 1)

        do i=1,iSize_j
            read(1, rec=iOffset, iostat=ioRead)
     &fArray(iSize_i*iSize_j+iSize_j+i)
            iOffset = iOffset + 1
        enddo

        call Check_File_Read(ioRead, 1)        
        close(1)
      end
