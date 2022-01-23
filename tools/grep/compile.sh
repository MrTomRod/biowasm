cd src/

# Install dependencies
sudo apt-get install -y pkg-config autopoint
./bootstrap

# Nanosleep not supported in Emscripten
sed -i 's|if ${gl_cv_func_sleep_works+:} false|if true|g' configure
sed -i 's|if ${ac_cv_search_nanosleep+:} false|if true|g' configure
sed -i 's|if ${gl_cv_func_nanosleep+:} false|if true|g' configure

# Configure
emconfigure ./configure --disable-nls

# Run Makefile on each subfolder. Don't error on undefined _splice function that isn't used
emmake make all CC=emcc -k WERROR_CFLAGS="" CFLAGS="$EM_FLAGS -O2 -s ERROR_ON_UNDEFINED_SYMBOLS=0" EXEEXT=.js
mv src/grep.{js,wasm} ../build/
