# Thiết Kế Lõi IP Mức RTL Cho Mô-đun EMA Trong Các Mô Hình Học Sâu

## Top module

![](./Image/EMA_datapath.png)

## Các module thành phần
### Division
![](./Image/Div.png)
### Exponential
![](./Image/Expo.png)
### SQRT
![](./Image/SQRT.png)
### AvgPoolH/W
![](./Image/AvgHW_datapath.png)
### AvgPool
![](./Image/AvgPool_datapath.png)
### Conv1x1
![](./Image/Conv11_datapath.png)
### Conv3x3
- Top
![](./Image/Conv33_top.png)
- Address
![](./Image/Conv33_address.png)
- Calc
![](./Image/Conv33_calc.png)
### GroupNorm
![](./Image/GroupNorm_datapath.png)
### Sigmoid
![](./Image/Sigmoid_datapath.png)
### Softmax
![](./Image/Softmax_datapath.png)
### Ele-mul
![](./Image/Elemul_datapath.png)
### Matmul
![](./Image/Matmul_datapath.png)
### AddSigmoid
![](./Image/AddSigmoid_datapath.png)
### FinalMul
![](./Image/FinalMul_datapath.png)

## Tổng hợp

![](./Image/Resource.png)
![](./Image/Timing.png)
![](./Image/Power.png)

## Mô phỏng, Kiểm thử

### Mô phỏng
![](./Image/Runtime.png)

### Kiểm thử
![](./Image/ILA.png)
![](./Image/ILA2.png)
![](./Image/ILA3.png)
