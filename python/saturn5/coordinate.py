from typing import Tuple

from scipy import linalg as lin
import numpy as np
from numpy import sqrt, cos, sin, pi, arctan2, arctan, arcsin, abs
from blocksim.constants import *


def latlong_to_ECEF(lat: float, lon: float, alt: float) -> np.array:
    e = sqrt(1 - Rpo ** 2 / Req ** 2)
    N = Req / sqrt(1 - e ** 2 * sin(lat) ** 2)
    x = (N + alt) * cos(lat) * cos(lon)
    y = (N + alt) * cos(lat) * sin(lon)
    z = (N * (1 - e ** 2) + alt) * sin(lat)
    pos = np.array([x, y, z])
    return pos


def Iter_phi_h(x: float, y: float, z: float, eps: float = 1e-6) -> Tuple[float, float]:
    r = lin.norm((x, y, z))
    p = sqrt(x ** 2 + y ** 2)

    N = Req
    hg = r - sqrt(Req - Rpo)
    e = sqrt(1 - Rpo ** 2 / Req ** 2)
    phig = arctan(z * (N + hg) / (p * (N * (1 - e ** 2) + hg)))

    cont = True
    while cont:
        hgp = hg
        phigp = phig

        N = Req / sqrt(1 - e ** 2 * sin(phigp) ** 2)
        hg = p / cos(phigp) - N
        phig = arctan(z * (N + hg) / (p * (N * (1 - e ** 2) + hg)))

        if eps > max(abs(phigp - phig), abs(hgp - hg)):
            cont = False

    return phig, hgp


def ECEF_to_latlong(position: np.array) -> Tuple[float, float, float]:
    # Conversion des coordonnées dans REQ aux latitudes / longitudes.

    x = position[0]
    y = position[1]
    z = position[2]
    p = sqrt(x ** 2 + y ** 2)
    cl = x / p  # cos(lambda)
    sl = y / p  # sin(lambda)
    lon = arctan2(sl, cl)
    lat, alt = Iter_phi_h(x, y, z)

    return lat, lon, alt


def ENV_matrix(lla_orig: np.array) -> np.array:
    lat, lon, alt = lla_orig
    u_v = np.array([cos(lon) * cos(lat), sin(lon) * cos(lat), sin(lat)])
    u_e = np.cross(np.array([0, 0, 1]), u_v)
    u_e /= lin.norm(u_e)
    u_n = np.cross(u_v, u_e)

    mat = np.transpose(np.vstack((u_e, u_n, u_v)))

    return mat


def ECEF_to_ENV(position: np.array, lla_orig: np.array) -> np.array:
    mat = ENV_matrix(lla_orig)

    lat, lon, alt = lla_orig
    ecef_orig = latlong_to_ECEF(lat, lon, alt)

    return mat.T @ (position - ecef_orig)


def ENV_to_ECEF(position: np.array, lla_orig: np.array) -> np.array:
    mat = ENV_matrix(lla_orig)

    lat, lon, alt = lla_orig
    ecef_orig = latlong_to_ECEF(lat, lon, alt)

    return ecef_orig + mat @ position


def att_to_ECEF(lla_orig: np.array, pitch: float, yaw: float) -> np.array:
    axe_env = np.array([sin(yaw) * cos(pitch), cos(yaw) * cos(pitch), sin(pitch)])

    mat = ENV_matrix(lla_orig)
    axe_ecef = mat @ axe_env

    return axe_ecef


def ECEF_to_att(lla_orig: np.array, axe: np.array) -> Tuple[float, float]:
    mat = ENV_matrix(lla_orig)
    axe_env = mat.T @ axe

    pitch = arcsin(axe_env[2])
    yaw = arctan2(axe_env[0], axe_env[1])

    return pitch, yaw
