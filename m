Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C38C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30674611F0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 30674611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9DE14B2B4;
	Mon,  4 Oct 2021 13:49:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9bym5WHCyKv9; Mon,  4 Oct 2021 13:49:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 272C94B2D6;
	Mon,  4 Oct 2021 13:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67ABD4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zb8qU0EcvoZL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:49:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBCD64B262
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D3F2F61154;
 Mon,  4 Oct 2021 17:49:00 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5C-00EhBv-PZ; Mon, 04 Oct 2021 18:48:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/16]  KVM: arm64: MMIO guard PV services
Date: Mon,  4 Oct 2021 18:48:33 +0100
Message-Id: <20211004174849.2831548-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com,
 tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Steven Price <steven.price@arm.com>,
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

This is the second version of this series initially posted at [1] that
aims at letting a guest express what it considers as MMIO, and only
let this through to userspace. Together with the guest memory made
(mostly) inaccessible to the host kernel and userspace, this allows an
implementation of a hardened IO subsystem.

A lot has been fixed/revamped/improved since the initial posting,
although I am still not pleased with the ioremap plugging on the guest
side. I'll take any idea to get rid of it!

The series is based on 5.15-rc3.

[1] https://lore.kernel.org/kvmarm/20210715163159.1480168-1-maz@kernel.org

Marc Zyngier (16):
  KVM: arm64: Generalise VM features into a set of flags
  KVM: arm64: Check for PTE valitity when checking for
    executable/cacheable
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
  mm/vmalloc: Add arch-specific callbacks to track io{remap,unmap}
    physical pages
  arm64: Implement ioremap/iounmap hooks calling into KVM's MMIO guard
  arm64: Enroll into KVM's MMIO guard if required
  arm64: Add a helper to retrieve the PTE of a fixmap
  arm64: Register earlycon fixmap with the MMIO guard

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/mmio-guard.rst     |  74 ++++++++
 arch/arm/include/asm/hypervisor.h             |   1 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/fixmap.h               |   2 +
 arch/arm64/include/asm/hypervisor.h           |   2 +
 arch/arm64/include/asm/kvm_host.h             |  14 +-
 arch/arm64/include/asm/kvm_mmu.h              |   5 +
 arch/arm64/include/asm/kvm_pgtable.h          |  12 +-
 arch/arm64/kernel/setup.c                     |   6 +
 arch/arm64/kvm/arm.c                          |  30 ++--
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  11 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  29 ++--
 arch/arm64/kvm/hypercalls.c                   |  38 ++++
 arch/arm64/kvm/mmio.c                         |  20 ++-
 arch/arm64/kvm/mmu.c                          | 111 ++++++++++++
 arch/arm64/kvm/psci.c                         |   8 +
 arch/arm64/kvm/trace_arm.h                    |  17 ++
 arch/arm64/mm/ioremap.c                       | 162 ++++++++++++++++++
 arch/arm64/mm/mmu.c                           |  15 ++
 drivers/firmware/smccc/kvm_guest.c            |   4 +
 include/linux/arm-smccc.h                     |  28 +++
 include/linux/io.h                            |   2 +
 include/uapi/linux/kvm.h                      |   1 +
 mm/Kconfig                                    |   5 +
 mm/vmalloc.c                                  |  12 +-
 29 files changed, 575 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
