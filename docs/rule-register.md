# Domain rule register

Microsoft Support guidance, accessed 28 September 2026. No expert interview was carried out.

R01-R30 identify findings from explicit observations. F01-F30 are the associated unconditional remedy relationships. R31 combines a finding with its remedy. These are suggested troubleshooting steps, not proven fault diagnoses.

| Rule / fact | Required observations (AND) | Finding | Remedy | Evidence |
|---|---|---|---|---|
| R01 / F01 | `printer_on=no` | `power_off` | `power_on` | [S02](references.md#s02) - Step 1 |
| R02 / F02 | `connection=usb usb_secure=no` | `loose_usb` | `secure_usb` | [S02](references.md#s02) - Step 1 / USB Printer |
| R03 / F03 | `symptom=not_found connection=usb usb_secure=yes` | `usb_unrecognized` | `try_usb_port` | [S02](references.md#s02) - Step 1 / USB Printer |
| R04 / F04 | `connection=wifi same_network=no` | `wifi_mismatch` | `join_same_wifi` | [S03](references.md#s03) - Step 2 |
| R05 / F05 | `connection=bluetooth bluetooth_enabled=no` | `bluetooth_disabled` | `enable_bluetooth` | [S02](references.md#s02) - Step 1 / Bluetooth Printer |
| R06 / F06 | `connection=bluetooth bluetooth_enabled=yes in_range=no` | `bluetooth_out_of_range` | `move_closer` | [S02](references.md#s02) - Step 1 / Bluetooth Printer |
| R07 / F07 | `symptom=offline printer_on=yes restarted=no` | `offline_restart` | `power_cycle` | [S03](references.md#s03) - Step 1 |
| R08 / F08 | `symptom=offline intended_default=no` | `wrong_default` | `set_default` | [S03](references.md#s03) - Step 3 |
| R09 / F09 | `symptom=stuck_queue cancel_attempted=no` | `stuck_jobs` | `cancel_jobs` | [S04](references.md#s04) - Step 1 |
| R10 / F10 | `symptom=stuck_queue cancel_attempted=yes queue_cleared=no` | `queue_cancel_failed` | `manual_queue_clear` | [S04](references.md#s04) - Step 3 |
| R11 / F11 | `spooler_running=no` | `spooler_stopped` | `restart_spooler` | [S05](references.md#s05) - Step 3 |
| R12 / F12 | `symptom=spooler_failure duplicate_drivers=yes` | `duplicate_drivers` | `review_drivers` | [S05](references.md#s05) - Step 2 |
| R13 / F13 | `symptom=paper_jam` | `paper_jam` | `clear_jam` | [S06](references.md#s06) - Steps 1-3 |
| R14 / F14 | `symptom=paper_jam paper_matches=no` | `paper_mismatch` | `reload_paper` | [S06](references.md#s06) - Step 4 |
| R15 / F15 | `symptom=slow quality_high=yes` | `excess_quality` | `reduce_quality` | [S07](references.md#s07) - Step 1 |
| R16 / F16 | `symptom=slow connection=wifi` | `wireless_speed_check` | `try_wired` | [S07](references.md#s07) - Step 2 |
| R17 / F17 | `symptom=slow large_job=yes` | `complex_job` | `simplify_job` | [S07](references.md#s07) - Step 4 |
| R18 / F18 | `symptom=slow firmware_available=yes` | `firmware_candidate` | `update_firmware` | [S07](references.md#s07) - Step 3 |
| R19 / F19 | `symptom=poor_quality cartridge_empty=yes` | `empty_cartridge` | `replace_consumable` | [S08](references.md#s08) - Step 1 |
| R20 / F20 | `symptom=poor_quality internal_test=poor` | `hardware_quality` | `hardware_care` | [S08](references.md#s08) - Step 2 |
| R21 / F21 | `symptom=poor_quality internal_test=good draft_mode=yes` | `draft_quality` | `normal_quality` | [S08](references.md#s08) - Steps 2-3 |
| R22 / F22 | `symptom=poor_quality internal_test=poor printer_type=inkjet` | `inkjet_maintenance` | `clean_align` | [S08](references.md#s08) - Step 5 |
| R23 / F23 | `symptom=app_failure other_apps_tested=no` | `app_comparison` | `compare_apps` | [S09](references.md#s09) - Step 1 |
| R24 / F24 | `symptom=app_failure selected_correct=no` | `wrong_app_printer` | `select_printer` | [S09](references.md#s09) - Step 2 |
| R25 / F25 | `symptom=app_failure print_to_file=yes` | `file_destination` | `physical_destination` | [S09](references.md#s09) - Step 3 |
| R26 / F26 | `symptom=driver_issue windows_driver_found=no` | `driver_unavailable` | `manufacturer_driver` | [S10](references.md#s10) - Steps 1-3 |
| R27 / F27 | `symptom=driver_issue after_update=yes rollback_available=yes` | `update_regression` | `rollback_driver` | [S10](references.md#s10) - Step 6 |
| R28 / F28 | `symptom=shared_failure share_enabled=no` | `sharing_disabled` | `enable_share` | [S11](references.md#s11) - Step 1 |
| R29 / F29 | `symptom=shared_failure host_accessible=no` | `host_unreachable` | `check_host_network` | [S11](references.md#s11) - Step 2 |
| R30 / F30 | `symptom=shared_failure credentials_rejected=yes` | `credentials_problem` | `valid_credentials` | [S11](references.md#s11) - Step 3 |

R31: IF `finding(Issue)` AND `remedy(Issue, Action)` THEN `recommend(Action)`. This is a general inference connection; the evidence for the action is the matching F fact. It is additional to the 30 domain rules.

## Representation decisions

The condition vocabulary and finding names are implementation choices. Conditions select the situations in which a published action is relevant; they do not establish an exclusive cause. Positive evidence is required for every condition. Absence of an answer does not establish its opposite. The 30 rule/fact mappings can be compared directly with the named source sections.

## Suggested actions

- **power_on**: Turn on the printer and check its power connection.
- **secure_usb**: Reconnect the USB cable securely at both ends.
- **try_usb_port**: Try another USB port and check detection again.
- **join_same_wifi**: Connect the computer and printer to the same Wi-Fi network.
- **enable_bluetooth**: Enable Bluetooth on the computer and printer.
- **move_closer**: Move the printer within Bluetooth range and retry.
- **power_cycle**: Turn off and unplug the printer; wait 30 seconds, reconnect, and switch it on.
- **set_default**: Select the intended default printer in Printers & scanners.
- **cancel_jobs**: Cancel the stuck jobs in the Windows print queue; resubmit needed documents later.
- **manual_queue_clear**: Follow the linked stop-spooler, clear-spool-folder, start-spooler procedure. It removes queued jobs; administrator help may be needed.
- **restart_spooler**: Open Services and restart Print Spooler; request administrator help if access is denied.
- **review_drivers**: Review old or duplicate printer drivers and install the model-specific current driver. Ask an administrator before removal on a shared computer.
- **clear_jam**: Switch off and unplug first. Follow the model manual to remove trapped paper and scraps; never force moving parts.
- **reload_paper**: After clearing the jam, reload matching paper and adjust its guides.
- **reduce_quality**: Choose an appropriate standard quality setting when maximum quality is unnecessary.
- **try_wired**: Temporarily compare printing through USB or Ethernet to check for network delay.
- **simplify_job**: Reduce image size or simplify the document and compare printing speed.
- **update_firmware**: Use the manufacturer support instructions for an available model-specific firmware update.
- **replace_consumable**: Replace the empty ink or toner supply using the model instructions.
- **hardware_care**: Investigate printer maintenance or service because its own test page is poor.
- **normal_quality**: Turn off Draft or Economy mode and use Normal or Best quality.
- **clean_align**: Use the inkjet maintenance utility to clean or align the printhead; repeat only when necessary.
- **compare_apps**: Try another application and another file to narrow down the failing scope.
- **select_printer**: Choose the intended printer in the application print dialog.
- **physical_destination**: Choose the physical printer instead of Print to PDF or Print to file.
- **manufacturer_driver**: Obtain the printer model driver matching the Windows version and system type from its manufacturer.
- **rollback_driver**: Use Roll Back Driver if available, then restart the computer and retest.
- **enable_share**: On the host, enable Share this printer and note the share name; obtain permission on managed computers.
- **check_host_network**: Check the local network and host-name access before reconnecting the shared printer.
- **valid_credentials**: Use valid authorised host credentials when Windows asks. Do not enter passwords into this program.
