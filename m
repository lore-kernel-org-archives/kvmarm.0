From: Riku Voipio <riku.voipio@linaro.org>
Subject: Aarch64 vm-spec validation tools
Date: Wed, 21 Dec 2016 13:25:14 +0200
Message-ID: <CAAqcGHmj5PgCgLJzhQmO0oCzyitGA83415ALrXbvoGQdyJYKRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7941A404CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2016 06:24:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EWRtqprIyYAT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2016 06:23:59 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 313A5404BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2016 06:23:58 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id t196so95759979lff.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2016 03:25:16 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Some time ago we drafted a specification[1] for AArch64 virtual
machines. Now we are launching verification tools that let everyone
verify that the whole stack (host hypervisor, guest firmware and guest
OS image) implements the spec:

https://github.com/linaro/vmspec-tools

For some extra background see the blog post on vmspec:

http://www.linaro.org/blog/core-dump/ensuring-bootable-arm-vm-images/

>From the cross-distro point of view, we are interested in finding out if

- QEMU shipped is new enough (2.6+)
- a compatible EFI for arm64 guests is available
- a vmspec compatible cloud guest image is available

If the image comes with cloud-init, vmspec-boot can be used directly
to verify compliance. Without cloud-init, one can run vmspec-verify
inside the guest to verify manually.

The tools are still under development, for example the ACPI test
returns a failure even if the guest would support ACPI if forced.
Feedback and patches are always welcome.

The README.md lists a handful of guest images that have been used in
testing. I'd be most happy to add more links to the list!

Riku

[1] http://www.linaro.org/app/resources/WhitePaper/VMSystemSpecificationForARM-v2.0.pdf
