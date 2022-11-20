cd c
sh ./run.sh
cd ../python
python3 raylib-test.py
cd ../zig
zig build
./zig-out/bin/tiles
cd ..