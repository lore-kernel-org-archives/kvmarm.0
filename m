Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AAFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE6F4BFBD;
	Thu, 24 Feb 2022 05:36:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8CtOOu2O+oHm; Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739EC4BFFE;
	Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D97384BEAD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:15:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VjQKQu8N2h2j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:15:06 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B2314BE99
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:15:06 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d07ae11460so11661237b3.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=VRP10WDdbxuQYIT1IOcNI0rSS6aawIOMCBB1XLSQkxI=;
 b=GYT8cVdbYGZDyroDPEZvq6vJikNTwDBW1778+5mVN+VE1nqSYZIh3zBtI83Ini4jgj
 756Ky/3UCYmLes/d/U5KVFihtRdDfmjziMCEDEW2f0ku69+YeHsb2HHkDW+Ub28RVl+b
 LPICnhLLfMZ+IE/PRhN971A35YNNuZveHt7YymqK2bKa2yQFiE+nz3uvxOU2r7dNnEs7
 4rCXezH2cYkWAseacLrlJvEyKcScR3ulZ9xGrp23Tjpl1P879Fp2acRPbsobDt33gqrw
 B2bwgZpivDYzkoqwZlhFKWDNZse6ucvzS5pVORIELgIbiIZHbMosGBhcb8hRxmuNaRVE
 y+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=VRP10WDdbxuQYIT1IOcNI0rSS6aawIOMCBB1XLSQkxI=;
 b=ogSq00WdXzGPrgeMvHbkHz86gJ0v93/3KRK6qT5Ok5olzx8dQeHJjkJMHqK+1DHNwZ
 llaW/ZnXqjN0X/yCVYAWxbp/DBXD0WqIEyULUmeiE4FHtp9pYzHiRaIR1/K/Fox5mbOi
 CfwMdanUlvVHGLApD97ikK+Tr8iNWQ2XXd3x8P8dj4+U3TB0K5EhpoJ8FOLF2vMpHi+5
 /+T+ES4z+BFeWLPX3tXki8eXyD9M5Z6PlebBA4qMR2ms/VRNkJECjnCJF2TC5GxEARDJ
 2UPxJQfQKzj25A49mURHRZu9chCDQbEV9vnS9LYu30w/u0tRU05ge7463ePLH+LmZR+m
 lDAw==
X-Gm-Message-State: AOAM531YaNxbFA5bnFupOUeS/w1d1UeVUtpuzFIkZtCB+DpSjeXkoPV2
 lUBjXYGQoQ/mf5A5r7HTZQXcxT3wEiuIjgmY7g==
X-Google-Smtp-Source: ABdhPJzUArkTDX/M4vDb37UTwphM2NOQLwma1KWAfIVP/V2aK4dx/IvxUZwMhGnxk0KxU4+1OmIAS8k+ilwciBnuXw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:ab74:0:b0:624:41d4:c4f0 with SMTP
 id u107-20020a25ab74000000b0062441d4c4f0mr1008577ybi.277.1645679705804; Wed,
 23 Feb 2022 21:15:05 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:35 -0800
Message-Id: <20220224051439.640768-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 0/8] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 Andrew Walbran <qwandor@google.com>, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

This is v3 of the nVHE hypervisor stack enhancements.

Previous versions can be found at:
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

The main update in this version is that the unwinder now uses the core logic
from the regular kernel stack unwinder to avoid duplicate code, per Mark; along
with fixes for the other issues identified in v2.

The previous cover letter (with updated call trace) has been copied below.

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

 arch/arm64/include/asm/kvm_asm.h     |  20 +++
 arch/arm64/include/asm/kvm_mmu.h     |   4 +
 arch/arm64/include/asm/stacktrace.h  |  12 ++
 arch/arm64/kernel/stacktrace.c       | 210 ++++++++++++++++++++++++---
 arch/arm64/kvm/Kconfig               |   5 +-
 arch/arm64/kvm/arm.c                 |  34 ++++-
 arch/arm64/kvm/handle_exit.c         |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  29 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |   5 +-
 arch/arm64/kvm/hyp/nvhe/mm.c         |  51 ++++---
 arch/arm64/kvm/hyp/nvhe/setup.c      |  25 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  30 +++-
 arch/arm64/kvm/mmu.c                 |  62 +++++---
 scripts/kallsyms.c                   |   2 +-
 15 files changed, 422 insertions(+), 86 deletions(-)


base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
