with planes; use planes;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Str : String(1..2);
   Last : Natural;
   task Start;
   task Crash is
      pragma Priority(10);
   end Crash;

   task body Start is
   begin

      Put_Line("Flight Key Info: ");
      Put_Line(Aircraft.PlaneStage'Image);
      Put_Line("Destination: ");
      Put_Line(Aircraft.PlaneDest.Dest'Image);
      Put_Line("");

      loop

         Put_Line("Enter the first step:");
         Get_Line(Str, Last);
         Put_Line("");

         case Str(1) is

            when '1' => AddPassanger;
               Put_Line("Passangers: ");
               Put_Line(Aircraft.PlanePassangers'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '2' => RemovePassanger;
               Put_Line("Passangers: ");
               Put_Line(Aircraft.PlanePassangers'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '3' => OpenDoor;
               Put_Line("Door: ");
               Put_Line(Aircraft.DoorStatus'Image);
               Put_Line("Airplane:");
               Put_Line(Aircraft.PlaneStage'Image);
               Put_Line("Engine ON/OFF: ");
               Put_Line(Aircraft.Engine.EngineState'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '4' => CloseDoor;
               Put_Line("Door: ");
               Put_Line(Aircraft.DoorStatus'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '5' => LockDoor;
               Put_Line("Door: ");
               Put_Line(Aircraft.DoorStatus'Image);
               Put_Line("Airplane:");
               Put_Line(Aircraft.PlaneStage'Image);
               Put_Line("Engine ON/OFF: ");
               Put_Line(Aircraft.Engine.EngineState'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '6' => AddFuil;
               Put_Line("Amount Fuil: ");
               Put_Line(Aircraft.Engine.Fuil'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '7' => PlanePushback;
               Put_Line("Pushback In-Progress");
               Put_Line(Aircraft.PlaneStage'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '8' => StartEngine;
               Put_Line("Amount Fuil: ");
               Put_Line(Aircraft.Engine.Fuil'Image);
               Put_Line("Engine ON/OFF: ");
               Put_Line(Aircraft.Engine.EngineState'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '9' => ParkToGate;
               Put_Line("Engine ON/OFF: ");
               Put_Line(Aircraft.Engine.EngineState'Image);
               Put_Line("Airplane Status: ");
               Put_Line(Aircraft.PlaneStage'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '0' => Cruising;
               Put_Line("Amount Fuil: ");
               Put_Line(Aircraft.Engine.Fuil'Image);
               Put_Line("Amount Travelled: ");
               Put_Line(Aircraft.DiatanceTraveled'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '+' => TakeOff;
               Put_Line("Altitude: ");
               Put_Line(Aircraft.Alt'Image);
               Put_Line("Gear: ");
               Put_Line(Aircraft.PlaneGear'Image);
               Put_Line("Amount Fuil: ");
               Put_Line(Aircraft.Engine.Fuil'Image);
               Put_Line("Speed: ");
               Put_Line(Aircraft.PlaneSpeed'Image);
               Put_Line("Amount Travelled: ");
               Put_Line(Aircraft.DiatanceTraveled'Image);
               Put_Line("Airplane Flaps: ");
               Put_Line(Aircraft.PlaneFlaps'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when '-' => Landing;
               Put_Line("Altitude: ");
               Put_Line(Aircraft.Alt'Image);
               Put_Line("Gear: ");
               Put_Line(Aircraft.PlaneGear'Image);
               Put_Line("Amount Fuil: ");
               Put_Line(Aircraft.Engine.Fuil'Image);
               Put_Line("Amount Travelled: ");
               Put_Line(Aircraft.DiatanceTraveled'Image);
               Put_Line("Airplane Status: ");
               Put_Line(Aircraft.PlaneStage'Image);
               Put_Line("Warning Lights: ");
               Put_Line(Aircraft.WarningLight'Image);
               Put_Line("");

            when others => abort Crash; exit;

         end case;

      end loop;

   end Start;

   task body Crash is
   begin
      loop
         Crashed;
         delay 0.5;
      end loop;
   end Crash;

begin
   null;
end Main;
