package body planes with SPARK_Mode
is

   -- Closes Door
   procedure CloseDoor is
   begin
      if (Aircraft.DoorStatus = OPENED) then
         Aircraft.DoorStatus := CLOSED;
   end if;
   end CloseDoor;

   -- Locks door
   procedure LockDoor is
   begin
      if (Aircraft.DoorStatus = CLOSED and Aircraft.PlaneStage = PARKED) then
         Aircraft.DoorStatus := LOCKED;
   end if;
   end LockDoor;

   -- Opens Door
   procedure OpenDoor is
   begin
      if (Aircraft.DoorStatus = LOCKED and Aircraft.PlaneStage = PARKED
         and Aircraft.Engine.EngineState = OFF) then
         Aircraft.DoorStatus := OPENED;
   end if;
   end OpenDoor;

   -- Add Passanger in hundreds
   procedure AddPassanger is
   begin
      if Aircraft.DoorStatus = OPENED and Aircraft.Engine.EngineState = OFF and
      Aircraft.PlanePassangers <= Passangers'Last then
         Aircraft.PlanePassangers := Aircraft.PlanePassangers + 100;
      end if;

   end AddPassanger;

   -- Remove passanger in hundreds
   procedure RemovePassanger is
   begin
      if Aircraft.DoorStatus = OPENED and Aircraft.Engine.EngineState = OFF and
      Aircraft.PlanePassangers >= Passangers'First then
         Aircraft.PlanePassangers := 2;
      elsif Aircraft.PlanePassangers <= Passangers'Last then
         Aircraft.PlanePassangers := Aircraft.PlanePassangers - 100;
      end if;
   end RemovePassanger;

   -- Add Fuil
   procedure AddFuil is
   begin
      if Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = PARKED and
      Aircraft.Engine.Fuil < FuilTank'Last then
         Aircraft.Engine.Fuil := CalcAmountOfFuil(Aircraft.PlaneDest);
      end if;
   end AddFuil;

   -- Plane Pushback
   procedure PlanePushback is
   begin
      if Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = PARKED
        and Aircraft.DoorStatus = LOCKED
        and Aircraft.Engine.Fuil > 0 then
         Aircraft.PlaneStage := TAXI;
      end if;
   end PlanePushback;

   -- Park to gate
   procedure ParkToGate is
   begin
      if Aircraft.Engine.EngineState = ON and Aircraft.PlaneStage = TAXI
        and Aircraft.PlaneFlaps = ZERO and Aircraft.PlaneSpoilers = NORMAL then
         Aircraft.PlaneStage := PARKED;
         Aircraft.Engine.EngineState := OFF;
      end if;
   end ParkToGate;

   -- Start Engine
   procedure StartEngine is
   begin
      if Aircraft.Engine.EngineState = OFF and Aircraft.PlaneStage = TAXI
        and Aircraft.DoorStatus = LOCKED
        and Aircraft.Engine.Fuil > 0 then
         Aircraft.Engine.EngineState := ON;
      end if;
   end StartEngine;

   -- Take off
   procedure TakeOff is
   begin
      if Aircraft.Engine.EngineState = ON
        and Aircraft.DoorStatus = LOCKED
        and Aircraft.Engine.Fuil > 0
        and Aircraft.Alt >= Altitude'First then
         Aircraft.PlaneStage := TAKEOFF;
         Aircraft.PlaneSpeed := Aircraft.PlaneSpeed + 100;

         if Aircraft.PlaneSpeed >= 300 then
            Aircraft.PlaneSpeed := 300;
         end if;

         if Aircraft.Engine.Fuil <= 1050 then
            Aircraft.WarningLight := RED;
            Aircraft.PlaneStage := LANDING;
         end if;

         if Aircraft.Alt >= 20 then
            Aircraft.Alt := Aircraft.Alt + 1000;
            Aircraft.PlaneFlaps := ONE;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 300;
         end if;

         if Aircraft.Alt >= 2020 then
            Aircraft.PlaneGear := NOTLOWERED;
            Aircraft.Alt := Aircraft.Alt + 3000;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 450;
         end if;

         if Aircraft.Alt >= 5020 then
            Aircraft.Alt := Aircraft.Alt + 9000;
            Aircraft.PlaneFlaps := ZERO;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil
              - 1350;
         end if;

         if Aircraft.Alt >= 14020 then
            Aircraft.PlaneStage := FLYING;
         end if;
      end if;
   end TakeOff;

   -- Plane Flying
   procedure Cruising is
   begin
      if Aircraft.PlaneStage = FLYING then
         Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
           + CalcDistanceTravelled(Aircraft.PlaneDest);

         if Aircraft.Engine.Fuil > 1050 then
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 100;
         end if;

         if (Aircraft.PlaneDest.Dest = A) then
            if (Aircraft.DiatanceTraveled >= 50) then
               Aircraft.PlaneStage := LANDING;
            end if;
         end if;

         if (Aircraft.PlaneDest.Dest = B) then
            if (Aircraft.DiatanceTraveled >= 75) then
               Aircraft.PlaneStage := LANDING;
            end if;
         end if;

         if (Aircraft.PlaneDest.Dest = C) then
            if (Aircraft.DiatanceTraveled >= 125) then
               Aircraft.PlaneStage := LANDING;
            end if;
         end if;

         if Aircraft.Engine.Fuil <= 1050 then
            Aircraft.WarningLight := RED;
            Aircraft.PlaneStage := LANDING;
         end if;

         if Aircraft.Engine.Fuil <= FuilTank'First then
            Aircraft.PlaneAlive := CRASHED;
         end if;
      end if;
   end Cruising;

   -- Plane landing
   procedure Landing is
   begin
      if Aircraft.Engine.EngineState = ON
        and Aircraft.DoorStatus = LOCKED
        and Aircraft.Engine.Fuil > 0 then
         Aircraft.PlaneStage := LANDING;
         Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 150;
         Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
           + CalcDistanceTravelled(Aircraft.PlaneDest);
         Aircraft.Alt := Aircraft.Alt - 10000;

         if Aircraft.Engine.Fuil <= 1050 then
            Aircraft.WarningLight := RED;
         end if;

         if Aircraft.Engine.Fuil = 0 and Aircraft.Alt > 0 then
            Aircraft.PlaneAlive := CRASHED;
         end if;

         if Aircraft.PlaneAlive = CRASHED then
            Aircraft.PlaneSpeed := 0;
            Aircraft.Engine.Fuil := 0;
         end if;

         if Aircraft.Alt <= 4020 then
            Aircraft.PlaneFlaps := ONE;
            Aircraft.Alt := Aircraft.Alt - 1000;
            Aircraft.PlaneSpeed := Aircraft.PlaneSpeed - 50;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 150;
         end if;

         if Aircraft.Alt <= 3020 then
            Aircraft.PlaneFlaps := TWO;
            Aircraft.Alt := Aircraft.Alt - 1000;
            Aircraft.PlaneSpeed := Aircraft.PlaneSpeed - 50;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 150;
         end if;

         if Aircraft.Alt <= 2020 then
            Aircraft.PlaneGear := LOWERED;
            Aircraft.PlaneFlaps := THREE;
            Aircraft.Alt := Aircraft.Alt - 1000;
            Aircraft.PlaneSpeed := Aircraft.PlaneSpeed - 50;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 150;
         end if;

         if Aircraft.Alt <= 1020 then
            Aircraft.PlaneFlaps := FULL;
            Aircraft.Alt := Aircraft.Alt - 1000;
            Aircraft.PlaneSpoilers := ARMED;
            Aircraft.PlaneSpeed := 150;
            Aircraft.DiatanceTraveled := Aircraft.DiatanceTraveled
              + CalcDistanceTravelled(Aircraft.PlaneDest);
            Aircraft.Engine.Fuil := Aircraft.Engine.Fuil - 150;
         end if;

         if Aircraft.Alt <= 20 then
            Aircraft.PlaneStage := TAXI;
            Aircraft.PlaneSpoilers := NORMAL;
            Aircraft.PlaneFlaps := ZERO;
            Aircraft.PlaneSpeed := 20;
         end if;
      end if;
   end Landing;

   -- Plane crashed
   procedure Crashed is
   begin
      if Aircraft.Alt = Altitude'First and Aircraft.WarningLight = RED and
         Aircraft.Engine.EngineState = ON then
         Aircraft.Engine.EngineState := OFF;
         Aircraft.PlaneSpeed := Speed'First;
      end if;
   end Crashed;

   -- Functions

   -- Calc amount of fuil
   function CalcAmountOfFuil(dest: Destination) return FuilTank is
      Fuil: FuilTank;
   begin
      if dest.Dest = A and FromHubToA'First > 0 then
         Fuil := FuilTank(Integer(FuilTank'First) + (Integer(PassangerFuilCosumption'Last) *
                          Integer(Aircraft.PlanePassangers))
                          + (Integer(FromHubToA'Last) + Integer(fromHubToRunway'Last)) * 12);
      elsif dest.Dest = B and FromHubToB'First > 0 then
         Fuil := FuilTank(Integer(FuilTank'First) + (Integer(PassangerFuilCosumption'Last) *
                          Integer(Aircraft.PlanePassangers)) +
                          (Integer(FromHubToB'Last) + Integer(fromHubToRunway'Last)) * 12);
      else
         Fuil := FuilTank(Integer(FuilTank'First) + (Integer(PassangerFuilCosumption'Last) *
                          Integer(Aircraft.PlanePassangers)) +
                          (Integer(fromHubtoC'Last) + Integer(fromHubToRunway'Last)) * 12);
      end if;

      return Fuil;

   end CalcAmountOfFuil;

   -- Calc destination travelled
   function CalcDistanceTravelled(dest: Destination) return Distan is
      Distance: Distan;
   begin
      if dest.Dest = A and FromHubToA'First > 0 then
         Distance := Distan(Integer(Distan'First) + Integer(FromHubToA'Last) / 16);
      elsif dest.Dest = B and FromHubToB'First > 0 then
         Distance := Distan(Integer(Distan'First) + Integer(FromHubToB'Last) / 16);
      else
         Distance := Distan(Integer(Distan'First) + Integer(FromHubToC'Last) / 16);
      end if;

      return Distance;

   end CalcDistanceTravelled;

end planes;
