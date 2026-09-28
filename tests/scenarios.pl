:- module(scenarios, [scenario/5]).

% Expected actions and rule IDs were specified for synthetic cases.
scenario(t01,'Printer has no power',
 [obs(printer_on,no)], [power_on], [r01,r31]).
scenario(t02,'Loose USB connection',
 [obs(connection,usb),obs(usb_secure,no)], [secure_usb], [r02,r31]).
scenario(t03,'USB secure but printer not detected',
 [obs(symptom,not_found),obs(connection,usb),obs(usb_secure,yes)],
 [try_usb_port], [r03,r31]).
scenario(t04,'Wi-Fi network mismatch',
 [obs(connection,wifi),obs(same_network,no)], [join_same_wifi], [r04,r31]).
scenario(t05,'Bluetooth disabled',
 [obs(connection,bluetooth),obs(bluetooth_enabled,no)], [enable_bluetooth], [r05,r31]).
scenario(t06,'Bluetooth range problem',
 [obs(connection,bluetooth),obs(bluetooth_enabled,yes),obs(in_range,no)],
 [move_closer], [r06,r31]).
scenario(t07,'Offline with restart and default checks pending',
 [obs(symptom,offline),obs(printer_on,yes),obs(restarted,no),obs(intended_default,no)],
 [power_cycle,set_default], [r07,r08,r31]).
scenario(t08,'Stuck jobs not yet cancelled',
 [obs(symptom,stuck_queue),obs(cancel_attempted,no)], [cancel_jobs], [r09,r31]).
scenario(t09,'Cancellation failed and spooler stopped',
 [obs(symptom,stuck_queue),obs(cancel_attempted,yes),obs(queue_cleared,no),obs(spooler_running,no)],
 [manual_queue_clear,restart_spooler], [r10,r11,r31]).
scenario(t10,'Spooler failure with duplicate drivers',
 [obs(symptom,spooler_failure),obs(duplicate_drivers,yes)], [review_drivers], [r12,r31]).
scenario(t11,'Paper jam and paper-setting mismatch',
 [obs(symptom,paper_jam),obs(paper_matches,no)], [clear_jam,reload_paper], [r13,r14,r31]).
scenario(t12,'Several contributors to slow printing',
 [obs(symptom,slow),obs(connection,wifi),obs(quality_high,yes),obs(large_job,yes),obs(firmware_available,yes)],
 [reduce_quality,simplify_job,try_wired,update_firmware], [r15,r16,r17,r18,r31]).
scenario(t13,'Empty supply and unknown internal test',
 [obs(symptom,poor_quality),obs(cartridge_empty,yes),obs(internal_test,unknown)],
 [replace_consumable], [r19,r31]).
scenario(t14,'Poor inkjet internal test',
 [obs(symptom,poor_quality),obs(internal_test,poor),obs(printer_type,inkjet)],
 [clean_align,hardware_care], [r20,r22,r31]).
scenario(t15,'Good internal test but draft mode selected',
 [obs(symptom,poor_quality),obs(internal_test,good),obs(draft_mode,yes)],
 [normal_quality], [r21,r31]).
scenario(t16,'App checks and incorrect destination',
 [obs(symptom,app_failure),obs(other_apps_tested,no),obs(selected_correct,no),obs(print_to_file,yes)],
 [compare_apps,physical_destination,select_printer], [r23,r24,r25,r31]).
scenario(t17,'No suitable driver found by Windows',
 [obs(symptom,driver_issue),obs(windows_driver_found,no)], [manufacturer_driver], [r26,r31]).
scenario(t18,'Driver update with rollback available',
 [obs(symptom,driver_issue),obs(after_update,yes),obs(rollback_available,yes)],
 [rollback_driver], [r27,r31]).
scenario(t19,'Shared printer configuration and access problems',
 [obs(symptom,shared_failure),obs(share_enabled,no),obs(host_accessible,no),obs(credentials_rejected,yes)],
 [check_host_network,enable_share,valid_credentials], [r28,r29,r30,r31]).
scenario(t20,'All observations unknown',
 [obs(symptom,unknown),obs(connection,unknown),obs(printer_on,unknown)], [], []).
scenario(t21,'Wi-Fi network matches',
 [obs(connection,wifi),obs(same_network,yes)], [], []).
scenario(t22,'Wi-Fi observation cannot trigger for USB',
 [obs(connection,usb),obs(same_network,no)], [], []).
scenario(t23,'Laser must not receive inkjet cleaning advice',
 [obs(symptom,poor_quality),obs(internal_test,poor),obs(printer_type,laser)],
 [hardware_care], [r20,r31]).
scenario(t24,'Rollback unavailable',
 [obs(symptom,driver_issue),obs(after_update,yes),obs(rollback_available,no)], [], []).
scenario(t25,'Cancellation succeeded',
 [obs(symptom,stuck_queue),obs(cancel_attempted,yes),obs(queue_cleared,yes)], [], []).
scenario(t26,'Restart already completed and default correct',
 [obs(symptom,offline),obs(printer_on,yes),obs(restarted,yes),obs(intended_default,yes)], [], []).
scenario(t27,'Empty consultation', [], [], []).
scenario(t28,'Bluetooth state unknown does not imply disabled',
 [obs(connection,bluetooth),obs(bluetooth_enabled,unknown),obs(in_range,no)], [], []).
