# PrinterExpert: Windows 11 Printer Troubleshooting

**P. K. V. J. Senarathna | 224177B**  
University of Moratuwa - Logic Programming and Cognitive Systems - Assignment 2

PrinterExpert uses observations about a printing problem to suggest the next checks. The knowledge base has 30 sourced domain facts, 30 troubleshooting rules, and one general rule joining a finding to its remedy. Forward and backward chaining use the same rules. Each answer includes the observations, rule IDs, and Microsoft Support references behind it.

## Requirements

- SWI-Prolog. Tested with **10.0.2 on Windows x64**.
- Download: <https://www.swi-prolog.org/download/stable>.
- No Python, paid software, additional Prolog packages, internet connection, or physical printer is needed to run the supplied demonstrations and tests. Internet access is needed only for installation or opening references.
- The advice concerns Windows 11. The program is a text interface, not an automatic printer repair tool.

## Start on Windows

1. Install the 64-bit Windows version of SWI-Prolog from the official download page. Enable its PATH option if offered.
2. Extract the complete code ZIP into a writable folder. Keep the `src`, `tests`, and `docs` folders together.
3. Double-click **`run.cmd`**. If Windows asks for a program to open it, run it from Command Prompt instead.
4. Select **2**, then **1**, then **3** to load the Wi-Fi demonstration and view its forward-chaining result.
5. Select **4**, then **4** to prove the `join_same_wifi` recommendation by backward chaining.
6. Select **0** to exit.

The launcher looks for `swipl` on PATH and in common installation folders. If it cannot find it, open Command Prompt in this folder and use:

```bat
set "SWIPL=C:\Program Files\swipl\bin\swipl.exe"
run.cmd
```

Replace that path if SWI-Prolog was installed elsewhere. No administrator access is required to run PrinterExpert.

## Terminal commands

Run these from the folder containing this README:

```text
swipl -q -s src/main.pl
swipl -q -s src/main.pl -- --demo
swipl -q -s tests/test_engine.pl
```

The first starts the menu, the second prints all six demonstrations and exits, and the third runs the tests. On Windows, `run.cmd demo` and `run.cmd test` are shortcuts. The test command writes `docs/test-results.json` after a successful run. A non-zero exit code means a failure. A terminal with `swipl` installed can use these commands on other operating systems, although the documented printer advice remains specific to Windows 11.

## A new consultation

Choose **1** and select the main symptom, connection type, and power state. Further questions depend on those choices. Enter the displayed words without quotes or full stops. Answers are case-insensitive. Press Enter or type `unknown` if an observation has not been checked.

For the Wi-Fi example, use `offline`, `wifi`, and `yes` for the first three answers. Answer `no` to the same-network question, `yes` to the power-cycle and default-printer questions, and `unknown` for the spooler question. Choose **3** when the consultation is saved.

The expected recommendation is `join_same_wifi`, supported by R04, F04, and R31. A full recorded example is in `examples/demo-output.txt`.

Menu **4** starts with a selected recommendation and looks for supporting evidence. If it cannot prove the recommendation, it lists missing observations or answers that differ from the rule conditions. Failure to prove an action does not prove that the printer is healthy.

Menu **5** shows the current inputs, **6** lists sources, and **7** clears the consultation. Starting a new consultation or loading a demonstration replaces the previous inputs. Results are listed alphabetically, not by probability or repair priority. Several recommendations can apply together. Follow any sequencing instructions within an action, especially turning the printer off before handling a paper jam.

## Files

| File | Purpose |
|---|---|
| `src/knowledge_base.pl` | Sourced facts, production rules, action wording, and input vocabulary |
| `src/engine.pl` | Forward inference, backward proof search, validation, and missing-evidence checks |
| `src/main.pl` | Menu, consultation questions, and explanations |
| `src/examples.pl` | Six synthetic demonstration cases |
| `tests/scenarios.pl` | 28 cases with independently specified expected answers and rule IDs |
| `tests/test_engine.pl` | Scenario, proof, coverage, validation, and session-isolation checks |
| `docs/rule-register.md` | Conditions, findings, remedies, and exact source sections for every domain rule |
| `docs/test-results.json` | Recorded expected and actual outputs |
| `docs/references.md` | Reference list and knowledge-acquisition notes |

## Scope and limitations

The rules are formalised from Microsoft Support articles accessed on **28 September 2026**. No domain expert was interviewed. The evidence is the published troubleshooting guidance, and the program narrows it into explicit conditions that can be checked in a consultation. Suggested checks are not confirmed root-cause diagnoses or guarantees of a repair.

All demonstration and test observations are synthetic. Tests establish the program's behaviour against the specified rules; no physical printer repair trial was performed. The program does not collect passwords, run maintenance commands, change services, delete print jobs, or send data anywhere. It retains inputs only while it is running. Model-specific repair details should be checked against the manufacturer's manual.

## Changing the knowledge base

Edit `src/knowledge_base.pl`. Keep a stable rule ID, cite the relevant source section, and add a matching scenario with its expected result. A production rule is represented as `rule(Id, Conditions, Conclusion, Source)`; every condition must hold. The engine interprets these data terms as implications. The `kb_fact/4` clauses are unconditional domain relationships, while `field/3` declarations describe the interface and are not counted as domain facts.

## Submission

Submit the separate `224177B_Expert_System_Report.pdf` and the code ZIP. A public repository can be used as an alternative code link. The PDF annexes include all domain facts, numbered rules and references, scenario results, and the knowledge-base and inference-engine code.
