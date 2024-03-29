within UseCases.AixLibUseCases;
model UseCase1_1

  inner AixLib.HVAC.BaseParameters baseParameters(
    mu_Water=4.7729e-4,
    rho_Water=983.83,
    cp_Water=4182.7,
    lambda_Water=0.65297)
    annotation (Placement(transformation(extent={{-98,74},{-78,94}})));
  AixLib.Building.LowOrder.ThermalZone thermalZone(zoneParam=
        UseCases.Utilities.AixLib.VDI6007HeavyWeight())
    annotation (Placement(transformation(extent={{18,34},{52,68}})));
  AixLib.Building.Components.Weather.Weather weather(
    Outopt=1,
    Air_temp=true,
    Sky_rad=true,
    Ter_rad=true,
    SOD=UseCases.Utilities.AixLib.South(),
    fileName="./Resources/TRY_5_Essen.txt")
    annotation (Placement(transformation(extent={{-48,68},{-10,94}})));
  Modelica.Blocks.Sources.Constant infiltrationRate(k=0)
    annotation (Placement(transformation(extent={{0,21},{10,32}})));
  Modelica.Blocks.Sources.CombiTimeTable internalLoads(
    tableOnFile=true,
    tableName="InnerLoads",
    columns={2,3,4},
    fileName="./Resources/InnerLoads.txt")
    annotation (Placement(transformation(extent={{94,16},{74,36}})));
  AixLib.Fluid.Movers.Pump
                         pump(Head_max=3.9688,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    Head(start=3.9688),
    m_flow_small=0)
    annotation (Placement(transformation(extent={{-72,-48},{-52,-28}})));

  AixLib.Fluid.Actuators.Valves.SimpleValve
                                 valve(                Kvs=1.3391,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_small=0,
    dp(start=100))
    annotation (Placement(transformation(extent={{14,-48},{34,-28}})));

  AixLib.Fluid.HeatExchangers.Boiler boiler(
                                           Q_flow_max=1589.1, Volume=0.0045469,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}})));

  AixLib.Fluid.FixedResistances.StaticPipe
                               flowPipe(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_small=0,
    dp(start=100))
    annotation (Placement(transformation(extent={{-14,-48},{6,-28}})));

  AixLib.Fluid.HeatExchangers.Radiators.Radiator
                                 radiator(RadiatorType=
        AixLib.DataBase.Radiators.ThermX2_ProfilV_979W(
          NominalPower=885.94,
          T_flow_nom=56.719,
          T_return_nom=53.984,
          T_room_nom=18.601,
          Exponent=1.2273,
          VolumeWater=8.3906,
          RadPercent=0.39922),
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{41,-48},{61,-28}})));

  AixLib.Fluid.FixedResistances.StaticPipe
                               returnPipe(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_small=0,
    dp(start=100))                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={66,-54})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-24,-24},{-12,-12}})));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=0.19688)
            annotation (Placement(transformation(extent={{-6,-4},{6,8}})));
  Modelica.Blocks.Sources.Constant setTemp(k=296.46)
    annotation (Placement(transformation(extent={{-24,-4},{-12,8}})));
  Modelica.Blocks.Sources.BooleanPulse nightSignal(
    width=45.8,
    period=86400,
    startTime=64800)
    annotation (Placement(transformation(extent={{-96,-19},{-82,-5}})));
  Modelica.Blocks.Sources.Constant flowTemp(k=331.82)
    annotation (Placement(transformation(extent={{-62,-18},{-50,-6}})));
  AixLib.Fluid.Sources.FixedBoundary
                                 expansionVessel(nPorts=1, redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater)
                                                 annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-82,-84})));
equation

  connect(weather.WeatherDataVector, thermalZone.weather) annotation (Line(
      points={{-29.1267,66.7},{-29.1267,51},{22.42,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weather.SolarRadiation_OrientedSurfaces, thermalZone.solarRad_in)
    annotation (Line(
      points={{-38.88,66.7},{-38.88,61.2},{21.4,61.2}},
      color={255,128,0},
      smooth=Smooth.None));
  connect(infiltrationRate.y, thermalZone.infiltrationRate) annotation (Line(
      points={{10.5,26.5},{28.2,26.5},{28.2,36.04}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(internalLoads.y, thermalZone.internalGains) annotation (Line(
      points={{73,26},{48.6,26},{48.6,36.04}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, boiler.port_a) annotation (Line(
      points={{-52,-38},{-40,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boiler.port_b, flowPipe.port_a) annotation (Line(
      points={{-20,-38},{-14,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valve.port_a, flowPipe.port_b) annotation (Line(
      points={{14,-38},{6,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valve.port_b, radiator.port_a) annotation (Line(
      points={{34,-38},{41,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(radiator.port_b, returnPipe.port_a) annotation (Line(
      points={{61,-38},{66,-38},{66,-44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_a, returnPipe.port_b) annotation (Line(
      points={{-72,-38},{-82,-38},{-82,-70},{66,-70},{66,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(radiator.convPort, thermalZone.internalGainsConv) annotation (Line(
      points={{46.8,-30.4},{46.8,-6.2},{35,-6.2},{35,35.7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalZone.internalGainsConv, temperatureSensor.port) annotation (
      Line(
      points={{35,35.7},{35,16},{-28,16},{-28,-18},{-24,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(
      points={{-12,-18},{0,-18},{0,-5.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.u_s, setTemp.y) annotation (Line(
      points={{-7.2,2},{-11.4,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, valve.opening) annotation (Line(
      points={{6.6,2},{24,2},{24,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nightSignal.y, pump.IsNight) annotation (Line(
      points={{-81.3,-12},{-62,-12},{-62,-27.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(thermalZone.internalGainsRad, radiator.radPort) annotation (Line(
      points={{41.8,35.7},{41.8,4},{55,4},{55,-30.2}},
      color={95,95,95},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(flowTemp.y, boiler.T_set) annotation (Line(
      points={{-49.4,-12},{-46,-12},{-46,-31},{-40.8,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weather.WeatherDataVector[1], thermalZone.infiltrationTemperature)
    annotation (Line(
      points={{-29.1267,66.7},{-29.1267,44.37},{22.25,44.37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expansionVessel.ports[1], pump.port_a) annotation (Line(
      points={{-82,-78},{-82,-38},{-72,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3.1536e+007, Interval=1800),
    __Dymola_experimentSetupOutput(textual=true),
    Documentation(info="<html>
<p>This is the AixLib model for the EnEff:BIM Use Case: BoilerGasRadiator 1.1</p>
<p><br>This model was developed to be used for parameter identification for SimModel to Modelica Mapping!</p>
<p>The model is strongly simplified and not tested at all, it might have wrong modelling assumptions and give senseless simulation results. </p>
</html>"));
end UseCase1_1;
