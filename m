Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894573A7F69
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721851; cv=none; b=kLbezKYsxLu0eAp49VeueuanCv4BDN42Tpu/sdNd2Gvzu2oOwLsTZVrpFN8bBRr+yaMvGkPkMXJNDxH+jg+zmwr2WqOaWFlOT5SwRt5yBrqnnvAt8GIK/uOSeD9PmRYs5mSzIE1GI7/Q3gKiM4SpuhRagtYSzSaOzzlNRJQ0T3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721851; c=relaxed/simple;
	bh=zj5O77Zgn/c++dmVJ4vIAhB3cuZM1BJ9GuJz7VIPinM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aOuAQCF0On/CARbuEPlb3u8O7kWiW90pUW9W3zZUz/7Wkm/Pd/kLRqPokLnGsRYeNrrjRluxlKYnO7UHlNNZOlcJbkmL5lSmiDp9kbQCXUMutZFdLvAhlF0sde4hG0jewtmoVaOh9Qzm7sazQO+E4eRoxjgAksyloZpuDsNTcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTucp+7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTucp+7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4F0C116C6;
	Thu,  5 Mar 2026 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721851;
	bh=zj5O77Zgn/c++dmVJ4vIAhB3cuZM1BJ9GuJz7VIPinM=;
	h=From:To:Cc:Subject:Date:From;
	b=QTucp+7piv3l0dwxPWM4SKEldRXopu+sXLDNT9L/JLB4wdYvYrUO0bOfVUA+83Ut6
	 3hPTdeKuvn3rQNwe9xiQyH7b5USGa7OoEJ7l+2+LDM7CIRxhKHEaDlC30ynAxTdXu9
	 odAEda4jWGPgG7QyxAgoNGKJ85VA6Dl2TZuAEKfDvDqL8cDbvwCEUDg+/Bb+eAnE7n
	 7d4twdBqHRX1TWs1iYY2Gth55FxJwxdd00Xk/Oi0y79MH8Gw2AoVIEnGIJeshZDjBz
	 2J7wduTX8rIxz6/PJMBF5OY5gMdvwiuDcKm0BcqQnM69JHT0lDp1CIlvoO7P1QZyXX
	 rzdZm1aXffRxg==
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
Subject: [PATCH v3 00/36] KVM: arm64: Add support for protected guest memory with pKVM
Date: Thu,  5 Mar 2026 14:43:13 +0000
Message-ID: <20260305144351.17071-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi everyone,

Here's v3 of the patches previously posted here:

  v1: https://lore.kernel.org/kvmarm/20260105154939.11041-1-will@kernel.org/
  v2: https://lore.kernel.org/kvmarm/20260119124629.2563-1-will@kernel.org/

Changes since v2 include:

  * Rebased onto v7.0-rc2
  * Rework of the way that exceptions are injected into the host,
    building on top of Fuad's work that landed in the recent merge
    window.
  * Some renaming and comment additions.

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

Will Deacon (34):
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

 .../admin-guide/kernel-parameters.txt         |   4 +-
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 103 +++
 arch/arm64/include/asm/kvm_asm.h              |  31 +-
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  45 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   4 +-
 arch/arm64/include/asm/virt.h                 |   9 +
 arch/arm64/kvm/Kconfig                        |  10 +
 arch/arm64/kvm/arm.c                          |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  12 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 184 +++---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 585 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 224 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/pgtable.c                  |  33 +-
 arch/arm64/kvm/mmu.c                          | 114 +++-
 arch/arm64/kvm/pkvm.c                         | 154 ++++-
 arch/arm64/mm/fault.c                         |  33 +-
 include/uapi/linux/kvm.h                      |   5 +
 24 files changed, 1374 insertions(+), 225 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

-- 
2.53.0.473.g4a7958ca14-goog

