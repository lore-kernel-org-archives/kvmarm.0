Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3774BC6FA89
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:35:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9100C4BC77;
	Wed, 14 Sep 2022 04:35:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BC7V6QZlcOm9; Wed, 14 Sep 2022 04:35:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0AA4BC2F;
	Wed, 14 Sep 2022 04:35:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E0A4BC2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyPVpgPIy+Ip for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:35:12 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3862A4BBF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:12 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D59C6B815AC;
 Wed, 14 Sep 2022 08:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90887C433D6;
 Wed, 14 Sep 2022 08:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144509;
 bh=L+kprm4Q9rYkn3m6ysBnadSuKGcDhyyXkJgXLlOpf88=;
 h=From:To:Cc:Subject:Date:From;
 b=jMwmOaZh+d+C3vCF9cOQsps6vb/1uF5qnI292JuOO2zuSzC0ULnFLWtGoW8siDYQS
 Q+95NdGQt4uxN9YnwA5VJRDfKw0ci7sLN/Vs8R5EurZXjHsseotvcpKZL5zDDEVacW
 0FahD7MwRSflzCwTvbsamwrEDkIZBy+d17mwP8oEd2zusvwlLmGHhXH1Hc8BEanqrX
 78jqaTGo5oeP77xWdgu86+dLpZSgM0yjKDMax3NfCF/88iXEhRdoDrIQyN3kDro11F
 SSRJBeta1CqfFAzt6Q3fEetJiaNwt+clilowyS6vVzVAJwafQmkt+BvkRogzI3MLXJ
 kDJwmkpLNrovw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 00/25] KVM: arm64: Introduce pKVM hyp VM and vCPU state at
 EL2
Date: Wed, 14 Sep 2022 09:34:35 +0100
Message-Id: <20220914083500.5118-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

Hi folks,

This is v3 of the series previously posted here:

  Mega-series: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
  v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/

There have been some significant changes since v2, including:

- Removal of unnecessary backpointer linking a hyp vCPU to its hyp VM in
  favour of container_of()

- Removing confusing use of 'shadow' at EL2 in favour of 'pkvm_hyp'
  (although this was much more work than a simple sed expression!)

- Simplified vm table lookup and removal of redundant table traversal

- Rework of the hypervisor fixmap to avoid redundant page-table walks

- Splitting of memory donations required to create a guest so that the
  requirement for physically-contiguous pages is reduced

- Fixed a memory leak when the stage-2 pgd is configured with an
  unsupported size

- Dropped rework of 'struct hyp_page' as it is not required by this
  series

- Improved commit messages

- Rebased onto v6.0-rc1

Oliver -- as discussed in person, I've left the owner ID enumeration
where it is for now since we will need to track the guest *instance* in
future and so consolidating this into the pgtable code is unlikely to be
beneficial.

As with the previous posting, the last patch is marked as RFC because,
although it plumbs in the shadow state, it is woefully inefficient and
copies to/from the host state on every vCPU run. Without the last patch,
the new structures are unused but we move considerably closer to
isolating guests from the host.

Cheers,

Will, Quentin, Fuad and Marc

Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>

Cc: kernel-team@android.com
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

--->8

Fuad Tabba (3):
  KVM: arm64: Add hyp_spinlock_t static initializer
  KVM: arm64: Add infrastructure to create and track pKVM instances at
    EL2
  KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from
    EL1

Quentin Perret (15):
  KVM: arm64: Move hyp refcount manipulation helpers to common header
    file
  KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
  KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
  KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Prevent the donation of no-map pages
  KVM: arm64: Add helpers to pin memory shared with the hypervisor at
    EL2
  KVM: arm64: Add per-cpu fixmap infrastructure at EL2
  KVM: arm64: Add generic hyp_memcache helpers
  KVM: arm64: Consolidate stage-2 initialisation into a single function
  KVM: arm64: Instantiate guest stage-2 page-tables at EL2
  KVM: arm64: Return guest memory from EL2 via dedicated teardown
    memcache
  KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
  KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
  KVM: arm64: Don't unnecessarily map host kernel sections at EL2

Will Deacon (7):
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Rename 'host_kvm' to 'host_mmu'
  KVM: arm64: Initialise hypervisor copies of host symbols
    unconditionally
  KVM: arm64: Provide I-cache invalidation by virtual address at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_asm.h              |   7 +-
 arch/arm64/include/asm/kvm_host.h             |  73 ++-
 arch/arm64/include/asm/kvm_hyp.h              |   3 +
 arch/arm64/include/asm/kvm_mmu.h              |   2 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  20 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  61 ++-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  23 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  74 +++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 110 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 502 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 158 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  28 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 444 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/mmu.c                          |  55 +-
 arch/arm64/kvm/pkvm.c                         | 138 ++++-
 arch/arm64/kvm/reset.c                        |  29 -
 27 files changed, 1752 insertions(+), 216 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
