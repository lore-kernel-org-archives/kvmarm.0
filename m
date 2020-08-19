Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E86C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 13:35:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D34BC204EC
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 13:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D34BC204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 668DF4B915;
	Wed, 19 Aug 2020 09:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8gomjPNbzluw; Wed, 19 Aug 2020 09:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC6D4B90C;
	Wed, 19 Aug 2020 09:35:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3B84B8FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 09:35:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6lABKLsCndB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 09:35:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4EA4B8DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 09:35:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63111396;
 Wed, 19 Aug 2020 06:35:40 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74BCC3F71F;
 Wed, 19 Aug 2020 06:35:39 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/2] irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ
 == 0
Date: Wed, 19 Aug 2020 14:36:28 +0100
Message-Id: <20200819133630.527243-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: jason@lakedaemon.net, maz@kernel.org, catalin.marinas@arm.com,
 tglx@linutronix.de, will@kernel.org
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

Trusted Firmware-A's default interrupt routing model is to clear
SCR_EL3.FIQ, which is the only case that GICv3 doesn't support. This series
tries to fix that by detecting it at runtime and using a different priority
value for ICC_PMR_EL1 when masking regular interrupts. As a result, we will
be able to support pseudo-NMIs on all combinations of GIC security states
and firmware configurations.

The series is based on v5.9-rc1, the same as the PMU NMI patches [1] which
I used for testing.

The first patch was there because when I started working on the PMU NMI
patches I found it confusing that there was no clear message stating that
NMIs were successfully enabled. The second patch is the main patch of the
series, where pseudo-NMIs are enabled even if SCR_EL3.FIQ == 0.

The are still some things I'm not 100% sure about regarding the last patch:

- From my very limited experience of trying pseudo-NMIs on 3 machines
  (rockpro64, espressobin-v5 and v7), all of them had SCR_EL3.FIQ zero.
  I tend to believe that since this is the default on TFA, this will also
  be the common case on hardware. However, when Linux is a KVM guest, the
  original set of priorities is used because GIC security is disabled.
  I erred on the side of caution and chose the original set of priorities
  as the common case.

- Most of the changes to arch_local_irq_enable() might seem pointless, but
  I chose to make them so the function looks similar to
  arch_local_irq_disable(). The generated code is identical if the static
  branch is not taken. I tried changing only arch_local_irq_disable(), but
  the enable function ended up looking strangely asymmetrical. If someone
  suggests a better way of doing things, I'd be happy to implement it.

As an aside, the set of priorities that I've added would work in all cases
if there was no need to use GIC_PRIO_PSR_I_SET, but that is a much more
intrusive change and I'm not comfortable attempting it. I'm pretty sure I
will end up breaking things really badly.

I've tested the series using PMU NMIs on the model and on espressobin-v7.
To make testing as painless as possible, I've pushed a branch [1] with
these patches cherry-picked on top of the latest PMU NMI series:

$ git clone -b pmu-nmi-v6-nmi-fiq-clear-v2 git://linux-arm.org/linux-ae

Tests that I've run:

1. On the model:
- Host with SCR_EL3.FIQ == 1 (so using the original priorities), ran
  perf record -a -- iperf3 -c 127.0.0.1 -t 30.
- On a KVM guest (security disabled, so using the original priorities),
  ran the same command as above.

2. On an espressobin-v7:
- Host with SCR_EL3.FIQ == 0 (using the priority added by the series),
  ran perf record -a -- iperf3 -c 127.0.0.1 -t 60.
- On a KVM guest (security disabled, so using the original priorities),
  ran the same command.
- Stress test for two hours with CONFIG_ARM64_DEBUG_PRIORITY_MASKING set
  for the host and guest. On the host, I ran in parallel
  perf record -a -- iperf3 -c 127.0.0.1 -t 7200  and
  perf record -ae L1-dcache-loads -a -- sleep 7200. On the guest, I ran
  the same iperf3 command as on the host.

Changes since v1:
* Rebased on top of v5.9-rc1
* Changed pmr to u64 in arch_local_irq_{enable,disable} to stop
  clang from complaining and to match local_daif_restore().

[1] http://www.linux-arm.org/git?p=linux-ae.git;a=shortlog;h=refs/heads/pmu-nmi-v6-nmi-fiq-clear-v2

Alexandru Elisei (2):
  irqchip/gicv3: Spell out when pseudo-NMIs are enabled
  irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ == 0

 arch/arm64/include/asm/arch_gicv3.h |  8 ++++-
 arch/arm64/include/asm/daifflags.h  |  4 +--
 arch/arm64/include/asm/irqflags.h   | 18 ++++++----
 arch/arm64/include/asm/ptrace.h     | 12 +++++++
 arch/arm64/kernel/entry.S           |  2 +-
 arch/arm64/kernel/image-vars.h      |  2 ++
 arch/arm64/kvm/hyp/nvhe/switch.c    |  2 +-
 drivers/irqchip/irq-gic-v3.c        | 56 +++++++++++++++++++++--------
 8 files changed, 79 insertions(+), 25 deletions(-)

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
