package planes with SPARK_mode
is

   -- General types
   type ReadyToFly is (READY);
   type NotReadyToFly is (NOTREADY);

   -- Door related
   type DoorSt is (OPENED, CLOSED, LOCKED);

   -- Plane flaps
   type Flaps is (ZERO, ONE, TWO, THREE, FULL);

   -- Plane spoilers
   type Spoiler is (NORMAL, ARMED);

   -- Plane Stage
   type PlaneDestination is (A,B,C);
   type PlaneSt is (PARKED, TAXI, TAKEOFF, FLYING, LANDING);
   type WarningLights is (GREEN, RED);
   type PlaneLife is (ALIVE, CRASHED);

   -- Plane Stage Altitude in Feet
   type Altitude is range 20..15000;

   -- Destinations in km
   type FromHubToA is range 0..100;
   type FromHubToB is range 0..150;
   type fromHubtoC is range 0..250;
   type fromHubToRunway is range 5..10;
   type Distan is range 0..300;
   type NearestDest is range 5..10;

   -- Start landing
   type StartLandingDistance is range 0..300;

   -- In kilometers
   type PlaneMinimumDistance is range 8..9;

   -- Passangers including pilot and crew
   type Passangers is range 2..602;

   -- 100 passangers fuil consumption per hundred km
   type PassangerFuilCosumption is range 3..4;

   -- Speed of the airplane is in knots
   type Speed is range 0..400;

   -- Plane Engine
   type EngineRunning is (ON, OFF);

   -- Plane Gear
   type Gear is (LOWERED, NOTLOWERED);

   -- Plane Fuil In Liters
   type FuilPerMile is range 1..5;
   type FuilTank is range 0..300000;

   type Door (DoorStt: DoorSt := OPENED) is record

      case DoorStt is

         when OPENED => Op: NotReadyToFly;
         when CLOSED => Cl: NotReadyToFly;
         when LOCKED => Dl: ReadyToFly;

      end case;
   end record;

   type PlanePosition (PlaneProgress: PlaneSt := PARKED) is record

      case PlaneProgress is

         when PARKED => Pk: NotReadyToFly;
         when TAXI => Tx: ReadyToFly;
         when TAKEOFF => Tk: ReadyToFly;
         when FLYING => Fg: ReadyToFly;
         when LANDING => Lg: ReadyToFly;

      end case;

   end record;

   type EngineFunc is record

      Fuil : FuilTank;
      EngineState: EngineRunning;

   end record;

   type Destination (Dest: PlaneDestination := A) is record

      case Dest is

         when A => DestA: FromHubToA;
         when B => DestB: FromHubToB;
         when C => DestC: fromHubtoC;

      end case;

   end record;

   type PLane is record

      PlaneDest : Destination;
      PlaneAlive: PlaneLife;
      DiatanceTraveled: Distan;
      Alt: Altitude;
      PlaneFlaps: Flaps;
      PlaneSpoilers: Spoiler;
      PlaneSpeed: Speed;
      PlanePassangers: Passangers;
      PlaneGear : Gear;
      WarningLight: WarningLights;
      PlaneStage: PlaneSt;
      DoorStatus: DoorSt;
      Engine: EngineFunc;

   end record;

   Aircraft : Plane := (PlaneDest => (Dest => B, DestB => FromHubToB'First),
                        PLaneAlive => ALIVE,
                        DiatanceTraveled => Distan'First,
                        Alt => Altitude'First,
                        PlaneFlaps => ZERO,
                        PlaneSpoilers => NORMAL,
                        PlaneSpeed => Speed'First,
                        PlanePassangers => Passangers'First,
                        PlaneGear => LOWERED,
                        WarningLight => GREEN,
                        PlaneStage => PARKED,
                        DoorStatus => OPENED,
                        Engine => (Fuil => FuilTank'First, EngineState => OFF));

   procedure CloseDoor with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.DoorStatus = OPENED and
               Aircraft.PlaneStage = PARKED),
     Post => (Aircraft.DoorStatus = CLOSED and Aircraft.PlaneStage = PARKED);

   procedure LockDoor with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.DoorStatus = CLOSED and Aircraft.PlaneStage = PARKED
             and Aircraft.Engine.EngineState = OFF),
     Post => (Aircraft.DoorStatus = LOCKED);

   procedure OpenDoor with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.DoorStatus = LOCKED and
               Aircraft.PlaneStage = PARKED and Aircraft.Engine.EngineState = OFF),
     Post => (Aircraft.DoorStatus = OPENED and Aircraft.PlaneStage = PARKED);

   procedure AddPassanger with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.DoorStatus = OPENED and Aircraft.Engine.EngineState = OFF
            and Aircraft.PlanePassangers > Passangers'Last),
     Post => Integer(Aircraft.PlanePassangers) <= Integer(Passangers'Last);

   procedure RemovePassanger with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.DoorStatus = OPENED and Aircraft.Engine.EngineState = OFF
             and Aircraft.PlanePassangers > Passangers'First),
     Post => (Aircraft.PlanePassangers >= Passangers'First
              and Aircraft.PlanePassangers <= Passangers'Last);

   procedure AddFuil with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = PARKED
            and Aircraft.Engine.Fuil < FuilTank'Last),
     Post => (Aircraft.Engine.EngineState = OFF);

   procedure PlanePushback with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = PARKED
            and Aircraft.DoorStatus = LOCKED and Aircraft.Engine.Fuil > 0),
     Post => (Aircraft.PlaneStage = TAXI);

   procedure ParkToGate with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.PlaneStage = TAXI and Aircraft.Engine.EngineState = ON
            and Aircraft.PlaneFlaps = ZERO and Aircraft.PlaneSpoilers = NORMAL),
     Post => (Aircraft.PlaneStage = PARKED and Aircraft.Engine.EngineState = OFF);

   procedure StartEngine with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = TAXI
            and Aircraft.DoorStatus = LOCKED and Aircraft.Engine.Fuil > 0),
     Post => (Aircraft.Engine.EngineState = ON);

   procedure TakeOff with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.EngineState = ON
             and Aircraft.DoorStatus = LOCKED and Aircraft.Engine.Fuil >= FuilTank'First)
             and Aircraft.Alt > Altitude'Last and Aircraft.PlaneStage = TAXI,
     Post => (Aircraft.PlaneStage = FLYING);

   procedure Cruising with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.PlaneStage = FLYING and Aircraft.Engine.Fuil > FuilTank'First
             and Aircraft.DiatanceTraveled > Distan'Last),
     Post => (Aircraft.DiatanceTraveled >= Distan'First and
             Aircraft.DiatanceTraveled <= Distan'Last);

   procedure Landing with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.Fuil > 0)
             and Aircraft.Alt > Altitude'Last and Aircraft.PlaneStage = LANDING and
             Aircraft.PlaneSpeed > Speed'First and
             Aircraft.DiatanceTraveled > Distan'First,
     Post => (Aircraft.PlaneStage = FLYING);

   procedure Crashed with
     Global => (In_Out => Aircraft),
     Depends => (Aircraft => Aircraft),
     Pre => (Aircraft.Engine.EngineState = ON and Aircraft.WarningLight = RED
            and Aircraft.PlaneAlive = CRASHED);

   -- Functions

   function CalcAmountOfFuil(dest: Destination) return FuilTank with
     Post => CalcAmountOfFuil'Result >= FuilTank'First;

   function CalcDistanceTravelled(dest: Destination) return Distan with
     Post => CalcDistanceTravelled'Result >= Distan'First;

end planes;
