# DockerTalker


1) docker built -t lab .
2) docker run -v  $(pwd):/host_dir talker --driven_audio /host_dir/goy.wav --source_image /host_dir/elon.png --result_dir /host_dir
3) Внутри докера python3 test.py --expected {run_date_time}/elon##goy.mp4 --result test/exp.mp4
