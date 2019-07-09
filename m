Return-Path: <SRS0=/6PO=VG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70293C73C44
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 12:25:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 038DC21707
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 12:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 038DC21707
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 640114A541;
	Tue,  9 Jul 2019 08:25:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k7K3JS2X6jyU; Tue,  9 Jul 2019 08:25:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4784A53E;
	Tue,  9 Jul 2019 08:25:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF464A53D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 08:25:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HeJLwB7GCdCk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jul 2019 08:25:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B48644A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 08:25:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29AE52B;
 Tue,  9 Jul 2019 05:25:20 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CA153F59C;
 Tue,  9 Jul 2019 05:25:18 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [GIT PULL] KVM/arm updates for Linux 5.3
Date: Tue,  9 Jul 2019 13:24:49 +0100
Message-Id: <20190709122507.214494-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, Steven Price <steven.price@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

Radim, Paolo,

This is the (slightly delayed) KVM/arm updates for 5.3. This time
around, some PMU emulation improvements, the ability to save/restore
the Spectre mitigation state, better SError handling that double as
the workaround for a N1 erratum, a 32bit fix for a corrupted MPIDR,
and yet another pre-NV cleanup.

Please pull,

	M.

The following changes since commit 4b972a01a7da614b4796475f933094751a295a2f:

  Linux 5.2-rc6 (2019-06-22 16:01:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-5.3

for you to fetch changes up to 1e0cf16cdad1ba53e9eeee8746fe57de42f20c97:

  KVM: arm/arm64: Initialise host's MPIDRs by reading the actual register (2019-07-08 16:29:48 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.3

- Add support for chained PMU counters in guests
- Improve SError handling
- Handle Neoverse N1 erratum #1349291
- Allow side-channel mitigation status to be migrated
- Standardise most AArch64 system register accesses to msr_s/mrs_s
- Fix host MPIDR corruption on 32bit

----------------------------------------------------------------
Andre Przywara (3):
      arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests
      KVM: arm/arm64: Add save/restore support for firmware workaround state
      KVM: doc: Add API documentation on the KVM_REG_ARM_WORKAROUNDS register

Andrew Murray (5):
      KVM: arm/arm64: Rename kvm_pmu_{enable/disable}_counter functions
      KVM: arm/arm64: Extract duplicated code to own function
      KVM: arm/arm64: Re-create event when setting counter value
      KVM: arm/arm64: Remove pmc->bitmask
      KVM: arm/arm64: Support chained PMU counters

Dave Martin (1):
      KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s

James Morse (8):
      arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS
      KVM: arm64: Abstract the size of the HYP vectors pre-amble
      KVM: arm64: Make indirect vectors preamble behaviour symmetric
      KVM: arm64: Consume pending SError as early as possible
      KVM: arm64: Defer guest entry when an asynchronous exception is pending
      arm64: Update silicon-errata.txt for Neoverse-N1 #1349291
      KVM: arm64: Re-mask SError after the one instruction window
      KVM: arm64: Skip more of the SError vaxorcism

Marc Zyngier (1):
      KVM: arm/arm64: Initialise host's MPIDRs by reading the actual register

 Documentation/arm64/silicon-errata.txt   |   1 +
 Documentation/virtual/kvm/arm/psci.txt   |  31 +++
 arch/arm/include/asm/kvm_emulate.h       |  10 +
 arch/arm/include/asm/kvm_host.h          |  18 +-
 arch/arm/include/asm/kvm_hyp.h           |  13 +-
 arch/arm/include/uapi/asm/kvm.h          |  12 ++
 arch/arm64/include/asm/assembler.h       |   4 +
 arch/arm64/include/asm/cpufeature.h      |   6 +
 arch/arm64/include/asm/kvm_asm.h         |   6 +
 arch/arm64/include/asm/kvm_emulate.h     |  30 ++-
 arch/arm64/include/asm/kvm_host.h        |  23 +-
 arch/arm64/include/asm/kvm_hyp.h         |  50 +----
 arch/arm64/include/asm/sysreg.h          |  35 +++-
 arch/arm64/include/uapi/asm/kvm.h        |  10 +
 arch/arm64/kernel/cpu_errata.c           |  23 +-
 arch/arm64/kernel/traps.c                |   4 +
 arch/arm64/kvm/hyp/entry.S               |  36 +++-
 arch/arm64/kvm/hyp/hyp-entry.S           |  30 ++-
 arch/arm64/kvm/hyp/switch.c              |  14 +-
 arch/arm64/kvm/hyp/sysreg-sr.c           |  78 +++----
 arch/arm64/kvm/hyp/tlb.c                 |  12 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/regmap.c                  |   4 +-
 arch/arm64/kvm/sys_regs.c                |  60 +++---
 arch/arm64/kvm/va_layout.c               |   7 +-
 include/kvm/arm_pmu.h                    |  11 +-
 virt/kvm/arm/arch_timer.c                |  24 +--
 virt/kvm/arm/arm.c                       |   3 +-
 virt/kvm/arm/pmu.c                       | 350 +++++++++++++++++++++++++------
 virt/kvm/arm/psci.c                      | 149 +++++++++++--
 30 files changed, 775 insertions(+), 281 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
