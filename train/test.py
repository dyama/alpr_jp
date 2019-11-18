# -*- coding: utf-8 -*-
import sys
import cv2

for path in sys.argv:
    if path == "test.py":
        continue

    print(path)

    img = cv2.imread(path)
    cascade = cv2.CascadeClassifier("./res/cascade.xml")

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    a = cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=3, minSize=(10, 10))

    for (x, y, w, h) in a:
        cv2.rectangle(img, (x, y), (x+w, y+h), (0, 0, 200), 3)

    cv2.imwrite("%s-result.jpg" % path,img)
    # cv2.imshow('image', img)
    # cv2.waitKey(0)

