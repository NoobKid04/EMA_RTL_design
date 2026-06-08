# EMA Attention Module - VHDL Implementation

## Quy tắc làm việc
- **KHÔNG tự sửa, chỉnh sửa hay viết lại nội dung văn bản đã có** trong file .tex trừ khi được yêu cầu rõ ràng.
- Khi được hỏi về nội dung đồ án (chương, mục), chỉ **đề xuất / soạn thảo nội dung mới** để người dùng xem xét, không tự động ghi vào file.
- **KHÔNG ghi vào file .tex** trừ khi người dùng xác nhận rõ ràng ("chèn vào", "ghi vào file", "cập nhật file"...).
- Khi soạn thảo nội dung cho một mục có hình minh họa, **đọc ảnh trong thư mục `Image/`** trước để mô tả chính xác theo sơ đồ đã vẽ.

## Project
Chuyển EMA attention module (ResNet50 + CIFAR-100) sang VHDL.
Model: top1=80.69%, weights file: ema_model_best.pth.tar

## Architecture
- ResNet50 on CIFAR-100 (input 32x32)
- Layer2: channels=512, groups=32, C/G=16, spatial=16x16
- 4 blocks: layer2.0 ~ layer2.3 (dang implement layer2.0)

## EMA Module Flow (1 group)
```
Input [16, 16, 16]
  ├─ pool_h [16, 16, 1] ─┐
  ├─ pool_w [16, 1, 16] ─┘─ cat ─→ [16, 32, 1] ─→ conv1x1 ─→ split → x_h, x_w
  ├─ x1 = gn(input * sigmoid(x_h) * sigmoid(x_w))
  ├─ x2 = conv3x3(input)
  ├─ x11 = softmax(agp(x1))  → [1, 16]
  ├─ x12 = x2.reshape         → [16, 256]
  ├─ x21 = softmax(agp(x2))  → [1, 16]
  ├─ x22 = x1.reshape         → [16, 256]
  ├─ weights = (matmul(x11,x12) + matmul(x21,x22)).reshape → [1, 16, 16]
  └─ output = input * sigmoid(weights)
```

## Fixed-Point Format
- Q8.8: signed 16-bit, 8 fractional bits, scale=256
- Multiply: Q8.8 x Q8.8 = Q16.16 (32-bit)
- After accumulation: shift >>8 + bias → Q8.8
- Accumulator: use 40-bit to avoid overflow
- Cac so lien quan den tinh toan (feature map, weight, bias, mean, var, ...): Q8.8
- Cac so lien quan den dia chi (addr BRAM, counter oc/oh/ow/ic, H, W, HW, ...): Q16 (unsigned 16-bit integer)

## Conv3x3 Parameters (layer2.0)
- Weight: [16][16][3][3] = 2304 values, addr = oc*144 + ic*9 + ky*3 + kx
- Bias: [16] values
- Input: [16][16][16] = 4096 values, addr = ic*256 + oh*16 + ow
- Output: [16][16][16] = 4096 values
- MAC per pixel: 16 x 3 x 3 = 144
- Total MAC: 144 x 4096 = 589,824

## Conv1x1 Parameters (layer2.0)
- Weight: [16][16] = 256 values, addr = oc*16 + ic
- Bias: [16] values
- Input: [16][32][1] = 512 values (cat of pool_h + pool_w)
- MAC per pixel: 16, Total MAC: 16 x 32 = 512

## Matmul (attention)
- x11 [1, 16] x x12 [16, 256] = [1, 256]
- MAC per pixel: 16, Total: 16 x 256 = 4,096

## Address Computation (no ky/kx counters)
Conv3x3 input address: compute center = ic*256 + oh*16 + ow, then 9 offsets:
```
[-17] [-16] [-15]     (-W-1, -W, -W+1)
[ -1] [  0] [ +1]
[+15] [+16] [+17]     (+W-1, +W, +W+1)
```
4 Sub + 4 Add from center, all 9 computed simultaneously.

Padding valid signals (9 bits):
- valid[0] = (oh > 0)  AND (ow > 0)
- valid[1] = (oh > 0)
- valid[2] = (oh > 0)  AND (ow < 15)
- valid[3] = (ow > 0)
- valid[4] = always '1'
- valid[5] = (ow < 15)
- valid[6] = (oh < 15) AND (ow > 0)
- valid[7] = (oh < 15)
- valid[8] = (oh < 15) AND (ow < 15)

## Datapath (conv3x3)
- 9 Mul parallel (16-bit x 16-bit = 32-bit)
- Adder tree: 8 adders (4 levels) to sum 9 products
- Accumulator register (40-bit), iterate 16 ic
- Shift >>8 + bias → output Q8.8

## Loop Counter Order (outer → inner)
oc(0..15) → oh(0..15) → ow(0..15) → ic(0..15) → [9 positions parallel]

