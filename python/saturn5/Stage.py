import numpy as np
from numpy import pi
from scipy.interpolate import interp1d

from .coordinate import ENV_matrix, ECEF_to_latlong, att_to_ECEF


class Stage(object):
    def __init__(self):
        self.num = 0
        self.dry_mass = 0.0
        self.prop_mass = 0.0
        self.isv = [0.0, 0.0]
        self.flow_rate = [0.0, 0.0]
        self.flow_date = [0.0, 0.0]
        self.ex_surface = [0.0, 0.0]

    def plotFlowRate(self, axe, nb_pts=100):
        self.prepare()
        tps = np.linspace(0.0, self.getTotalBurnTime(), nb_pts)
        q = self.getFlowRate(tps)
        axe.plot(tps, q)

    def prepare(self):
        self._flow_itp = interp1d(
            x=self.flow_date, y=self.flow_rate, kind="nearest", assume_sorted=True
        )
        self._isv_itp = interp1d(
            x=self.flow_date, y=self.isv, kind="nearest", assume_sorted=True
        )
        self._ex_surface_itp = interp1d(
            x=self.flow_date, y=self.ex_surface, kind="nearest", assume_sorted=True
        )

        _chck = 0.0
        n = len(self.flow_date)
        for k in range(n - 1):
            a = self.flow_rate[k]
            b = self.flow_rate[k + 1]
            dt = self.flow_date[k + 1] - self.flow_date[k]
            _chck += dt / 2 * (a + b)

        # assert _chck <= self.prop_mass

    def getFlowRate(self, t: float) -> float:
        q = self._flow_itp(t)
        return q

    def getISV(self, t: float) -> float:
        isv = self._isv_itp(t)
        return isv

    def getExhaustSurface(self, t: float) -> float:
        Ss = self._ex_surface_itp(t)
        return Ss

    def thrust(self, Patm: float, t: float) -> float:
        q = self.getFlowRate(t)
        isv = self.getISV(t)
        Ss = self.getExhaustSurface(t)
        g0 = 9.81
        th = q * isv * g0 - Ss * Patm

        return th

    def getTotalBurnTime(self) -> float:
        return self.flow_date[-1]

    def axePoussee(self, t_stage: float, pos: np.array, vel: np.array) -> np.array:
        lla_orig = ECEF_to_latlong(pos)

        _p_itp = interp1d(
            [0, 30, 80, 135, 165, 185, 320, 460, 480, 550, 570, 640, 705, 100000],
            [
                0,
                0,
                36.4,
                62.23,
                71.14,
                60.57,
                64.75,
                77.35,
                74.59,
                81.39,
                77.25,
                85.07,
                88.23,
                88.23,
            ],
            kind="linear",
            assume_sorted=True,
        )
        pitch = pi / 2 - _p_itp(t_stage) * pi / 180
        yaw = 72.058 * pi / 180

        axe_ecef = att_to_ECEF(lla_orig, pitch=pitch, yaw=yaw)
        return axe_ecef
