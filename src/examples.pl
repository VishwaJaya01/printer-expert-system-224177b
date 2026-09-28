:- module(examples, [example/3]).

% Synthetic demonstrations, not measurements from real printers.
example(wifi_offline, 'Offline printer on a different Wi-Fi network',
    [obs(symptom,offline),obs(connection,wifi),obs(printer_on,yes),
     obs(same_network,no),obs(restarted,yes),obs(intended_default,yes)]).
example(stuck_queue, 'Queue remains stuck after cancellation',
    [obs(symptom,stuck_queue),obs(cancel_attempted,yes),
     obs(queue_cleared,no),obs(spooler_running,no)]).
example(inkjet_quality, 'Poor internal test page on an inkjet printer',
    [obs(symptom,poor_quality),obs(printer_type,inkjet),
     obs(internal_test,poor),obs(cartridge_empty,no)]).
example(slow_wifi, 'Slow wireless printing of a large high-quality job',
    [obs(symptom,slow),obs(connection,wifi),obs(quality_high,yes),
     obs(large_job,yes),obs(firmware_available,no)]).
example(driver_update, 'Printing failed after a driver update',
    [obs(symptom,driver_issue),obs(after_update,yes),
     obs(rollback_available,yes),obs(windows_driver_found,yes)]).
example(unknown_case, 'Insufficient information',
    [obs(symptom,unknown),obs(connection,unknown),obs(printer_on,unknown)]).
