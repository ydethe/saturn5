import os
import sys
import unittest

import numpy as np
from numpy import cos, sin, pi
import scipy.linalg as lin
from blocksim.constants import mu, omega

from saturn5.gravity import ECEF_acceleration

sys.path.insert(0, os.path.dirname(__file__))
from TestBase import TestBase


class TestGravity(TestBase):
    def test_geostationary(self):
        r_geo = (mu / omega ** 2) ** (1 / 3)
        v_geo = (mu * omega) ** (1 / 3)

        theta = 1
        pv = np.array(
            [
                r_geo * cos(theta),
                r_geo * sin(theta),
                0,
                -v_geo * sin(theta),
                v_geo * cos(theta),
                0,
            ]
        )

        g = ECEF_acceleration(pv)

        n = lin.norm(g)

        self.assertAlmostEqual(n, 0, delta=1e-4)


if __name__ == "__main__":
    unittest.main()

    a = TestGravity()
    a.test_geostationary()
