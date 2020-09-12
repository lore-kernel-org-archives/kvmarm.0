Return-Path: <SRS0=P1KX=CV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4008FC43461
	for <kvmarm@archiver.kernel.org>; Sat, 12 Sep 2020 15:36:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E6ED207C3
	for <kvmarm@archiver.kernel.org>; Sat, 12 Sep 2020 15:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E6ED207C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD934B368;
	Sat, 12 Sep 2020 11:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IC2Zmwpu6hAH; Sat, 12 Sep 2020 11:36:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7784B5BB;
	Sat, 12 Sep 2020 11:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 886464B4E9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Sep 2020 11:36:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eyyNFenOElfw for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Sep 2020 11:36:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DED54B368
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Sep 2020 11:36:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ABD0D6E;
 Sat, 12 Sep 2020 08:36:09 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.8.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CABF93F68F;
 Sat, 12 Sep 2020 08:36:07 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 0/2] irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ
 == 0
Date: Sat, 12 Sep 2020 16:37:05 +0100
Message-Id: <20200912153707.667731-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: maz@kernel.org, tglx@linutronix.de, will@kernel.org, jason@lakedaemon.net,
 catalin.marinas@arm.com
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

The first patch was there because when I started working on the PMU NMI
patches I found it confusing that there was no clear message stating that
NMIs were successfully enabled. The second patch is the main patch of the
series, where pseudo-NMIs are enabled even if SCR_EL3.FIQ == 0.

As an aside, the set of priorities that I've added would work in all cases
if there was no need to use GIC_PRIO_PSR_I_SET, but that is a much more
intrusive change and I'm not comfortable attempting it. I'm pretty sure I
will end up breaking things really badly.

I've tested the series using PMU NMIs [1], rebased on top of v5.9-rc4, on
the model and on espressobin-v7. Tests that I've run:

1. On the model:
- Host with SCR_EL3.FIQ == 1 (so using the original priorities), ran
  perf record -a -- iperf3 -c 127.0.0.1 -t 30.
- On a KVM guest (security disabled, so using the original priorities),
  ran the same command.

2. On an espressobin-v7:
- Host with SCR_EL3.FIQ == 0 (using the priority added by the series),
  ran perf record -a -- iperf3 -c 127.0.0.1 -t 60.
- On a KVM guest (security disabled, so using the original priorities),
  ran the same command.
- Stress test for one hour with CONFIG_ARM64_DEBUG_PRIORITY_MASKING set
  for the host and guest. On the host, I ran in parallel
  perf record -a -- iperf3 -c 127.0.0.1 -t 3600  and
  perf record -ae L1-dcache-loads -a -- sleep 3600. On the guest, I ran
  the same iperf3 command as on the host.

Changes since v2:
* Renamed gic_prio_irqoff() -> GIC_PRIO_IRQOFF, thus avoiding any changes
  to daifflags.h and irqflags.h, as per Marc's excellent suggestion.
* Added comment gic_cpu_sys_reg_init() explaining why we cannot get the
  warning on the boot CPU.

Changes since v1:
* Rebased on top of v5.9-rc1
* Changed pmr to u64 in arch_local_irq_{enable,disable} to stop
  clang from complaining and to match local_daif_restore().

[1] https://lkml.org/lkml/2020/8/19/671

Alexandru Elisei (2):
  irqchip/gicv3: Spell out when pseudo-NMIs are enabled
  irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ == 0

 arch/arm64/include/asm/arch_gicv3.h |  8 +++-
 arch/arm64/include/asm/ptrace.h     | 14 ++++++-
 arch/arm64/kernel/image-vars.h      |  2 +
 drivers/irqchip/irq-gic-v3.c        | 60 ++++++++++++++++++++++-------
 4 files changed, 68 insertions(+), 16 deletions(-)

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
