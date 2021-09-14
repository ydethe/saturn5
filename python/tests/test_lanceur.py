import os
import sys
import unittest

import numpy as np
from numpy import cos, sin, pi
import scipy.linalg as lin
from blocksim.constants import mu, omega
from matplotlib import pyplot as plt

from saturn5.Stage import Stage
from saturn5.Lanceur import Lanceur
from saturn5.coordinate import latlong_to_ECEF, ECEF_to_latlong

sys.path.insert(0, os.path.dirname(__file__))
from TestBase import TestBase


class TestLanceur(TestBase):
    def test_lanceur(self):
        s1 = Stage()
        s1.num = 0
        s1.dry_mass = 177469.4
        s1.prop_mass = 2106424.9
        s1.isv = np.array([306.0, 306.0, 306.0, 305.0, 304.0])
        s1.flow_rate = np.array([13225.7, 13225.7, 13225.7, 13441.4, 10716.8])
        s1.flow_date = np.array([0.0, 30.0, 69.7, 134.9, 161.3])
        s1.ex_surface = np.array([53.8, 53.8, 53.8, 53.8, 53.8 * 4 / 5])

        # fig = plt.figure()
        # axe = fig.add_subplot(111)
        # axe.grid(True)
        # s1.plotFlowRate(axe)
        # plt.show()

        s2 = Stage()
        s2.num = 1
        s2.dry_mass = 44433.9
        s2.prop_mass = 443235.0
        s2.isv = np.array([0.0, 424.7, 424.7, 423.0, 427.0])
        s2.flow_rate = np.array([0.0, 1225.4, 1225.4, 980.4, 728.5])
        s2.flow_date = np.array([0.0, 2.4, 299.0, 349.2, 399.4])
        s2.ex_surface = np.array([17.3, 17.3, 17.3, 17.3, 17.3 * 4 / 5])

        s3 = Stage()
        s3.num = 2
        s3.dry_mass = 12023.8
        s3.prop_mass = 107095.4
        s3.isv = np.array([0.0, 430.5, 430.5])
        s3.flow_rate = np.array([0.0, 213.4, 213.4])
        s3.flow_date = np.array([0.0, 5.8, 158.6])
        s3.ex_surface = np.array([3.5, 3.5, 3.5])

        l = Lanceur()
        l.stages = [s1, s2, s3]
        l.Sref = 79.45997
        l.cu = 47632.2
        l.pos = latlong_to_ECEF(
            lat=pi / 180 * 28.60838889, lon=pi / 180 * (-80.64333333), alt=59
        )
        l.vel = np.zeros(3)
        l.active_stage = 0
        l.Mt = [0, 0.5, 1, 1.4, 2.5, 3.5, 5, 8.5]
        l.Ct = [0.3, 0.26, 0.4, 0.55, 0.35, 0.23, 0.2, 0.26]

        tps, X = l.run(0)
        n = len(tps)

        from matplotlib import pyplot as plt

        fig = plt.figure()
        axe = fig.add_subplot(111)
        axe.grid(True)
        axe.plot(
            tps,
            [l.analyseState(tps[k], X[:, k])["inci"] * 180 / pi for k in range(n)],
            label="py",
        )
        from matlab import T, alt, drag, pou, va

        iok = np.where(T <= 30)[0]
        # axe.plot(T[iok], alt[iok], label="matlab")
        axe.legend()
        plt.show()


if __name__ == "__main__":
    # unittest.main()

    a = TestLanceur()
    a.test_lanceur()
