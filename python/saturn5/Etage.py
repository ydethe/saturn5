from scipy.interpolate import interp1d


class Etage(object):
    def __init__(self):
        self.num = 0
        self.dry_mass = 0.0
        self.prop_mass = 0.0
        self.isv = 0.0
        self.flow_rate = [0.0]
        self.flow_date = [0.0]
        self.ex_surface = [0.0]

        self._flow_itp = interp1d(
            x=self.flow_date, y=self.flow_rate, kind="linear", assume_sorted=True
        )
        self._isv_itp = interp1d(
            x=self.flow_date, y=self.isv, kind="linear", assume_sorted=True
        )
        self._ex_surface_itp = interp1d(
            x=self.flow_date, y=self.ex_surface, kind="linear", assume_sorted=True
        )

        _chck = 0.0
        n = len(self.flow_date)
        for k in range(n - 1):
            a = self.flow_rate[k]
            b = self.flow_rate[k + 1]
            dt = self.flow_date[k + 1] - self.flow_date[k]
            _chck += dt / 2 * (a + b)

        assert _chck <= self.prop_mass

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
