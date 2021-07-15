Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D464C47E48
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7461613F6
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7461613F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BEB14B08F;
	Thu, 15 Jul 2021 12:32:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TCTyokYtcsu1; Thu, 15 Jul 2021 12:32:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14CF4B0C1;
	Thu, 15 Jul 2021 12:32:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58E044B08F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nx6i1E6OaJ15 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 12:32:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15AE14B08C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7F3D5613F0;
 Thu, 15 Jul 2021 16:32:16 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m44HW-00DYjr-Jf; Thu, 15 Jul 2021 17:32:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] KVM: arm64: MMIO guard PV services
Date: Thu, 15 Jul 2021 17:31:43 +0100
Message-Id: <20210715163159.1480168-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

KVM/arm64 currently considers that any memory access outside of a
memslot is a MMIO access. This so far has served us very well, but
obviously relies on the guest trusting the host, and especially
userspace to do the right thing.

As we keep on hacking away at pKVM, it becomes obvious that this trust
model is not really fit for a confidential computing environment, and
that the guest would require some guarantees that emulation only
occurs on portions of the address space that have clearly been
identified for this purpose.

This series aims at providing the two sides of the above coin:

- a set of PV services (collectively called 'MMIO guard' -- better
  name required!) where the guest can flag portion of its address
  space that it considers as MMIO, with map/unmap semantics. Any
  attempt to access a MMIO range outside of these regions will result
  in an external abort being injected.

- a set of hooks into the ioremap code allowing a Linux guest to tell
  KVM about things it want to consider as MMIO. I definitely hate this
  part of the series, as it feels clumsy and brittle.

For now, the enrolment in this scheme is controlled by a guest kernel
command-line parameters, but it is expected that KVM will enforce this
for protected VMs.

Note that this crucially misses a save/restore interface for non
protected VMs, and I currently don't have a good solution for
that. Ideas welcome.

I also plan to use this series as a base for some other purposes,
namely to trick the guest in telling us how it maps things like
prefetchable BARs (see the discussion at [1]). That part is not
implemented yet, but there is already some provision to pass the MAIR
index across.

Patches on top of 5.14-rc1, branch pushed at the usual location.

[1] 20210429162906.32742-1-sdonthineni@nvidia.com

Marc Zyngier (16):
  KVM: arm64: Generalise VM features into a set of flags
  KVM: arm64: Don't issue CMOs when the physical address is invalid
  KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
    kvm_pgtable_stage2_annotate
  KVM: arm64: Add MMIO checking infrastructure
  KVM: arm64: Plumb MMIO checking into the fault handling
  KVM: arm64: Force a full unmap on vpcu reinit
  KVM: arm64: Wire MMIO guard hypercalls
  KVM: arm64: Add tracepoint for failed MMIO guard check
  KVM: arm64: Advertise a capability for MMIO guard
  KVM: arm64: Add some documentation for the MMIO guard feature
  firmware/smccc: Call arch-specific hook on discovering KVM services
  mm/ioremap: Add arch-specific callbacks on ioremap/iounmap calls
  arm64: Implement ioremap/iounmap hooks calling into KVM's MMIO guard
  arm64: Enroll into KVM's MMIO guard if required
  arm64: Add a helper to retrieve the PTE of a fixmap
  arm64: Register earlycon fixmap with the MMIO guard

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/mmio-guard.rst     |  73 +++++++++++
 arch/arm/include/asm/hypervisor.h             |   1 +
 arch/arm64/include/asm/fixmap.h               |   2 +
 arch/arm64/include/asm/hypervisor.h           |   2 +
 arch/arm64/include/asm/kvm_host.h             |  14 ++-
 arch/arm64/include/asm/kvm_mmu.h              |   5 +
 arch/arm64/include/asm/kvm_pgtable.h          |  12 +-
 arch/arm64/kernel/setup.c                     |   6 +
 arch/arm64/kvm/arm.c                          |  14 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  14 ++-
 arch/arm64/kvm/hyp/pgtable.c                  |  36 +++---
 arch/arm64/kvm/hypercalls.c                   |  20 +++
 arch/arm64/kvm/mmio.c                         |  13 +-
 arch/arm64/kvm/mmu.c                          | 117 ++++++++++++++++++
 arch/arm64/kvm/trace_arm.h                    |  17 +++
 arch/arm64/mm/ioremap.c                       | 107 ++++++++++++++++
 arch/arm64/mm/mmu.c                           |  15 +++
 drivers/firmware/smccc/kvm_guest.c            |   4 +
 include/linux/arm-smccc.h                     |  28 +++++
 include/linux/io.h                            |   3 +
 include/uapi/linux/kvm.h                      |   1 +
 mm/ioremap.c                                  |  13 +-
 mm/vmalloc.c                                  |   8 ++
 25 files changed, 492 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