## BRAM Read Latency
- BRAM đọc hết 2 chu kỳ (address → data có độ trễ 2 cycle).
- FSM/pipeline phải chờ 2 cycle sau khi đặt address mới được dùng dout.

## Tóm tắt bài báo gốc (EMA - ICASSP 2023)
- **Tên:** "Efficient Multi-Scale Attention Module with Cross-Spatial Learning"
- **Tác giả:** Daliang Ouyang, Su He, Guozhong Zhang, Mingzhu Luo, Huaiyong Guo, Jian Zhan, Zhijie Huang
- **Venue:** ICASSP 2023 — DOI: 10.1109/ICASSP49357.2023.10096516 — arXiv: 2305.13563
- **Ý tưởng cốt lõi:**
  - Chia channel thành G=32 nhóm, xử lý độc lập từng nhóm C/G kênh
  - Không dùng channel reduction (khác SE, CBAM, CA)
  - Hai nhánh song song: Conv1x1 (với spatial pooling attention) + Conv3x3
  - Cross-spatial learning: weights = matmul(softmax(AGP(x1)), reshape(x2)) + matmul(softmax(AGP(x2)), reshape(x1))
  - Output = input × sigmoid(weights)
- **Kết quả:** ResNet50+CIFAR-100: Top-1=80.69% (baseline 77.26%), vượt SE/CBAM/CA/ECA/SA
- **Code gốc:** https://github.com/YOLOonMe/EMA-attention-module (PyTorch)

## Tóm tắt các file VHDL chính

### Top-level
- **EMA.vhd** — Module top-level, kết nối EMA_controller + EMA_datapath
- **EMA_controller.vhd** — FSM điều phối trình tự toàn bộ pipeline EMA
- **EMA_datapath.vhd** — Kết nối dữ liệu giữa tất cả các khối con

### Tích chập
- **conv33.vhd / conv33_controller.vhd / conv33_datapath.vhd** — Conv3x3: weight[16][16][3][3], 9 mul song song, adder tree, acc 40-bit
- **conv11.vhd / conv11_controller.vhd / conv11_datapath.vhd** — Conv1x1: weight[16][16], input[16][32] (cat pool_h+pool_w)

### Pooling
- **AvgPoolH.vhd / AvgPoolH_controller.vhd / AvgPoolH_datapath.vhd** — Pool theo chiều W → [C,H,1], chia ÷16 = >>4
- **AvgPoolW.vhd / AvgPoolW_controller.vhd / AvgPoolW_datapath.vhd** — Pool theo chiều H → [C,1,W]
- **AvgPool.vhd / AvgPool_controller.vhd / AvgPool_datapath.vhd** — Global avg pool → [C,1,1]

### Chuẩn hóa & kích hoạt
- **GroupNorm.vhd / GroupNorm_controller.vhd / GroupNorm_datapath.vhd** — GN: mean→var→inv_std→affine, dùng SQRT + Div
- **Sigmoid2D.vhd / Sigmoid2D_controller.vhd / Sigmoid2D_datapath.vhd** — Sigmoid cho feature map 2D, dùng LUT
- **Softmax.vhd / Softmax_controller.vhd / Softmax_datapath.vhd** — Softmax[1,16]: exp LUT → sum → div

### Phép nhân & tính toán
- **Matmul.vhd / Matmul_controller.vhd / Matmul_datapath.vhd** — x11[1,16]×x12[16,256] + x21[1,16]×x22[16,256]
- **elemul.vhd / elemul_controller.vhd / elemul_datapath.vhd** — Element-wise multiply, dùng cho input×sig_h×sig_w
- **AddSigmoid.vhd / AddSigmoid_controller.vhd / AddSigmoid_datapath.vhd** — Cộng 2 kết quả matmul rồi áp sigmoid
- **FinalAdd.vhd / FinalAdd_controller.vhd / FinalAdd_datapath.vhd** — output = input × sigmoid(weights)

### Toán tử cơ bản
- **mul_16bit.vhd** — Bộ nhân Q8.8×Q8.8=Q16.16, dùng Booth encoding + Wallace tree
- **booth_encoder.vhd / booth_encoder_32.vhd** — Mã hóa Booth cho bộ nhân
- **wallace_tree.vhd / wallace_tree_16.vhd** — Cây Wallace nén partial products
- **cla_4bit.vhd / cla_16bit.vhd / cla_18bit.vhd / cla_32bit.vhd** — Carry-Lookahead Adder các độ rộng
- **Div_16bit.vhd / Div_16bit_Controller.vhd / Div_16bit_Datapath.vhd** — Chia 16-bit tuần tự, 16 chu kỳ
- **Div_32bit.vhd / Div_32bit_controller.vhd / Div_32bit_datapath.vhd** — Chia 32-bit
- **SQRT.vhd / SQRT_controller.vhd / SQRT_datapath.vhd** — Căn bậc hai (Newton-Raphson iterative), dùng trong GroupNorm
- **sub_16bit.vhd / sub_32bit.vhd** — Bộ trừ
- **barrel_shift_left.vhd / barrel_shift_right.vhd** — Barrel shifter

