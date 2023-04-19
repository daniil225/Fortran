      program main
        common /array/ fArray(200000000)
        common /Size/ iSize_i, iSize_j
C Set dimension after the start general calc
        call SetDimension
        call Check_Dimensinality
C Work with file 
        call LoadData


C Call main operation
        call Mul_Matrix_Vector(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1),fArray(iSize_i*iSize_j+2*iSize_j+1))
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

      subroutine SetDimension()
        common /Size/ iSize_i, iSize_j

        open(1, file="service_par.txt", iostat=ioOpenSerPar)

        call Check_File_Open(ioOpenSerPar, 1)
C hear its ok read from file
C format second = m - tape width first = n - diag len 

        read(1, *, iostat = ioRead)iSize_j, iSize_i
        call Check_File_Read(ioRead, 1)
        close(1)
      end

      subroutine LoadData()
        common /array/ fArray(200000000)
        common /Size/ iSize_i, iSize_j
        open(1, file="diag.txt", iostat=ioOpenDiag)
        open(2, file="mat.txt", iostat=ioOpenMat)
        open(3, file="vect.txt", iostat=ioOpenVect)

C Check correct file open
        call Check_File_Open(ioOpenDiag, 1)
        call Check_File_Open(ioOpenMat, 2)
        call Check_File_Open(ioOpenVect, 3)

C Array Grid: |______________||_______||______|
C                 Matrix Al     Diag     Vect
C       Size:  iSize_i*iSize_j iSize_i  iSize_i
       

C Read diag
        read(1, *, iostat=ioReadDiag)
     &(fArray(iSize_i*iSize_j+i), i=1,iSize_j)
        call Check_File_Read(ioReadDiag, 1)
        
C Read Mat
        do j=1,iSize_j
            read(2, *, iostat=ioReadMat)
     &(fArray((j-1)*iSize_i + i),i=1,iSize_i)
            call Check_File_Read(ioReadMat, 2)
        enddo

C Read Vect 
        read(3, *, iostat=ioReadVect) 
     &(fArray(iSize_i*iSize_j + iSize_j + i), i=1,iSize_j)
        call Check_File_Read(ioReadVect, 3)

C Close all file which were used
        close(1)
        close(2)
        close(3)
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
