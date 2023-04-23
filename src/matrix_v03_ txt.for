      program main
        parameter (iSizeMax=2147483646)
        common /array/ fArray(iSizeMax)
        common /Size/ iSize_i, iSize_j
C Set dimension after the start general calc
        call SetDimension
        call Check_Dimensinality(iSizeMax)
C Work with file 
        call LoadData(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1))


C Call main operation
        call Mul_Matrix_Vector(fArray(1),fArray(iSize_i*iSize_j+1),fArra
     &y(iSize_i*iSize_j+iSize_j+1),fArray(iSize_i*iSize_j+2*iSize_j+1))
      end

      subroutine Check_Dimensinality(iSizeMax)
        common /Size/ iSize_i, iSize_j

        iRes = iSize_i*iSize_j + 3*iSize_j

        if(iRes .gt. iSizeMax) then
            print *, "Memory Allocated Error"
            stop
        endif
      end


      subroutine SetDimension()
        common /Size/ iSize_i, iSize_j

        open(1, file="service_par.txt")

C hear its ok read from file
C format second = m - tape width first = n - diag len 

        read(1, *)iSize_j, iSize_i
        close(1)
      end

      subroutine LoadData(fAl, fDiag, fVect)
        common /Size/ iSize_i, iSize_j

        dimension fAl(iSize_i, *), fDiag(iSize_j)
        dimension fVect(iSize_j)

        open(1, file="diag.txt")
        open(2, file="mat.txt")
        open(3, file="vect.txt")

C Read diag
        read(1, *)(fDiag(i), i=1,iSize_j)
C Read Mat
        do j=1,iSize_j
            read(2, *)(fAl(i,j),i=1,iSize_i)
        enddo

C Read Vect 
        read(3, *)(fVect(i), i=1,iSize_j)

C Close all file which were used
        close(1)
        close(2)
        close(3)
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
