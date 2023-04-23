      program main
        parameter (iSizeMax=2147483646)
        common /array/ fArray(iSizeMax)
        common /Size/ iSize_i, iSize_j

        ! Set dimension
        call SetDimension
        call Check_Dimensinality(iSizeMax)
        ! Work with file
        call LoadData(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1))

        ! call main operation 
        call Mul_Matrix_Vector(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1),fArray(iSize_i*iSize_j+2*iSize_j+1))

      end

      subroutine Mul_Matrix_Vector(fAl, fDiag, fVect, fRes)
        common /Size/ iSize_i, iSize_j

        dimension fAl(iSize_i, iSize_j), fDiag(iSize_j)
        dimension fVect(iSize_j),fRes(iSize_j)
        
        do i=1,iSize_j
          fRes(i) = fVect(i)*fDiag(i)
      enddo

        do j=1,iSize_j-iSize_i
            do i=1,iSize_i
                fRes(j) = fRes(j) + fAl(i,j)*fVect(i+j)
                fRes(i+j) = fRes(i+j) + fAl(i,j)*fVect(j)
            enddo
        enddo
      
        iOffset = iSize_j-iSize_i

        do i=1,iSize_i-1
            k = i + iOffset
            do j=1,iSize_i-i
                fRes(k) = fRes(k) + fAl(j, k)*fVect(k+j)
                fRes(k+j) = fRes(k+j) + fAl(j, k)*fVect(k) 
            enddo
        enddo

C print Res
        open(1, file="res.txt")
        write(1, *) (fRes(i), i=1,iSize_j)
        close(1)
      end


      subroutine SetDimension()
        common /Size/ iSize_i, iSize_j

        open(1, file="service_par.txt")
C hear its ok read from file
C format second = m - tape width first = n - diag len 

        read(1, *)iSize_j, iSize_i
        close(1)
      end
     
      subroutine Check_Dimensinality(iSizeMax)
        common /Size/ iSize_i, iSize_j

        iRes = iSize_i*iSize_j + 3*iSize_j

        if(iRes .gt. iSizeMax) then
            print *, "Memory Allocated Error"
            stop
        endif
      end

      subroutine LoadData(fAl, fDiag, fVect)
        
        dimension fAl(iSize_i, *), fDiag(iSize_j)
        dimension fVect(iSize_j)
        common /Size/ iSize_i, iSize_j

        open(1, file="mat.dat", access="direct", form="unformatted",
     & recl=4)
        open(2, file="diag.dat", access="direct", form="unformatted",
     & recl=4)
        open(3, file="vect.dat", access="direct", form="unformatted",
     & recl=4)

        ! Start offset for read from file
        iOffset = 1

        do j=1,iSize_j
            do i=1,iSize_i
                read(1, rec=iOffset)fAl(i,j)
                iOffset = iOffset + 1
            enddo
        enddo

        iOffset = 1

        do i=1,iSize_j
            read(2, rec=iOffset, iostat=ioRead)fDiag(i)
            iOffset = iOffset + 1
        enddo

        iOffset = 1
        do i=1,iSize_j
            read(3, rec=iOffset) fVect(i)
            iOffset = iOffset + 1
        enddo
        
        close(1)
        close(2)
        close(3)
      end
