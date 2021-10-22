import numpy as np
from scipy.interpolate import interp1d
from pattern_singleton import Singleton


class Atmosphere(metaclass=Singleton):
    def __init__(self, file: str):
        f = open(file, "r")
        lines = f.readlines()
        f.close()

        self.R = 286.8965  # J/kg/K
        self.gamma = 1.4

        n = len(lines) - 11
        self._alt = np.empty(n)
        self._rho = np.empty(n)
        self._cson = np.empty(n)
        for k, l in enumerate(lines[11:]):
            buf = l.strip()
            while "  " in buf:
                buf = buf.replace("  ", " ")
            elem = buf.split(" ")
            alt, rho, cson = [float(x) for x in elem]

            self._alt[k] = alt
            self._rho[k] = rho
            self._cson[k] = cson

        self._itp_rho = interp1d(
            x=self._alt,
            y=self._rho,
            kind="linear",
            assume_sorted=True,
            bounds_error=False,
            fill_value=(0.0, 0.0),
        )

        self._itp_cson = interp1d(
            x=self._alt,
            y=self._cson,
            kind="linear",
            assume_sorted=True,
            bounds_error=False,
            fill_value=(0.0, 0.0),
        )

    def getSoundCelerity(self, alt: float) -> float:
        return self._itp_cson(alt)

    def getAirDensity(self, alt: float) -> float:
        return self._itp_rho(alt)

    def getPressure(self, alt: float) -> float:
        v = self.getSoundCelerity(alt)
        r = self.getAirDensity(alt)
        Patm = v ** 2 / self.gamma * r

        return Patm


us76 = Atmosphere("../share/Atmosphere_us76.txt")
