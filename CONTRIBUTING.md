# Contributing to Swag

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following are mostly guidelines, not rules. 
Use your best judgment, and feel free to propose changes to this document in a pull request.

Here are some important resources:

  * Our roadmap is defined with [Github projects](https://github.com/a-team-fr/swag/projects)
  * Bugs or improvements ? [Github issues](https://github.com/a-team-fr/swag/issues) is where to report them
  * Chat: [Mattermost on Framateam](https://framateam.org/signup_user_complete/?id=qi4a83iynjrwu8b7r91sa631cr).
  * [Wiki](https://github.com/a-team-fr/swag/wiki)
  * Faq : [Question2Answer](https://faq.swagsoftware.net)
  * [Doxygen](https://a-team-fr.github.io/swag/html/)
  


#### Table Of Contents
[Code of Conduct](#code-of-conduct)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)
  
## Code of Conduct
This project and everyone participating in it is governed by the [Swag Code of Conduct](https://github.com/a-team-fr/swag/blob/master/CODE_OF_CONDUCT.md). 
By participating, you are expected to uphold this code. 
Please report unacceptable behavior to [gcharbonnier@a-team.fr](mailto:gcharbonnier@a-team.fr).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Swag. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template](https://github.com/a-team-fr/swag/blob/master/.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report
* **Check the [FAQs on the Question2Answer](https://faq.swagsoftware.net)** for a list of common questions and problems.
* **Perform a [cursory search](https://github.com/a-team-fr/swag/issues)** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://github.com/a-team-fr/swag/issues) with the **bug** label. Create an issue and provide the following information by filling in [the template](https://github.com/a-team-fr/swag/blob/master/.github/ISSUE_TEMPLATE/bug_report.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible. When listing steps, **don't just say what you did, but explain how you did it**. 
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **If you're reporting that Swag crashed**, include a crash report with a stack trace from the operating system. On macOS, the crash report will be available in `Console.app` under "Diagnostic and usage information" > "User diagnostic reports". Include the crash report in the issue in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines), a [file attachment](https://help.github.com/articles/file-attachments-on-issues-and-pull-requests/), or put it in a [gist](https://gist.github.com/) and provide link to that gist.
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of Swag) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of Swag?** What's the most recent version in which the problem doesn't happen? You can download older versions of Swag from [the releases page](https://github.com/a-team-fr/swag/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.
* If the problem is related to working with files (e.g. opening and editing files), **does the problem happen for all files and projects or only some?** Does the problem happen only when working with local or remote files (e.g. on network drives), with files of a specific type (e.g. only JavaScript or Python files), with large files or files with very long lines, or with files in a specific encoding? Is there anything else special about the files you are using?

Include details about your configuration and environment:

* **Which version of Swag are you using?** You can get the exact version by starting Swag and running the `About Swag` from the main menu.
* **What's the name and version of the OS you're using**?
* **Are you running Swag in a virtual machine?** If so, which VM software are you using and which operating systems and versions are used for the host and the guest?
* **Are you using Swag with multiple monitors?** If so, can you reproduce the problem when you use a single monitor?
* **Which keyboard layout are you using?** Are you using a US layout or some other layout?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Swag, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](https://github.com/a-team-fr/swag/blob/master/.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Perform a [cursory search](https://github.com/a-team-fr/swag/issues)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/a-team-fr/swag/issues) with **enhancement** label.  Create an issue and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of Swag which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful** to most Swag users
* **If applicable, list some other applications where this enhancement exists.**
* **Specify which version of Swag you're using.** You can get the exact versionby starting Swag and running the `About` command from the main menu.
* **Specify the name and version of the OS you're using.**

### Your First Code Contribution

Unsure where to begin contributing to Swag? You can start by looking through these `beginner` and `help-wanted` issues:

* [Beginner issues][beginner] - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues][help-wanted] - issues which should be a bit more involved than `beginner` issues.

### Pull Requests

The process described here has several goals:

- Maintain Swag's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible Swag
- Enable a sustainable system for Swag's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](PULL_REQUEST_TEMPLATE.md)
2. Follow the [styleguides](#styleguides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

Thanks! :heart: :heart: :heart:

Swag Team
