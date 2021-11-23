Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04D2C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 21:01:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 422BE4B12C;
	Tue, 23 Nov 2021 16:01:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zePLjzVGmYO5; Tue, 23 Nov 2021 16:01:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E144B11C;
	Tue, 23 Nov 2021 16:01:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CA64B10C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i340JLl3LGLT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 16:01:16 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD03F4A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:16 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 a12-20020a056602148c00b005e7052734adso127543iow.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=4Jy9ZNvtLqSyNCGaQe67LiBMWweegmq5EAtgAYXEIo8=;
 b=C6+YVcqTvJAgK9Pcl8zQs362VGJn34iwhdZwoWTiSLIHyIQO2DA/U9jsP7Bw+gdDJn
 5mPcJu8ToV4+GJTv22tFCrKLWcTpiIC5UCeUGZp9dYHBbjDP7og23OZ7gHYtceljUV37
 hcj2can/fRzWsv7caiHv5f11NX8YsrzLALvI07GD031eEIQnMU1iFKBUOtmTU4CG+sxI
 nIkOusBb6IcF7bZLrQSIOCSG2L+wMbXDDQPfYIdTXlKgXA7jBVSc/cOwNcql8WDXLKN1
 vq3PZA3BvLpGk9f30GuuFEckK0MqjOjZYjuoxSn6Uhn2ckFg3GG6oxlLPjCQ9HRb3OtD
 SAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=4Jy9ZNvtLqSyNCGaQe67LiBMWweegmq5EAtgAYXEIo8=;
 b=q4GT9APom86Qow7GG4qstJBVIIEQDjtlZj3p4Z16g0f5hQtQ+4jFj/MFthjZbwY1ks
 MQD5eaIkU0bzbq6g3I9NC4g83UtQ2yKpUgbVVCgy8dssJwkxABZISDKdfiji74nfNIDJ
 ZxpiTBjHMxvvjLExC5d88jf2MPzIiOktrQH2223OuoQr00r0b0eVgxeU+E1e7ODhA1S3
 Fd+jDKDT62iJOlkdUwgBaX1tR14HYEH5CClX+YZTV/3ch4IX8aA5DLpnJ/KEOFEC5MxK
 ZhAmLXfWIaBzbLX66HEYlSFvliXDXWOtGvO4W5bi+ay5bfe/ttxglu26pVUiFEmd9cNS
 qAXw==
X-Gm-Message-State: AOAM531XTMG4YsEL4wGYlEGv5d3uu949PLuaLOFyGSNewWJdsZavAMap
 9DUSJftdqUhVmEVFZeii8qmbXXWfhZJI3+bvcUUuY5Wde+EjwNEvO+COMXiL8RHrXvJxYRWf+FW
 s/mm4qYyahIBfCPUXVnm8eQh8ByESl/yGefRlbqM54WdJbXAKIqK+SX3S9oXLXNdniwle+A==
X-Google-Smtp-Source: ABdhPJwseHjr6oKumnq1kaHVtftmYAstQdQZxGpG32BJhANLhxR/L06sDCbf1VsVsCjLO3yQPf8BUbhcFVg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b8a:: with SMTP id
 h10mr7719477ili.14.1637701276051; Tue, 23 Nov 2021 13:01:16 -0800 (PST)
Date: Tue, 23 Nov 2021 21:01:03 +0000
Message-Id: <20211123210109.1605642-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 0/6] KVM: arm64: Emulate the OS lock
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
debug exceptions (except breakpoint instructions) from the perspective
of the guest. This is done by disabling MDE and SS in MDSCR_EL1.

The 5th patch asserts that OSLSR_EL1 is exposed by KVM to userspace
through the KVM_GET_REG_LIST ioctl. Lastly, the 6th patch asserts that
no debug exceptions are routed to the guest when the OSLK bit is set.

This series applies cleanly to 5.16-rc2. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/sysreg.h               |  6 ++
 arch/arm64/kvm/debug.c                        | 27 +++++--
 arch/arm64/kvm/sys_regs.c                     | 70 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 145 insertions(+), 23 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
