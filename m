Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966572FD681
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882131; cv=none; b=QoesOBuMBsTthTJZ55LYIVJ558HbY2HnELRGpaKAK7easwGPDtba+WyIcIoOazlggyKNRBrlywr9nO0FJDsWmnabfnFE02/Tw9znT/NcJAPTTqFs4GKeYSwMTHDqqLbqshbzcLZQK8gEtNQ/9ZUET4r3WpiAIV0qcSdHGodE1rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882131; c=relaxed/simple;
	bh=NrRyOsVjOHoPrL6iv8tTnDhamv18Yc2Yh+BKq0iPw3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udKXTyTKShtiBvfoVqYD9DSYrgMbSQ0AAaA14+m+GcnKCRCBi9aXNi9z9L5cjZpiGHKXo+Xy69sQ6E+afkrjpQsE8dZ0t6jAIA1MlRfpB2jlIIk768rjhVdvPjss4pjLioDpPY3Tz7curUImgf27VJJNtviH/pKiiV8tF5b9kHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDxJphnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDxJphnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B0C19423;
	Mon, 30 Mar 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882131;
	bh=NrRyOsVjOHoPrL6iv8tTnDhamv18Yc2Yh+BKq0iPw3U=;
	h=From:To:Cc:Subject:Date:From;
	b=LDxJphnhxDQ5+QBR7ZVz8YElpXuAciEF0HNA0S07NRqfPJZwjcUdiFikuehe7g4v9
	 wiDGQNMNure4FJ2+nNTkueMMiE9zWLi4B2IQkLY+RfBRvoOLwbgKsRyPRgT8My54Y0
	 Cdl0vPZnqYJ4GRApfSTf08rwQHYmGbRdX9iTr9kXfSXFPVjMkw8+w5lJPL3pyOYavL
	 JaAXJ5+s/ZsJMVTRj4+UpFR99B9eprLPFp128g2ZDsIILCKnKB/pIPED4u7TRMeiuI
	 rpu8QpDQntLjFsFha+zEqBN5MSk8R/wxEWP9uNrRcYtWhES29+cocdlU0jzAhnHzhd
	 Cx2To5/C5dBbQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 00/38] KVM: arm64: Add support for protected guest memory with pKVM
Date: Mon, 30 Mar 2026 15:48:01 +0100
Message-ID: <20260330144841.26181-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi everyone,

As promised on Friday, here's v5 of the pKVM protected memory patches
previously posted here:

  v1: https://lore.kernel.org/kvmarm/20260105154939.11041-1-will@kernel.org/
  v2: https://lore.kernel.org/kvmarm/20260119124629.2563-1-will@kernel.org/
  v3: https://lore.kernel.org/r/20260305144351.17071-1-will@kernel.org
  v4: https://lore.kernel.org/r/20260327140039.21228-1-will@kernel.org

This version primarily addresses the comments from Sashiko that I think
are valid:

  * Mask out page offset from physical address passed to "force reclaim"
    hypercall.
  * Check for 'is_dying' in get_pkvm_hyp_vm() to prevent taking a
    reference on a VM in the process of being destroyed.
  * Take the 'slots_lock' while creating the hyp vm to avoid racing with
    check in kvm_arch_prepare_memory_region().
  * Keep trying to reclaim pages from a dying guest if we fail part-way
    through.
  * Fix return value from pkvm_pgtable_stage2_test_clear_young() if it's
    unexpectedly called for a pVM.

As before, I've pushed an updated branch with this series:

  https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory

and the kvmtool patches are available at:

  https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>

--->8

Fuad Tabba (1):
  KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected
    guests

Quentin Perret (1):
  KVM: arm64: Inject SIGSEGV on illegal accesses

Will Deacon (36):
  KVM: arm64: Remove unused PKVM_ID_FFA definition
  KVM: arm64: Don't leak stage-2 page-table if VM fails to init under
    pKVM
  KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
  KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
  KVM: arm64: Don't advertise unsupported features for protected guests
  KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
  KVM: arm64: Ignore MMU notifier callbacks for protected VMs
  KVM: arm64: Prevent unsupported memslot operations on protected VMs
  KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
  KVM: arm64: Split teardown hypercall into two phases
  KVM: arm64: Introduce __pkvm_host_donate_guest()
  KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
  KVM: arm64: Handle aborts from protected VMs
  KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
  KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
  KVM: arm64: Factor out pKVM host exception injection logic
  KVM: arm64: Support translation faults in inject_host_exception()
  KVM: arm64: Avoid pointless annotation when mapping host-owned pages
  KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
  KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
  KVM: arm64: Change 'pkvm_handle_t' to u16
  KVM: arm64: Annotate guest donations with handle and gfn in host
    stage-2
  KVM: arm64: Introduce hypercall to force reclaim of a protected page
  KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
  KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
  KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
  KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs
  KVM: arm64: Implement the MEM_UNSHARE hypercall for protected VMs
  KVM: arm64: Allow userspace to create protected VMs when pKVM is
    enabled
  KVM: arm64: Add some initial documentation for pKVM
  KVM: arm64: Extend pKVM page ownership selftests to cover guest
    donation
  KVM: arm64: Register 'selftest_vm' in the VM table
  KVM: arm64: Extend pKVM page ownership selftests to cover forced
    reclaim
  KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
  KVM: arm64: Rename PKVM_PAGE_STATE_MASK
  drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL

 .../admin-guide/kernel-parameters.txt         |   4 +-
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 106 ++++
 arch/arm64/include/asm/kvm_asm.h              |  31 +-
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  45 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   4 +-
 arch/arm64/include/asm/virt.h                 |   9 +
 arch/arm64/kvm/arm.c                          |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  10 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 184 +++---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 587 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 232 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/pgtable.c                  |  33 +-
 arch/arm64/kvm/mmu.c                          | 114 +++-
 arch/arm64/kvm/pkvm.c                         | 157 ++++-
 arch/arm64/mm/fault.c                         |  33 +-
 drivers/virt/coco/pkvm-guest/Kconfig          |   2 +-
 include/uapi/linux/kvm.h                      |   5 +
 24 files changed, 1380 insertions(+), 228 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

-- 
2.53.0.1018.g2bb0e51243-goog

