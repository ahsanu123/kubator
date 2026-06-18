# install globally 
#   xpm install @xpack-dev-tools/arm-none-eabi-gcc@15.2.1-1.1.1 -g
# then use it locally 
#   cd <to-your-project>
#   xpm install @xpack-dev-tools/arm-none-eabi-gcc@15.2.1-1.1.1

# install toolchain 
it: 
  xpm install @xpack-dev-tools/arm-none-eabi-gcc@15.2.1-1.1.1 -g
  xpm install @xpack-dev-tools/arm-none-eabi-gcc@15.2.1-1.1.1 

# prepare
p: 
  cmake -S . -B build

# build 
b: 
  cmake --build build

# build verbose
bv: 
  cmake --build build --verbose
