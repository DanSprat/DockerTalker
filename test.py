from argparse import ArgumentParser
import cv2

def compare_videos(video1_path, video2_path, pixel_threshold=0.9):
    video1 = cv2.VideoCapture(video1_path)
    video2 = cv2.VideoCapture(video2_path)

    while True:
        ret1, frame1 = video1.read()
        ret2, frame2 = video2.read()

        if not ret1 or not ret2:
            break

        # Проверка совпадения пикселей
        diff = cv2.absdiff(frame1, frame2)
        diff_percent = (diff.sum() / (frame1.shape[0] * frame1.shape[1] * frame1.shape[2])) / 255.0

        if diff_percent > 1 - pixel_threshold:
            print("Видео отличаются!")
            return

    print("Видео идентичны!")


parser = ArgumentParser()

parser.add_argument("--expected", help="path to driven audio")
parser.add_argument("--result", help="path to source image")

args = parser.parse_args()

result = args.result
expected = args.expected

compare_videos(result, expected, pixel_threshold=0.9)