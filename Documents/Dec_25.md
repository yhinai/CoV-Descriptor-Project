# Dec 25, 2020 - Arctan2() improvement taylor series approximation


### SobelAccelerator module ###
- The function atan2(Gy/Gx) has been modify to give an approximation using taylor series instead of using an iterative methods like CORDIC. The benefit of using taylor series approximation is to give results at the same clock cycle with about the same accuracy of that is preduced by CORDIC with 16 iterative cycle. The error margen for atan2() function is 1/256 for each results.The only downside to this approched is The only downside to this approach is being calculation intensive which might increase power consumption.

- Normally, atan2() produces output ranged from [-1,1]. The function atan2() implemented is improved to accommodate for 8-bit register degree ranged between [-128, 127]. 