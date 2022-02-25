Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3829FC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D334B9DB;
	Fri, 25 Feb 2022 09:59:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s89gMhAQvnfm; Fri, 25 Feb 2022 09:59:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4DE4BA73;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7EA4BA09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:38:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QfuW3fXJjwE8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:38:26 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 079BD4BA03
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:38:25 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 s22-20020a252d56000000b00624652ac3e1so1975766ybe.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=lRl0HjXhPu6ADawywYnArEMte7rRfDeWFMBvRkbFFjM=;
 b=S7Ke1Qrv/H2gN5bhiIKHyXO5BqKb0hR9jNRoPi0ajEBy8u9aNZorLX7Bo8H1GqHsKz
 fmsU7Ycr3ES37wkC2wy6RB2faGuLjPdcjhP8gh4qvonB2dN744jN9Qd0Y+ewhJBs0Cju
 R+RzRPi6HqMmLq5cgrFtJ/uBW110v4PhK/pKkXGUlNNCRdDA75w96ekaFpOahjt3Xht5
 ZhOZZAaYBlDdZV4/gS2FFVYdvU97vf+K3Q5mKDiKGE/BhIL+5RvDUbw1+8GJK/a1Ybe1
 Pm6mYc8xu4dhRUkcWmUWV83PwwMqz8U2so66u68ZMz4jE5XVbhlD7L5Ux4w/BE8bgAcm
 Kf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=lRl0HjXhPu6ADawywYnArEMte7rRfDeWFMBvRkbFFjM=;
 b=4J7NdO872H4K0XF9/dxNyV0d1bMaUInR0Hf6u8ua/uL5PuTLchB9SsI1EU/bShMj83
 vbrDOOaxk2X9yjwwI459ieE2wTTHYvUx8fTMi82lmjjv32T7ZlvF/Jo/Mp9Vq3kJJiso
 6mWGRos2fGGjzfdJYdqDnrFhNA/Tsrs6glnuyf5fiW64W/dGJjFZ2jen9Ztg5p9+0b7z
 oGUWkAjIHUvCdLjzYtkJBqwgjASds+tslijkAmTvTAZE7Rd5vloeC0vj0aX/NFn6Mtem
 xXCxWmEMnF2Z2XQ+Uohq2lVNDyV35N7F6iMoRQ+qlreFRLDNXNhYLAWT7yU1y9wX3WZb
 6O5w==
X-Gm-Message-State: AOAM532cea0PQcVrBXSwI46cSSXoH1Brul+4VFfX0LkiMz5n/gtctsIF
 o2Cf+dO/A0OczE26pbFSDdLcbwQIztBqDqOxGA==
X-Google-Smtp-Source: ABdhPJzT2/dEx2ZlZAx77MFqSXMTepcIZYciKpvBk468Pli5bTlecp6MbBohdSPmg6XJHm7ArsvkwmhXD6EBP+rbvA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a25:4945:0:b0:61d:546d:aedb with SMTP
 id w66-20020a254945000000b0061d546daedbmr5422061yba.147.1645760305379; Thu,
 24 Feb 2022 19:38:25 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:45 -0800
Message-Id: <20220225033548.1912117-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 0/8] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Hi all,

This is v4 of the nVHE hypervisor stack enhancements.

Previous versions can be found at:
v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

The previous cover letter has been copied below for convenience.

Thanks,
Kalesh

-----

This series is based on 5.17-rc5 and adds the following stack features to
the KVM nVHE hypervisor:

== Hyp Stack Guard Pages ==

Based on the technique used by arm64 VMAP_STACK to detect overflow.
i.e. the stack is aligned to twice its size which ensure that the 
'stack shift' bit of any valid SP is 0. The 'stack shift' bit can be
tested in the exception entry to detect overflow without corrupting GPRs.

== Hyp Stack Unwinder ==

Based on the arm64 kernel stack unwinder
(See: arch/arm64/kernel/stacktrace.c)

The unwinding and dumping of the hyp stack is not enabled by default and
depends on CONFIG_NVHE_EL2_DEBUG to avoid potential information leaks.

When CONFIG_NVHE_EL2_DEBUG is enabled the host stage 2 protection is
disabled, allowing the host to read the hypervisor stack pages and unwind
the stack from EL1. This allows us to print the hypervisor stacktrace
before panicking the host; as shown below.

Example call trace:

[   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!
[   98.918360][  T426] nVHE HYP call trace:
[   98.918692][  T426] kvm [426]: [<ffffffc009615aac>] __kvm_nvhe_cpu_prepare_nvhe_panic_info+0x4c/0x68
[   98.919545][  T426] kvm [426]: [<ffffffc0096159a4>] __kvm_nvhe_hyp_panic+0x2c/0xe8
[   98.920107][  T426] kvm [426]: [<ffffffc009615ad8>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[   98.920665][  T426] kvm [426]: [<ffffffc009610a4c>] __kvm_nvhe___kvm_hyp_host_vector+0x24c/0x794
[   98.921292][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
. . .

[   98.973382][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
[   98.973816][  T426] kvm [426]: [<ffffffc0096152f4>] __kvm_nvhe___kvm_vcpu_run+0x38/0x438
[   98.974255][  T426] kvm [426]: [<ffffffc009616f80>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c4/0x364
[   98.974719][  T426] kvm [426]: [<ffffffc009616928>] __kvm_nvhe_handle_trap+0xa8/0x130
[   98.975152][  T426] kvm [426]: [<ffffffc009610064>] __kvm_nvhe___host_exit+0x64/0x64
[   98.975588][  T426] ---- end of nVHE HYP call trace ----


Kalesh Singh (8):
  KVM: arm64: Introduce hyp_alloc_private_va_range()
  KVM: arm64: Introduce pkvm_alloc_private_va_range()
  KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
  KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
  KVM: arm64: Detect and handle hypervisor stack overflows
  KVM: arm64: Add hypervisor overflow stack
  KVM: arm64: Unwind and dump nVHE HYP stacktrace
  KVM: arm64: Symbolize the nVHE HYP backtrace

 arch/arm64/include/asm/kvm_asm.h     |  21 +++
 arch/arm64/include/asm/kvm_mmu.h     |   4 +
 arch/arm64/include/asm/stacktrace.h  |  12 ++
 arch/arm64/kernel/stacktrace.c       | 210 ++++++++++++++++++++++++---
 arch/arm64/kvm/Kconfig               |   5 +-
 arch/arm64/kvm/arm.c                 |  34 ++++-
 arch/arm64/kvm/handle_exit.c         |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  29 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |   5 +-
 arch/arm64/kvm/hyp/nvhe/mm.c         |  60 +++++---
 arch/arm64/kvm/hyp/nvhe/setup.c      |  25 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  30 +++-
 arch/arm64/kvm/mmu.c                 |  65 ++++++---
 scripts/kallsyms.c                   |   2 +-
 15 files changed, 428 insertions(+), 93 deletions(-)


base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
