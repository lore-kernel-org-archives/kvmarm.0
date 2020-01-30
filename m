Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B7EC33CB3
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB7552173E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSqZF95c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB7552173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C964ACD5;
	Thu, 30 Jan 2020 08:26:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FAvjB4288DJP; Thu, 30 Jan 2020 08:26:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B7C4AC6C;
	Thu, 30 Jan 2020 08:26:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A92EB4A957
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uNfeaxy95fgx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:26:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65E464A578
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2754A206D3;
 Thu, 30 Jan 2020 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390769;
 bh=wwlEwadKKbbQ4/WckEF80j+eU2hpJMPZGA/aKsa3POQ=;
 h=From:To:Cc:Subject:Date:From;
 b=jSqZF95ckvt9gdNJuT243V8zugVLpABPUMBdW4NqpSyGGVpFU/aHtSZGYVcNPdvE8
 w5kmbUEAyxiu94L5y3jA6U7tsKcKDNnG96HWp1K4wJCTn5rvEoKOiUfEIrbyAymjIH
 vNznXx3SiApMGAXzuCuPydw82vsVIcd36oCzEO+Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9pf-002BmW-5a; Thu, 30 Jan 2020 13:26:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL 00/23] KVM/arm updates for 5.6
Date: Thu, 30 Jan 2020 13:25:35 +0000
Message-Id: <20200130132558.10201-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Andrew Murray <andrew.murray@arm.com>
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

Hi Paolo,

Please find below the pull request for KVM/arm for Linux 5.6.

No new feature this time around, but a large spectrum of interesting
fixes. I'm certainly pleased that people are focussing on these corner
cases, as some of them are pretty hard to debug. So kudos to them!

Please pull,

	M.

The following changes since commit fd6988496e79a6a4bdb514a4655d2920209eb85d:

  Linux 5.5-rc4 (2019-12-29 15:29:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.6

for you to fetch changes up to 4a267aa707953a9a73d1f5dc7f894dd9024a92be:

  KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer (2020-01-28 13:09:31 +0000)

----------------------------------------------------------------
KVM/arm updates for Linux 5.6

- Fix MMIO sign extension
- Fix HYP VA tagging on tag space exhaustion
- Fix PSTATE/CPSR handling when generating exception
- Fix MMU notifier's advertizing of young pages
- Fix poisoned page handling
- Fix PMU SW event handling
- Fix TVAL register access
- Fix AArch32 external abort injection
- Fix ITS unmapped collection handling
- Various cleanups

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer

Andrew Jones (1):
      arm64: KVM: Add UAPI notes for swapped registers

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

Eric Auger (5):
      KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
      KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
      KVM: arm64: pmu: Don't mark a counter as chained if the odd one is disabled
      KVM: arm64: pmu: Fix chained SW_INCR counters
      KVM: arm64: pmu: Only handle supported event counters

Gavin Shan (1):
      KVM: arm/arm64: Fix young bit from mmu notifier

James Morse (3):
      KVM: arm/arm64: Re-check VMA on detecting a poisoned page
      KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
      KVM: arm: Make inject_abt32() inject an external abort instead

Marc Zyngier (1):
      KVM: arm/arm64: Cleanup MMIO handling

Mark Brown (1):
      arm64: KVM: Annotate guest entry/exit as a single function

Mark Rutland (3):
      KVM: arm64: Correct PSTATE on exception entry
      KVM: arm/arm64: Correct CPSR on exception entry
      KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Russell King (1):
      arm64: kvm: Fix IDMAP overlap with HYP VA

Shannon Zhao (1):
      KVM: ARM: Call hyp_cpu_pm_exit at the right place

YueHaibing (1):
      KVM: arm: Remove duplicate include

Zenghui Yu (3):
      KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as RAZ
      KVM: arm/arm64: vgic-its: Properly check the unmapped coll in DISCARD handler
      KVM: arm/arm64: vgic: Drop the kvm_vgic_register_mmio_region()

 Documentation/virt/kvm/api.txt       |   9 +++
 arch/arm/include/asm/kvm_emulate.h   |  27 +++++++-
 arch/arm/include/asm/kvm_host.h      |  12 ++--
 arch/arm/include/asm/kvm_hyp.h       |   1 +
 arch/arm/include/asm/kvm_mmio.h      |  26 -------
 arch/arm64/include/asm/kvm_emulate.h |  40 ++++++++++-
 arch/arm64/include/asm/kvm_host.h    |  12 ++--
 arch/arm64/include/asm/kvm_mmio.h    |  29 --------
 arch/arm64/include/asm/ptrace.h      |   1 +
 arch/arm64/include/uapi/asm/kvm.h    |  12 +++-
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 arch/arm64/kvm/hyp/entry.S           |   7 +-
 arch/arm64/kvm/inject_fault.c        |  70 +++++++++++++++++--
 arch/arm64/kvm/va_layout.c           |  56 +++++++--------
 virt/kvm/arm/aarch32.c               | 131 ++++++++++++++++++++++++++++++-----
 virt/kvm/arm/arch_timer.c            |   3 +-
 virt/kvm/arm/arm.c                   |   4 +-
 virt/kvm/arm/mmio.c                  |  68 +++++++-----------
 virt/kvm/arm/mmu.c                   |  24 +++----
 virt/kvm/arm/pmu.c                   | 114 ++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic-its.c         |   6 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c     |   5 +-
 virt/kvm/arm/vgic/vgic-mmio.h        |   5 --
 23 files changed, 421 insertions(+), 242 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_mmio.h
 delete mode 100644 arch/arm64/include/asm/kvm_mmio.h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
