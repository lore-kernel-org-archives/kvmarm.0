Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78524C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC45D4B15E;
	Thu,  3 Feb 2022 12:42:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r8LiSVN2GB+f; Thu,  3 Feb 2022 12:42:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E87514B0DB;
	Thu,  3 Feb 2022 12:42:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDDC54B0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJlImozP9R1D for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:03 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 861564B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:03 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 k12-20020a92c24c000000b002bc9876bf27so2129216ilo.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=wtbaMJAcQnUO9qTorbz70eUVIMRxM9RIgak6LcFUBbE=;
 b=iWNSw66HK3xFVyVWo/nsSDvNahYyh+8iHQJGXCfl3MJyq2KHy6SMvZSRDHo7jjcsa6
 aT/A4CoJClWOCyEsZ47ZyfOsfXa3mo2Zhq3huMk2v7GZ4Gbbd61Yr1kmKtsZ6G8rtpHp
 9GhIdFPv67wk8HcMhQMhIXwyFx8eIq5z5rajhIq70WXQFf3Y0XVPvFPY44cFKQVm1Iz8
 /mEUwV2WwvfAsZKWlqtuBOZstP64tAw4+ra1wS5tfyeKHuTxxMkhb3O7Uvwa7fP0N+xg
 KMOxGB7rNY9eiz1+5dM25v5H9+y2stts4LjSN1YbGzmUAcyuAWCsKZ2d1Ot39Df9oQEf
 I5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=wtbaMJAcQnUO9qTorbz70eUVIMRxM9RIgak6LcFUBbE=;
 b=wEv3TwBJjD04SFJubcaFcvCPBvZrCkUCWEUtLCx0+DvvbXv+p/ZJlpkAFeNWop49VW
 NOPuZbBgkEQMVSGWFi1NtNk9qtfquxvGDx7UQJRujIjjC6K1eGBx1oo+ADaHgqlCUYBH
 LRA0TXWneELBZYt5jb7xr23KtPNj1bTtmmoihVkanj4stjmXKGWEFQ3oICERJSRNDmpP
 hXJBhj60f3GptM8gl7BZHB09DWk8q5UsQelbW3MGt6E/p5+apSr6uZ+UTQn/u2lhlt39
 bKgFGJmlvfaX+yoQtI51jS/KeBuR1HQiIomPnWnDYaqUpIM5yGj2yqlTUo0O9pBL7ULc
 Uqvg==
X-Gm-Message-State: AOAM5326LV31bt5zETt8nOy9DXKJU0fI13QN4pnOW7pzywBtLCQxAQGY
 QWdgD7KcVeM45Uf9OP8w4tVzWs1TAjnUVHSkCVBQPrYym02VjRdC+XctGUjVynZ7WZz0d9NOcJg
 Xnh0SNj/zcLz2qEw2e8z+SNOaaJH0P+QAQR5OT30WnOVqGtZYQbpJB801lV5qEQBeIDWrsA==
X-Google-Smtp-Source: ABdhPJyjGwifMCspxAbvAxARlfmTo1KqwjLTOFFoUnnZSSU36ffXdntHhtr3u0pDpdD2d1Wz/BXGRIOMtWM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:83c1:: with SMTP id
 j1mr18511925jah.185.1643910122833; 
 Thu, 03 Feb 2022 09:42:02 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:53 +0000
Message-Id: <20220203174159.2887882-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 0/6] KVM: arm64: Emulate the OS Lock
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

With this series a new register is exposed to userspace: OSLSR_EL1.
Since the register was not exposed to userspace before, changes to
register mutability do not have ABI breakage implications.

This series applies cleanly to 5.17-rc2. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  5 ++
 arch/arm64/include/asm/sysreg.h               |  8 ++
 arch/arm64/kvm/debug.c                        | 26 ++++++-
 arch/arm64/kvm/sys_regs.c                     | 74 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 149 insertions(+), 23 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
