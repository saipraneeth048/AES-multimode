## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Buttons
# Reset (Center Button)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Start (Up Button)
set_property PACKAGE_PIN T18 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

## LEDs
# Done (LED 0)
set_property PACKAGE_PIN U16 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports done]

# Check LED (LED 1)
set_property PACKAGE_PIN E19 [get_ports check_led]
set_property IOSTANDARD LVCMOS33 [get_ports check_led]

## Configuration
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
