import os
import sys
import unittest

import numpy as np
from numpy import cos, sin, pi
import scipy.linalg as lin
from blocksim.constants import mu, omega

from saturn5.coordinate import (
    ECEF_to_latlong,
    ECEF_to_ENV,
    ENV_to_ECEF,
    latlong_to_ECEF,
    att_to_ECEF,
    ECEF_to_att,
)

sys.path.insert(0, os.path.dirname(__file__))
from TestBase import TestBase


class TestCoordinates(TestBase):
    def test_geodesic(self):
        pos = np.array([6845137.0, -816555.0, -44521.0])
        lat, lon, alt = ECEF_to_latlong(pos)
        pos2 = latlong_to_ECEF(lat, lon, alt)

        err = pos2 - pos
        self.assertAlmostEqual(err @ err, 0, delta=1e-3)

    def test_geodesic2(self):
        # http://walter.bislins.ch/bloge/index.asp?page=Rainy+Lake+Experiment%3A+WGS84+Calculator
        lat, lon, alt = (45.7689 * pi / 180, -4.99784 * pi / 180, 12)
        pos_ref = np.array([4439825.083, -388265.7048, 4547375.549])

        pos = latlong_to_ECEF(lat, lon, alt)

        err = pos - pos_ref
        self.assertAlmostEqual(err @ err, 0, delta=1e-3)

    def test_env(self):
        lla_orig = np.array((45.7689 * pi / 180, -4.99784 * pi / 180, 12))
        pos = np.array([4439825.083, -388265.7048, 4547375.549])

        pos_env = ECEF_to_ENV(pos, lla_orig)
        pos2 = ENV_to_ECEF(pos_env, lla_orig)

        err = pos2 - pos
        self.assertAlmostEqual(err @ err, 0, delta=1e-3)

    def test_att(self):
        lla_orig = np.array((45.7689 * pi / 180, -4.99784 * pi / 180, 12000))
        pitch = 30 * pi / 180
        yaw = 20 * pi / 180

        axe = att_to_ECEF(lla_orig, pitch, yaw)
        p2, y2 = ECEF_to_att(lla_orig, axe)

        self.assertAlmostEqual(p2, pitch, delta=1e-4)
        self.assertAlmostEqual(y2, yaw, delta=1e-4)


if __name__ == "__main__":
    a = TestCoordinates()
    a.test_geodesic()
    a.test_geodesic2()
    a.test_env()
    a.test_att()