### Exp / LUT
- **Exp.vhd / Exp_Controller.vhd / Exp_Datapath.vhd** — Tính exp(x) = exp(int) × exp(frac) qua LUT
- **exp_lut_int.vhd / exp_lut_frac.vhd / exp_lut_frac2.vhd** — LUT cho exp(x), x > 0
- **expneg_lut_int.vhd / expneg_lut_frac.vhd / expneg_lut_frac2.vhd** — LUT cho exp(-x)
- **exp_softmax.vhd / exp_continuos.vhd** — Biến thể exp dùng trong Softmax

### BRAM
- **bram_conv3x3_weight.vhd** — ROM weight Conv3x3: 2304 × 16-bit
- **bram_conv3x3_bias.vhd** — ROM bias Conv3x3: 16 × 16-bit
- **bram_conv1x1_weight.vhd** — ROM weight Conv1x1: 256 × 16-bit
- **bram_conv1x1_bias.vhd** — ROM bias Conv1x1: 16 × 16-bit
- **bram_gn_weight.vhd / bram_gn_bias.vhd** — ROM gamma/beta GroupNorm

### Thanh ghi & tiện ích
- **Reg1bit.vhd / Regn.vhd** — Thanh ghi 1-bit và n-bit
- **My_component_lib.vhd** — Package khai báo tất cả component dùng chung
- **ac701.xdc** — Constraints file cho bo mạch AC701

### Dữ liệu kiểm tra
- **fmap_q8p8_16bit_4096.coe** — Input feature map (4096 × Q8.8)
- **conv3x3_output.coe** — Kết quả kỳ vọng Conv3x3
- **ema_to_gn_x1.coe** — Dữ liệu vào GroupNorm (sau ElemMul)
- **random_input_q8_8.coe** — Input ngẫu nhiên cho test

## LaTeX Class: uetgraduation (QUAN TRỌNG)

### Compiler
- Phải dùng **LuaLaTeX** (có `\directlua`, `fontspec`) — KHÔNG dùng pdflatex hay xelatex.

### Trang & font
- Lề: left=3cm, right=2cm, top=2.5cm, bottom=2cm
- Font chính: Times New Roman, cỡ 10pt, line-height 13pt
- Paragraph indent: 1cm, parskip: 6pt

### Cấu trúc cấp độ
- Chỉ có 3 cấp: `\chapter{}`, `\section{}`, `\subsection{}` — **KHÔNG có `\subsubsection`**
- TOC depth = 3 (chapter / section / subsection)
- Chapter prefix mặc định là "Chương", phụ lục dùng `\appendix` để đổi thành "Phụ lục A, B..."

### Cú pháp Figure & Table — KHÁC LaTeX chuẩn
Class này định nghĩa lại `figure` và `table`. Caption **KHÔNG dùng `\caption{}`** mà là **tham số thứ 2** của `\begin{}`:
```latex
% Figure — caption là tham số bắt buộc thứ 2
\begin{figure}[h]{Tên hình minh họa}
    \centering
    \includegraphics[width=0.7\textwidth]{Image/ten_anh.png}
    \label{fig:ten_nhan}
\end{figure}

% Table — caption xuất hiện phía TRÊN nội dung (tự động)
\begin{table}[h]{Tên bảng}
    \centering
    \begin{tabular}{...}
    ...
    \end{tabular}
    \label{tab:ten_nhan}
\end{table}
```
- Số hình: `Hình X.Y` (X = chương, Y = số thứ tự trong chương)
- `\label` đặt bên trong môi trường, sau dòng `\centering` — `\ref{}` sẽ trả về số hình/bảng đúng
- `\listoffigures` → "Danh sách hình vẽ", `\listoftables` → "Danh sách bảng"

### Tài liệu tham khảo — KHÁC LaTeX chuẩn
Không dùng `\bibliography{}` hay `natbib`. Cú pháp bắt buộc:
```latex
\begin{thebibliography}{9}
    \begin{bibsection}{Tiếng Việt}   % hoặc Tiếng Anh
        \bibitem{key1} Tác giả, ...
        \bibitem{key2} Tác giả, ...
    \end{bibsection}
\end{thebibliography}
```

### Quy tắc trình bày TLTK (theo Phụ lục 04 UET)

**Sắp xếp:**
- Chia theo ngôn ngữ: `\begin{bibsection}{Tiếng Việt}`, `\begin{bibsection}{Tiếng Anh}`
- Trong mỗi nhóm: xếp ABC theo họ tác giả
  - Tác giả nước ngoài: theo **last name** (D. Ouyang → xếp theo O)
  - Tác giả Việt Nam: theo **tên** nhưng giữ nguyên thứ tự họ-tên (Nguyễn Văn An → xếp theo A)

