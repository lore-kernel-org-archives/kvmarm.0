Return-Path: <SRS0=3L6A=KT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E479C2B9F7
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 10:45:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B03616109F
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 10:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B03616109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DB2C4B149;
	Mon, 24 May 2021 06:45:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44iAR2NJDYif; Mon, 24 May 2021 06:45:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D49EE4A588;
	Mon, 24 May 2021 06:45:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1DE4A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 06:45:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OXOHBObYb0It for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 May 2021 06:45:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2083849DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 06:45:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F16031B;
 Mon, 24 May 2021 03:45:22 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C4403F719;
 Mon, 24 May 2021 03:45:19 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v13 0/8] MTE support for KVM guest
Date: Mon, 24 May 2021 11:45:05 +0100
Message-Id: <20210524104513.13258-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

This series adds support for using the Arm Memory Tagging Extensions
(MTE) in a KVM guest.

Changes since v12[1]:

 * Use DEFINE_SPINLOCK() to define tag_sync_lock.

 * Refactor mte_sync_tags() to take the old PTE value rather than a
   pointer to the PTE. The checks in set_pte_at() are also strengthed to
   avoid the function call when possible.

 * Fix prefix on a couple of patches ("arm64: kvm" -> "KVM: arm64").

 * Reorder arguments to sanitise_mte_tags() ("size, pfn" -> "pfn,
   size").

 * Add/improve comments in several places.

 * Report the host's sanitised version of ID_AA64PFR1_EL1:MTE rather
   than making up one for the guest.

 * Insert ISB at the end of mte_switch_to_hyp macro.

 * Drop the definition of CPU_TFSRE0_EL1 in asm-offsets.c as it isn't
   used anymore.

 * Prevent creation of 32 bit vCPUs when MTE is enabled for the guest
   (and document it).

 * Move kvm_vm_ioctl_mte_copy_tags() to guest.c.

 * Reject ZONE_DEVICE memory in kvm_vm_ioctl_mte_copy_tags() and
   correctly handle pages where PG_mte_tagged hasn't been set yet.

 * Define MTE_GRANULES_PER_PAGE rather than open coding the divison
   PAGE_SIZE / MTE_GRANULE_SIZE.

 * Correct the definition of struct kvm_arm_copy_mte_tags in the docs.
   Also avoid mentioning MTE_GRANULE_SIZE as it isn't exported to
   userspace.

[1] https://lore.kernel.org/r/20210517123239.8025-1-steven.price@arm.com/

Catalin Marinas (1):
  arm64: Handle MTE tags zeroing in __alloc_zeroed_user_highpage()

Steven Price (7):
  arm64: mte: Handle race when synchronising tags
  arm64: mte: Sync tags for pages where PTE is untagged
  KVM: arm64: Introduce MTE VM feature
  KVM: arm64: Save/restore MTE registers
  KVM: arm64: Expose KVM_ARM_CAP_MTE
  KVM: arm64: ioctl to fetch/store tags in a guest
  KVM: arm64: Document MTE capability and ioctl

 Documentation/virt/kvm/api.rst             | 52 ++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h       |  3 +
 arch/arm64/include/asm/kvm_host.h          | 12 ++++
 arch/arm64/include/asm/kvm_mte.h           | 68 +++++++++++++++++++
 arch/arm64/include/asm/mte-def.h           |  1 +
 arch/arm64/include/asm/mte.h               |  4 +-
 arch/arm64/include/asm/page.h              |  6 +-
 arch/arm64/include/asm/pgtable.h           | 22 +++++-
 arch/arm64/include/asm/sysreg.h            |  3 +-
 arch/arm64/include/uapi/asm/kvm.h          | 11 +++
 arch/arm64/kernel/asm-offsets.c            |  2 +
 arch/arm64/kernel/mte.c                    | 37 ++++++++--
 arch/arm64/kvm/arm.c                       | 16 +++++
 arch/arm64/kvm/guest.c                     | 79 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S                 |  7 ++
 arch/arm64/kvm/hyp/exception.c             |  3 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 21 ++++++
 arch/arm64/kvm/mmu.c                       | 48 ++++++++++++-
 arch/arm64/kvm/reset.c                     |  3 +-
 arch/arm64/kvm/sys_regs.c                  | 32 +++++++--
 arch/arm64/mm/fault.c                      | 21 ++++++
 include/uapi/linux/kvm.h                   |  2 +
 22 files changed, 431 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_mte.h

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
