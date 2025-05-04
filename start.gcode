;开始g代码
 
M220 S100 ;速度100%
M221 S100 ;流量100%

M140 S[bed_temperature_initial_layer_single] ;设置热床温度，不等待
M104 S{nozzle_temperature_initial_layer[initial_extruder]+0} ; 喷嘴比设定高0度，调平
M17 X1.2 Y1.2 Z0.75 ;将电机电流复位为默认值
M17 Z0.4 ; 启用电机(降低Z马达电流)

M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ;关闭软端限位，防止潜在的逻辑问题
G29.1 Z{+0.0} ; 首先清除z-trim值
M204 S10000 ; init ACC set to 10m/s^2

;g28xy后再g28z非要在右手近门处挪一点点，G4 P1000 ;等待1秒也没有用，g91也没用，M290 X256 Y0 Z2.6666666 ;设个零点也不行，电机电流M17 X1.2 Y1.2 Z0.4也不行，应该是拓竹的safez，如果使用g91记得把这一段算上！！ ;将m290设在g28前会导致g28也参考m290，后续所有任务傻b竹子死活归零无力，而我找不到竹子的失能g代码，只能重启，浪费我一晚上，cao
;将m290设在g28后也会导致后续所有任务傻b竹子死活归零无力

G28 X Y 
G1 X128 Y254 F30000

G28 Z P0 T300; home z with low precision,permit 300 temperature

G90
G1 Y250 F30000
G1 X55
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X-35 F30000
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200
G90

G1 X128 Y254 F30000
G28 Z P0 T300
M104 S{nozzle_temperature_initial_layer[initial_extruder]+0} ; z归零后立马回温
;G1 X246 Y0 Z-0.4
;G91
;;因为没上料所以此处挤出没有用，如果打废或者手动进料会挤出，记得清理
;G1 X10 Y0 Z0  F18000  ;E5
;G1 X-5 Y0 Z5 ;E0
;G1 X-5 Y0 Z-5 ;E0
;G1 X10 Y0 Z0 ;E3
;G1 Z5
;G90

M17 X1.2 Y1.2 Z0.75 ;将电机电流复位为默认值
;M17 x1.2 y1.2 z0.75;将电机电流复位为默认值，设高会不会更强
M975 S1 ; 打开振动补偿

;G1 X80 Y245 F30000 ;移动到马桶前面
;G1 Y266 F3000 ;慢慢移到马桶里，y267就可能撞丢步，虽然再往里废料更容易进去
;注释掉以上2个代码，拓竹ams代码里会自己回坑的
G1 X-48
;以下三个g代码停顿了好一会儿，可优化吗
M1002 gcode_claim_action : 2
M106 P1 S0 ;关风扇
G29.2 S0 ;关闭ABL（自动调平）

M620 M ;AMS,好像只要用ams就会自己回厕所往前再往后
M620 S[initial_extruder]A   ; 如果AMS存在，则切换材料
    M109 S[nozzle_temperature_initial_layer] ;热端升至打印温度
   T[initial_extruder] ;注释掉会不挤出,调试用
    M400
M621 S[initial_extruder]A
;设置在最初温度下启用ams？
M620.1 E F{filament_max_volumetric_speed[initial_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_extruder]}
G1 X-28.5 F18000
G1 X-48.2 F3000
G1 X-28.5 F18000 ;wipe and shake
G1 X-48.2 F3000
G1 X-28.5 F12000 ;wipe and shake
G1 X-48.2 F3000
;进料后，挤出设置为最大体积速度/耗材截面积*60，在最高的 设置的喷嘴温度下

M412 S1 ; 打开断料检检测===
;G1 X60 Y245 F25000  ;冗余代码：注释掉同时关闭ams会导致喷嘴在上文（这里是归零）坐标挤出
;G1 X84 Y266 F25000  ;冗余代码：同上防止ams不执行，挤出烧塑料
M109 S{nozzle_temperature_initial_layer[initial_extruder]+10} ;冗余代码：热端回至打印温度，准备冲刷
G92 E0
;G1 E5 Z0.2 F3000;换料不干净别增加这个，
;貌似e大了不执行
M106 P1 S178 ;打开吹料风扇 
G92 E0
G1 E120 F{filament_max_volumetric_speed[initial_extruder]/2.4053*60+150} ;换料不干净增加这个E
M109 S{nozzle_temperature_initial_layer[initial_extruder]}
;G1 X-28.5 F25000
;G1 X-48.2 F3000
;G1 X-28.5 F25000 ;wipe and shake
;G1 X-48.2 F3000
;G1 X-28.5 F25000 ;wipe and shake
;G1 X-48.2 F3000
;G1 X-28.5 F25000
;G1 X-48.2 F8000
;G1 X-28.5 F25000 ;wipe and shake
;G1 X-48.2 F8000
;G1 X-28.5 F25000 ;wipe and shake
;G1 X-48.2 F8000
;G1 X-28.5 F25000 ;wipe and shake
;G1 X-48.2 F8000

;换料不干净增加这个EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
;换料不干净增加这个EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
;换料不干净增加这个E
;pla黑顶tpu透明，80没问题
;petg灰顶pla黑，80头几层发黑粘不住
;pla黑顶petg灰，90，95底面扯几丝
;petg透明顶pla，90头几层发黑粘不住
G92 E0
;G1 E3 F{filament_max_volumetric_speed[initial_extruder]/2.4053*60+240} ;
;G92 E0
;G1 X145 F25000 ;丢步的话可能是y太靠后
;M106 P1 S255 ;关闭吹料风扇 
;M109 S{nozzle_temperature_initial_layer[initial_extruder]}
M106 P1 S0
;G1 X108.000 Y-0.500 F30000
;G1 Z0.300 F1200
;M400
;G2814 Z0.32


;G1 X145 F25000
;G1 X60 F25000 ;
;没擦干净带出来是挤出太少重力不够导致的，再擦一遍没有用
;G1 E20 F3600


M1002 gcode_claim_action : 14
G29.2 S1 ;打开ABL（自动调平），S0是关闭


;===== bed leveling ==================================
;M1002 judge_flag g29_before_print_flag
;M622 J1
;
;    M1002 gcode_claim_action : 1
;    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
;    M400
;    M500 ; save cali data

;M623
;===== bed leveling end ================================
;=====对于有纹理的PEI板，在归巢时降低喷嘴，因为喷嘴接触到纹理的最顶部 ==
;curr_bed_type={curr_bed_type}
;{if curr_bed_type=="Textured PEI Plate"}
;G29.1 Z{-0.04} ; for Textured PEI Plate
;{endif}
;========关掉灯和挤压温度等 ============
;M1002 gcode_claim_action : 0
;M106 S0 ; turn off fan
;M106 P2 S0 ; turn off big fan
;M106 P3 S0 ; turn off chamber fan

;M190 S[bed_temperature_initial_layer_single] ;wait for bed temp
;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type}
{if curr_bed_type=="Textured PEI Plate"}
G29.1 Z{-0.26} ; for Textured PEI Plate
{endif}
G29.1 Z{-0.25}
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4
