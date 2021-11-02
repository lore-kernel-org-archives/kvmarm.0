Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE018C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 741B460240
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 741B460240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FB44B15A;
	Tue,  2 Nov 2021 05:47:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8sjIdMi-l1dI; Tue,  2 Nov 2021 05:47:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 279DE4B15E;
	Tue,  2 Nov 2021 05:47:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88AE64B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lL0fhGIvfOWO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:47:00 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44B54B153
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:00 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 j19-20020a0566022cd300b005e1816be9abso6929630iow.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=8Hd2ZUMx5ILHWyo2zM7pIHkuH4DnNmNsL76fDtWtm1s=;
 b=E2M0qmyqra/TlmR8sNdUNnqypFAgx2byfZsucj64HcfDQTvxD/mvhZJkXohOyHvfnv
 d5IB+ZGFXPR88GhGj/Ivf6QeDGp/6YurkWU2p55yIF4wdlt+JGIIU7r6G+HtZB05dFYo
 CGJuXlvDZLzUfyKYuMfoyq10hlYCDy/eizAOlLOxyNs7nwnVK952aeHGe/7QAwduEmge
 +I11gM4N4guNIyZWghqOG+A1y17uVCtQQwQhMKCIY5yU3QnKn7qPfbhZl8i+MP/Jd3Kf
 l3LWpUcJCZ8LPuWIkK9ibOyrEYmODpJ1s/MuMXosi0RdgDOUHSUtMAoyMKpl4/92Jzdp
 NXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=8Hd2ZUMx5ILHWyo2zM7pIHkuH4DnNmNsL76fDtWtm1s=;
 b=yRke+hCDlFlRYmsq3a6Fci3I6vJEOzMRHNzEJSelPjsLFuL43YemeG3m+IbovkIaXI
 bCFm3amvpnVmV+0K7uhjSWtGDT1teL5XxwatG8PPFrF3eNwaZKe4Gsyr4P8/dqGpIvQ8
 g6xXRT/pxDSzFmHrZlrBDL/cV+EHfv+YB1IPuCw9Woapk9dlrwSKY8gRTlHDDONW3kZq
 VLqT6RDIV1yrkk/8s31ua3HKkQPk7NDvDhpj3gqi1B7quJvK2P9c0JsemT06fhI3yaVV
 poJNT3nLfURjA7+pzOBpIak7IoqfTvP2ZZqaiStRESNUk+FcEQAnnkuqyNHDKExfJNKt
 RAkA==
X-Gm-Message-State: AOAM530hGGZ+klhZdddAdNqcfAV5F/Pw2IFpA3NDPHnZUB0f4cDgvJnx
 H6KHZPRBTphTgRdH4npoLuvdThg9CSI421EkX1pQclLHOFTY0wqvGeMMoigvBO5bBXKY0tdCDg5
 GEZ/vbXjzOBJ9cduAC72eqDEdmB8dynXqPVt1KnGBS2rV1zBIpUA0qJEft/1kENN+3fDJZw==
X-Google-Smtp-Source: ABdhPJwp82eJZKpATb/STfJK1tEYrOYlTSbWGpyQyJFGOHuzO64TyzBAnAXrfYhajH7o5tbhGvqNlILST3A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:c9c1:: with SMTP id
 c1mr11157225jap.0.1635846420169; 
 Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
Date: Tue,  2 Nov 2021 09:46:45 +0000
Message-Id: <20211102094651.2071532-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 0/6] KVM: arm64: Emulate the OS lock
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM does not implement the debug architecture to the letter of the
specification. One such issue is the fact that KVM treats the OS Lock as
RAZ/WI, rather than emulating its behavior on hardware. This series adds
emulation support for the OS Lock to KVM. Emulation is warranted as the
OS Lock affects debug exceptions taken from all ELs, and is not limited
to only the context of the guest.

The 1st patch is a correctness fix for the OSLSR register, ensuring
the trap handler actually is written to suggest WO behavior. Note that
the changed code should never be reached on a correct implementation, as
hardware should generate the undef, not KVM.

The 2nd patch adds the necessary context to track guest values of the
OS Lock bit and exposes the value to userspace for the sake of
migration.

The 3rd patch makes the OSLK bit writable in OSLAR_EL1 (from the guest)
and OSLSR_EL1 (from userspace), but does nothing with its value.

The 4th patch actually implements the OS Lock behavior, disabling all
debug exceptions from the perspective of the guest. This is done by
disabling MDE and SS in MDSCR_EL1. Since software breakpoint
instructions cannot be masked by anything but the OS Lock, we emulate by
trapping debug exceptions to EL2 and skipping the breakpoint. Skip this
whole song and dance altogether if userspace is debugging the guest.

The 5th patch asserts that OSLSR_EL1 is exposed by KVM to userspace
through the KVM_GET_REG_LIST ioctl. Lastly, the 6th patch asserts that
no debug exceptions are routed to the guest when the OSLK bit is set.

This series applies cleanly to 5.15. Tested on an Ampere Altra machine
with the included selftests patches. Additionally, I single-stepped a
guest using kvmtool to make sure userspace debugging is still working
correctly.

[v1]: http://lore.kernel.org/r/20211029003202.158161-1-oupton@google.com

v1 -> v2:
 - Added OSLSR_EL1 to get-reg-list test
 - Added test cases to debug-exceptions test
 - Scrapped the context switching of OSLSR_EL1
 - Dropped DFR0 changes, to be addressed in a later series

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  5 ++
 arch/arm64/include/asm/sysreg.h               |  6 ++
 arch/arm64/kvm/debug.c                        | 20 ++++--
 arch/arm64/kvm/handle_exit.c                  |  8 +++
 arch/arm64/kvm/sys_regs.c                     | 70 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 7 files changed, 144 insertions(+), 24 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
