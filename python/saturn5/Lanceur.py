import numpy as np
from numpy import sqrt, pi, arccos
from scipy.integrate import solve_ivp
from scipy import linalg as lin
from scipy.interpolate import interp1d

from .gravity import ECEF_acceleration
from .Stage import Stage
from .coordinate import latlong_to_ECEF, ECEF_to_latlong, att_to_ECEF
from .atmosphere import us76


class Lanceur(object):
    def __init__(self):
        self.stages = []
        self.Sref = 0.0
        self.cu = 0.0
        self.pos = np.zeros(3)
        self.vel = np.zeros(3)
        self.active_stage = 0
        self.Mt = [0.0, 0.0]
        self.Ct = [0.0, 0.0]

    @property
    def initial_state(self) -> np.array:
        X = np.empty(7)

        X[:3] = self.pos
        X[3:6] = self.vel

        m = self.cu
        for e in self.stages:
            m += e.dry_mass + e.prop_mass
        X[6] = m

        return X

    def getDragCoeff(self, M: float) -> float:
        return self._cd_itp(M)

    def analyseState(self, t_stage: float, X: np.array) -> dict:
        stage = self.stages[self.active_stage]

        pos = X[:3]
        vel = X[3:6]
        mass = X[6]

        # Geodesic coordinates
        lat, lon, alt = ECEF_to_latlong(pos)

        # US76 atmospherical pressure
        Patm = us76.getPressure(alt)
        rho = us76.getAirDensity(alt)
        cs = us76.getSoundCelerity(alt)

        # Gravity acceleration
        ag = ECEF_acceleration(X)

        # Thrust acceleration
        ut = stage.axePoussee(t_stage, pos, vel)
        thrust = stage.thrust(Patm, t_stage) * ut

        # Drag acceleration
        v2 = vel @ vel
        v = sqrt(v2)
        if v2 < 1e-3:
            ud = att_to_ECEF([lat, lon, alt], pitch=pi / 2, yaw=0)
        else:
            ud = vel / v

        pdyn = 0.5 * rho * v2
        if cs < 1e-3:
            M = 1000
        else:
            M = v / cs
        drag = -self.Sref * pdyn * ud * self.getDragCoeff(M)

        arg_cos = ud @ ut
        if arg_cos > 1:
            arg_cos = 1
        elif arg_cos < -1:
            arg_cos = -1
        inci = arccos(arg_cos)

        acc = ag + thrust / mass + drag / mass

        # Flow rate
        q = stage.getFlowRate(t_stage)

        data = {
            "t": t_stage,
            "ECEF_pos": pos,
            "ECEF_vel": vel,
            "v_air": v,
            "total_mass": mass,
            "lat": lat,
            "lon": lon,
            "alt": alt,
            "Patm": Patm,
            "rho": rho,
            "cs": cs,
            "ag": ag,
            "thrust": thrust,
            "drag": drag,
            "M": M,
            "pdyn": pdyn,
            "tot_acc": acc,
            "q": q,
            "inci": inci,
        }

        return data

    def state_derivative(self, t_stage: float, X: np.array) -> np.array:
        data = self.analyseState(t_stage, X)
        vel = data["ECEF_vel"]
        acc = data["tot_acc"]
        q = data["q"]

        dX = np.empty(7)

        dX[:3] = vel
        dX[3:6] = acc
        dX[6] = -q

        return dX

    def run(self, istage: int, dt: float = 0.1):
        self._cd_itp = interp1d(
            x=self.Mt,
            y=self.Ct,
            kind="linear",
            assume_sorted=True,
            bounds_error=False,
            fill_value=(0.0, 0.0),
        )

        X0 = self.initial_state

        Tsim = np.array([0.0], dtype=np.float64)
        Xsim = X0.copy().reshape((len(X0), 1))

        s = self.stages[istage]
        s.prepare()
        self.active_stage = istage

        n = len(s.flow_date)
        for k in range(n - 1):
            ti = s.flow_date[k]
            tf = s.flow_date[k + 1]
            print(s.num, k, n - 2, ti, tf)

            n_step = int((tf - ti) / dt)
            t_stage = np.arange(n_step) * dt + ti
            t_stage = np.hstack((t_stage, [tf]))
            res = solve_ivp(
                fun=self.state_derivative,
                t_span=(ti, tf),
                t_eval=t_stage,
                y0=X0,
                method="DOP853",
            )
            X0 = res.y[:, -1]

            Tsim = np.hstack((Tsim, res.t))
            Xsim = np.hstack((Xsim, res.y))

        return Tsim, Xsim
