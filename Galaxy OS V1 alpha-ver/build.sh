nasm -f bin Zboot.asm -o Zboot.bin
nasm -f bin kernel.asm -o kernel.bin
cat Zboot.bin kernel.bin > galaxy_os.img
