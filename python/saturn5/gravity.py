import numpy as np
from scipy import linalg as lin
from numpy import sin, cos, exp, pi, sqrt
from blocksim.constants import c, Req, mu, J2, omega


def ECEF_acceleration(pv: np.array) -> np.array:
    """
    For a state vector in ECEF frame, returns gravity, including J2

    Args:
      pv
        Array with x, y, z, vx, vy, vz (m and m/s) in ECEF frame

    Returns:
      Gravity vector in the same frame

    """
    px = pv[0]
    py = pv[1]
    pz = pv[2]
    vx = pv[3]
    vy = pv[4]
    # vz = pv[5]

    r2 = px ** 2 + py ** 2 + pz ** 2
    r = sqrt(r2)
    r3 = r ** 3

    gx = -mu * px / r3 * (1 + 3 / 2 * J2 * (Req / r) ** 2 * (1 - 5 * (pz / r) ** 2))
    gy = -mu * py / r3 * (1 + 3 / 2 * J2 * (Req / r) ** 2 * (1 - 5 * (pz / r) ** 2))
    gz = -mu * pz / r3 * (1 + 3 / 2 * J2 * (Req / r) ** 2 * (3 - 5 * (pz / r) ** 2))

    # Accélération d'entrainement
    gx -= px * omega ** 2
    gy -= py * omega ** 2

    # Accélératon de Coriolis
    gx -= -2 * vy * omega
    gy -= 2 * vx * omega

    g = np.array([gx, gy, gz])

    return g
