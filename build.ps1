# --- CONFIGURATION ---
# 1. Path to your GCC Cross-Compiler
$GCC_BIN_PATH = "C:\Program Files (x86)\i686-elf-tools-windows\"

# 2. Path to your QEMU installation (Usually C:\Program Files\qemu\)
$QEMU_PATH = "C:\Program Files\qemu\"

# Tools
$AS = "nasm"
$CC = "${GCC_BIN_PATH}i686-elf-gcc.exe"
$LD = "${GCC_BIN_PATH}i686-elf-ld.exe"
$QEMU = "${QEMU_PATH}qemu-system-i386.exe"
$OUT_BIN = "./build/myos.bin"

# 1. Clean up
Write-Host "--- Step 1: Cleaning old files ---" -ForegroundColor Cyan
if (Test-Path *.o) { Remove-Item *.o }
if (Test-Path $OUT_BIN) { Remove-Item $OUT_BIN }

# 2. Assemble (NASM)
Write-Host "--- Step 2: Assembling boot.s ---" -ForegroundColor Cyan
& $AS -f elf32 ./src/boot.s -o ./build/boot.o
if ($LASTEXITCODE -ne 0) { Write-Host "NASM Failed!"; exit }

# 3. Compile (GCC)
Write-Host "--- Step 3: Compiling kernel.c ---" -ForegroundColor Cyan
& $CC -c src/kernel.c -o ./build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra `
  -fno-asynchronous-unwind-tables -fno-pic "-B$GCC_BIN_PATH"
if ($LASTEXITCODE -ne 0) { Write-Host "C Compilation Failed!"; exit }

# 4. Link (Direct Linker)
Write-Host "--- Step 4: Linking myos.bin ---" -ForegroundColor Cyan
& $LD -T src/linker.ld -o $OUT_BIN ./build/boot.o ./build/kernel.o
if ($LASTEXITCODE -ne 0) { Write-Host "Linking Failed!"; exit }

Write-Host "`nBuild Successful! HydrogenOS is ready." -ForegroundColor Green

# 5. Run
Write-Host "--- Step 5: Launching QEMU ---" -ForegroundColor Yellow
# If your QEMU is installed somewhere else, update $QEMU_PATH at the top.
& $QEMU -kernel $OUT_BIN