**Định dạng bài báo (journal/conference):**
```
Tác giả, ``Tên bài báo'', \textit{Tên tạp chí/hội nghị}, Vol. X, No. Y, Năm, pp. xx--yy.
```
- Tên bài báo: trong dấu ngoặc kép (```` ``...'' ````) — KHÔNG in nghiêng
- Tên tạp chí/hội nghị: in nghiêng (`\textit{}`)
- Dùng `pp.` cho số trang, `--` cho khoảng trang

**Định dạng sách:**
```
Tác giả, \textit{Tên sách}, Nhà xuất bản, Năm, pp. xx--yy.
```
- Tên sách: in nghiêng (`\textit{}`)

**Tác giả:**
- Viết tắt tên, giữ nguyên họ: `D. Ouyang, S. He, G. Zhang`
- Nhiều tác giả: phân cách bằng dấu phẩy

**Trích dẫn trong văn bản:**
- Dùng `\cite{key}` → hiển thị `[số]` trong ngoặc vuông
- KHÔNG hardcode `[1]`, `[2]` — luôn dùng `\cite{}`

### Các môi trường đặc biệt
- `\begin{preamble}{Tên mục}...\end{preamble}` — dùng cho Tóm tắt, Lời cam đoan, Lời cảm ơn
- `\begin{contentlisting}...\end{contentlisting}` — bao bọc `\tableofcontents`, `\listoffigures`, `\listoftables`
- `\begin{contentlistingsection}{Tên}...\end{contentlistingsection}` — mục riêng trong contentlisting (vd: Các từ viết tắt)
- `\makecovers` — tạo trang bìa từ các lệnh metadata đã khai báo

### Metadata trang bìa
```latex
\studentname{Họ tên}
\title{Tiêu đề}
\documenttype{Loại đồ án}
\major{Ngành}
\year{Năm}
\supervisor{TS. Họ tên}
% Tùy chọn:
\cosupervisor{...}          % nếu có đồng hướng dẫn
\englishtitle{...}          % nếu cần trang bìa tiếng Anh
\englishmajor{...}
\englishsupervisor{...}
```

## Tiến độ viết main.tex (Chương 3)

### Đã hoàn thành
- **3.2 Các toán tử cơ bản**: Bộ nhân (Booth + Wallace), Bộ chia (Goldschmidt), Bộ SQRT (Newton-Raphson), Bộ Exponential (exp_continuos: LUT + pipeline 4 chu kỳ), Bộ lặp (counter 3 tầng, ví dụ AvgPoolH)
- **3.3 Các bộ pooling**:
  - AvgPoolH/W: datapath (ảnh `AvgHW_datapath.png`) + FSM (ảnh `AvgPoolHW_controller.png`)
  - AvgPool (Global): datapath (ảnh `AvgPool_datapath.png`) + FSM (ảnh `AvgPool_controller.png`)

### Cần viết tiếp (theo thứ tự)
- **3.4 Các bộ tích chập**: Conv1x1, Conv3x3
- **3.5 Chuẩn hóa và kích hoạt**: GroupNorm, Sigmoid2D, Softmax
- **3.6 Tính toán attention**: ElemMul, Matmul, AddSigmoid, FinalAdd
- **3.7 Module EMA top-level**: EMA_datapath, EMA_controller

### Lưu ý quan trọng
- File VHDL nguồn nằm ở `D:\Soạn Quyển\`
- Ảnh minh họa nằm ở `Image/` trong project LaTeX
- Bộ Exp thực dùng là **exp_continuos.vhd** và **exp_softmax.vhd** (KHÔNG dùng Exp.vhd — file đó bị lỗi)
- Mỗi lần viết mục mới: đọc VHDL + xem ảnh trong `Image/` trước khi soạn
- Phong cách FSM: ngắn gọn như AvgPoolH/W (bullet, không dùng bảng)
- Phong cách Datapath: bullet theo từng khối chức năng (địa chỉ, tích lũy, chia...)

## Key Files
- ema_weights_layer2_q8_8.vhd — weight package (all layer2 blocks)
- bram_conv3x3_weight.vhd — BRAM ROM for conv3x3 weight (2304 x 16-bit)
- bram_conv3x3_bias.vhd — BRAM ROM for conv3x3 bias (16 x 16-bit)
- fmap_q8p8_16bit_4096.coe — input feature map (4096 x Q8.8)
- conv3x3_output.coe — expected conv3x3 output (4096 x Q8.8)
- conv3x3_output_hex.txt — debug output by [oc][oh][ow]
- conv3x3_compute.py — Python reference implementation
