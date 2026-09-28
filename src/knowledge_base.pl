% PrinterExpert | P. K. V. J. Senarathna | 224177B
% Domain evidence: Microsoft Support, accessed 28 September 2026.
:- module(knowledge_base, [source/3, kb_fact/4, rule/4, action/2, field/3]).

source(s01, 'Fix printer connection and printing problems in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-printer-connection-and-printing-problems-in-windows').
source(s02, 'Fix printer not found and printer not recognized errors in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-printer-not-found-and-printer-not-recognized-errors-in-windows').
source(s03, 'Troubleshooting offline printer problems in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/troubleshooting-offline-printer-problems-in-windows').
source(s04, 'Fix print job stuck in queue errors in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-print-job-stuck-in-queue-errors-in-windows').
source(s05, 'Fix print spooler service not running errors in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-print-spooler-service-not-running-errors-in-windows').
source(s06, 'Fix printer stopped due to paper jam errors in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-printer-stopped-due-to-paper-jam-errors-in-windows').
source(s07, 'Troubleshoot slow printing issues in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/troubleshoot-slow-printing-issues-in-windows').
source(s08, 'Fix poor print quality in Windows (Blurry, faded, or streaked prints)', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-poor-print-quality-in-windows-blurry-faded-or-streaked-prints').
source(s09, 'Fix printing problems in Word, Excel, or other apps', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-printing-problems-in-word-excel-or-other-apps').
source(s10, 'Fix printer driver compatibility issues in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-printer-driver-compatibility-issues-in-windows').
source(s11, 'Fix shared printer connection problems in Windows', 'https://support.microsoft.com/en-us/windows/hardware/printer/fix-shared-printer-connection-problems-in-windows').

% 30 unconditional domain facts: finding-to-remedy relationships.
kb_fact(f01, remedy(power_off, power_on), s02, 'Step 1').
kb_fact(f02, remedy(loose_usb, secure_usb), s02, 'Step 1 / USB Printer').
kb_fact(f03, remedy(usb_unrecognized, try_usb_port), s02, 'Step 1 / USB Printer').
kb_fact(f04, remedy(wifi_mismatch, join_same_wifi), s03, 'Step 2').
kb_fact(f05, remedy(bluetooth_disabled, enable_bluetooth), s02, 'Step 1 / Bluetooth Printer').
kb_fact(f06, remedy(bluetooth_out_of_range, move_closer), s02, 'Step 1 / Bluetooth Printer').
kb_fact(f07, remedy(offline_restart, power_cycle), s03, 'Step 1').
kb_fact(f08, remedy(wrong_default, set_default), s03, 'Step 3').
kb_fact(f09, remedy(stuck_jobs, cancel_jobs), s04, 'Step 1').
kb_fact(f10, remedy(queue_cancel_failed, manual_queue_clear), s04, 'Step 3').
kb_fact(f11, remedy(spooler_stopped, restart_spooler), s05, 'Step 3').
kb_fact(f12, remedy(duplicate_drivers, review_drivers), s05, 'Step 2').
kb_fact(f13, remedy(paper_jam, clear_jam), s06, 'Steps 1-3').
kb_fact(f14, remedy(paper_mismatch, reload_paper), s06, 'Step 4').
kb_fact(f15, remedy(excess_quality, reduce_quality), s07, 'Step 1').
kb_fact(f16, remedy(wireless_speed_check, try_wired), s07, 'Step 2').
kb_fact(f17, remedy(complex_job, simplify_job), s07, 'Step 4').
kb_fact(f18, remedy(firmware_candidate, update_firmware), s07, 'Step 3').
kb_fact(f19, remedy(empty_cartridge, replace_consumable), s08, 'Step 1').
kb_fact(f20, remedy(hardware_quality, hardware_care), s08, 'Step 2').
kb_fact(f21, remedy(draft_quality, normal_quality), s08, 'Steps 2-3').
kb_fact(f22, remedy(inkjet_maintenance, clean_align), s08, 'Step 5').
kb_fact(f23, remedy(app_comparison, compare_apps), s09, 'Step 1').
kb_fact(f24, remedy(wrong_app_printer, select_printer), s09, 'Step 2').
kb_fact(f25, remedy(file_destination, physical_destination), s09, 'Step 3').
kb_fact(f26, remedy(driver_unavailable, manufacturer_driver), s10, 'Steps 1-3').
kb_fact(f27, remedy(update_regression, rollback_driver), s10, 'Step 6').
kb_fact(f28, remedy(sharing_disabled, enable_share), s11, 'Step 1').
kb_fact(f29, remedy(host_unreachable, check_host_network), s11, 'Step 2').
kb_fact(f30, remedy(credentials_problem, valid_credentials), s11, 'Step 3').

% 30 production rules: all listed observations must be present.
rule(r01, [obs(printer_on, no)],
     finding(power_off), s02).
rule(r02, [obs(connection, usb), obs(usb_secure, no)],
     finding(loose_usb), s02).
rule(r03, [obs(symptom, not_found), obs(connection, usb), obs(usb_secure, yes)],
     finding(usb_unrecognized), s02).
rule(r04, [obs(connection, wifi), obs(same_network, no)],
     finding(wifi_mismatch), s03).
rule(r05, [obs(connection, bluetooth), obs(bluetooth_enabled, no)],
     finding(bluetooth_disabled), s02).
rule(r06, [obs(connection, bluetooth), obs(bluetooth_enabled, yes), obs(in_range, no)],
     finding(bluetooth_out_of_range), s02).
rule(r07, [obs(symptom, offline), obs(printer_on, yes), obs(restarted, no)],
     finding(offline_restart), s03).
rule(r08, [obs(symptom, offline), obs(intended_default, no)],
     finding(wrong_default), s03).
rule(r09, [obs(symptom, stuck_queue), obs(cancel_attempted, no)],
     finding(stuck_jobs), s04).
rule(r10, [obs(symptom, stuck_queue), obs(cancel_attempted, yes), obs(queue_cleared, no)],
     finding(queue_cancel_failed), s04).
rule(r11, [obs(spooler_running, no)],
     finding(spooler_stopped), s05).
rule(r12, [obs(symptom, spooler_failure), obs(duplicate_drivers, yes)],
     finding(duplicate_drivers), s05).
rule(r13, [obs(symptom, paper_jam)],
     finding(paper_jam), s06).
rule(r14, [obs(symptom, paper_jam), obs(paper_matches, no)],
     finding(paper_mismatch), s06).
rule(r15, [obs(symptom, slow), obs(quality_high, yes)],
     finding(excess_quality), s07).
rule(r16, [obs(symptom, slow), obs(connection, wifi)],
     finding(wireless_speed_check), s07).
rule(r17, [obs(symptom, slow), obs(large_job, yes)],
     finding(complex_job), s07).
rule(r18, [obs(symptom, slow), obs(firmware_available, yes)],
     finding(firmware_candidate), s07).
rule(r19, [obs(symptom, poor_quality), obs(cartridge_empty, yes)],
     finding(empty_cartridge), s08).
rule(r20, [obs(symptom, poor_quality), obs(internal_test, poor)],
     finding(hardware_quality), s08).
rule(r21, [obs(symptom, poor_quality), obs(internal_test, good), obs(draft_mode, yes)],
     finding(draft_quality), s08).
rule(r22, [obs(symptom, poor_quality), obs(internal_test, poor), obs(printer_type, inkjet)],
     finding(inkjet_maintenance), s08).
rule(r23, [obs(symptom, app_failure), obs(other_apps_tested, no)],
     finding(app_comparison), s09).
rule(r24, [obs(symptom, app_failure), obs(selected_correct, no)],
     finding(wrong_app_printer), s09).
rule(r25, [obs(symptom, app_failure), obs(print_to_file, yes)],
     finding(file_destination), s09).
rule(r26, [obs(symptom, driver_issue), obs(windows_driver_found, no)],
     finding(driver_unavailable), s10).
rule(r27, [obs(symptom, driver_issue), obs(after_update, yes), obs(rollback_available, yes)],
     finding(update_regression), s10).
rule(r28, [obs(symptom, shared_failure), obs(share_enabled, no)],
     finding(sharing_disabled), s11).
rule(r29, [obs(symptom, shared_failure), obs(host_accessible, no)],
     finding(host_unreachable), s11).
rule(r30, [obs(symptom, shared_failure), obs(credentials_rejected, yes)],
     finding(credentials_problem), s11).

% R31 joins an established finding with a sourced remedy fact.
% The 30 symptom rules above meet the domain-rule count independently.
rule(r31, [finding(Issue), remedy(Issue, Action)],
     recommend(Action), knowledge_base).

action(power_on, 'Turn on the printer and check its power connection.').
action(secure_usb, 'Reconnect the USB cable securely at both ends.').
action(try_usb_port, 'Try another USB port and check detection again.').
action(join_same_wifi, 'Connect the computer and printer to the same Wi-Fi network.').
action(enable_bluetooth, 'Enable Bluetooth on the computer and printer.').
action(move_closer, 'Move the printer within Bluetooth range and retry.').
action(power_cycle, 'Turn off and unplug the printer; wait 30 seconds, reconnect, and switch it on.').
action(set_default, 'Select the intended default printer in Printers & scanners.').
action(cancel_jobs, 'Cancel the stuck jobs in the Windows print queue; resubmit needed documents later.').
action(manual_queue_clear, 'Follow the linked stop-spooler, clear-spool-folder, start-spooler procedure. It removes queued jobs; administrator help may be needed.').
action(restart_spooler, 'Open Services and restart Print Spooler; request administrator help if access is denied.').
action(review_drivers, 'Review old or duplicate printer drivers and install the model-specific current driver. Ask an administrator before removal on a shared computer.').
action(clear_jam, 'Switch off and unplug first. Follow the model manual to remove trapped paper and scraps; never force moving parts.').
action(reload_paper, 'After clearing the jam, reload matching paper and adjust its guides.').
action(reduce_quality, 'Choose an appropriate standard quality setting when maximum quality is unnecessary.').
action(try_wired, 'Temporarily compare printing through USB or Ethernet to check for network delay.').
action(simplify_job, 'Reduce image size or simplify the document and compare printing speed.').
action(update_firmware, 'Use the manufacturer support instructions for an available model-specific firmware update.').
action(replace_consumable, 'Replace the empty ink or toner supply using the model instructions.').
action(hardware_care, 'Investigate printer maintenance or service because its own test page is poor.').
action(normal_quality, 'Turn off Draft or Economy mode and use Normal or Best quality.').
action(clean_align, 'Use the inkjet maintenance utility to clean or align the printhead; repeat only when necessary.').
action(compare_apps, 'Try another application and another file to narrow down the failing scope.').
action(select_printer, 'Choose the intended printer in the application print dialog.').
action(physical_destination, 'Choose the physical printer instead of Print to PDF or Print to file.').
action(manufacturer_driver, 'Obtain the printer model driver matching the Windows version and system type from its manufacturer.').
action(rollback_driver, 'Use Roll Back Driver if available, then restart the computer and retest.').
action(enable_share, 'On the host, enable Share this printer and note the share name; obtain permission on managed computers.').
action(check_host_network, 'Check the local network and host-name access before reconnecting the shared printer.').
action(valid_credentials, 'Use valid authorised host credentials when Windows asks. Do not enter passwords into this program.').

% UI vocabulary; these declarations are not counted as domain facts.
field(symptom, [not_found, offline, stuck_queue, spooler_failure, paper_jam, slow, poor_quality, app_failure, driver_issue, shared_failure, unknown], 'Choose the main printing problem').
field(connection, [usb, wifi, bluetooth, shared, other, unknown], 'How is the printer connected?').
field(printer_on, [yes, no, unknown], 'Is the printer switched on?').
field(usb_secure, [yes, no, unknown], 'Is the USB cable firmly connected at both ends?').
field(same_network, [yes, no, unknown], 'Are the printer and computer on the same Wi-Fi network?').
field(bluetooth_enabled, [yes, no, unknown], 'Is Bluetooth enabled on both devices?').
field(in_range, [yes, no, unknown], 'Is the printer within Bluetooth range?').
field(restarted, [yes, no, unknown], 'Has the printer already been power-cycled for this problem?').
field(intended_default, [yes, no, unknown], 'Is the intended printer the Windows default?').
field(cancel_attempted, [yes, no, unknown], 'Have you already tried cancelling the stuck jobs?').
field(queue_cleared, [yes, no, unknown], 'Did cancellation clear the queue?').
field(spooler_running, [yes, no, unknown], 'Is Print Spooler running in Windows Services?').
field(duplicate_drivers, [yes, no, unknown], 'Are old or duplicate printer drivers present?').
field(paper_matches, [yes, no, unknown], 'Do the loaded paper size and type match the settings?').
field(quality_high, [yes, no, unknown], 'Is the print quality unnecessarily high for this job?').
field(large_job, [yes, no, unknown], 'Does the job contain large files or high-resolution images?').
field(firmware_available, [yes, no, unknown], 'Has the manufacturer listed a firmware update for this model?').
field(cartridge_empty, [yes, no, unknown], 'Is an ink or toner supply empty?').
field(internal_test, [good, poor, unknown], 'How does a test page printed directly by the printer look?').
field(draft_mode, [yes, no, unknown], 'Is Draft, Economy, or Toner saver mode enabled?').
field(printer_type, [inkjet, laser, other, unknown], 'What type of printer is it?').
field(other_apps_tested, [yes, no, unknown], 'Have you tested another app and another file?').
field(selected_correct, [yes, no, unknown], 'Is the correct printer selected in the failing application?').
field(print_to_file, [yes, no, unknown], 'Is Print to PDF or Print to file selected?').
field(windows_driver_found, [yes, no, unknown], 'Did Windows find a suitable printer driver?').
field(after_update, [yes, no, unknown], 'Did the problem begin after a printer-driver update?').
field(rollback_available, [yes, no, unknown], 'Is Roll Back Driver available in Device Manager?').
field(share_enabled, [yes, no, unknown], 'Is Share this printer enabled on the host PC?').
field(host_accessible, [yes, no, unknown], 'Can the client access the host PC on the local network?').
field(credentials_rejected, [yes, no, unknown], 'Has Windows rejected the supplied host credentials?').
