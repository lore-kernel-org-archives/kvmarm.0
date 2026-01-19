Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762935EDBA
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826813; cv=none; b=W1WO9MafCDBp+Qtq3/UOLyGjXMsTrAHe4uN9b+OZBRktyR4Gi1kNk+EWVP3NGr9nSNAYYM2XECXlWW3ze9xh4Rr/PYm1z6VihvnF+/IvmtWUwweniZPTClsgq/QLLwgEHaMe0iVef2em3G7eynGr1jlWX6sR/IgmH3tBZHjSk7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826813; c=relaxed/simple;
	bh=YJ9e/R24mcZ6mGK1DihOlExa+pPF4aCUH5QlK/D4yPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+ORaObis9rB1FP1yG79x4dBODX/LoWsg5+4i3KWqWe/KEMCDWpwytNaKoi/2TSgSp66O2AHPHgY97PyfN27XQeP43nVG/T4TiqSvyqn4ZLYYTczFqAw0msnWu4Ik/1rvbxgN6IK8vsBuDlPT+Up53X270iix/5kHQbyyFyet1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzJoVJs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzJoVJs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8E8C116C6;
	Mon, 19 Jan 2026 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826813;
	bh=YJ9e/R24mcZ6mGK1DihOlExa+pPF4aCUH5QlK/D4yPA=;
	h=From:To:Cc:Subject:Date:From;
	b=bzJoVJs4+Lai5ii+QpmQH2AnEboNDuMEW6z1pXg0DoOfY9/LkjYPjDAJpbD7Ok6y5
	 K0GKXBsJx7D0SW6ewUvxDh4M6ZkUIBP3Kf/mtzy/0tkmiq1qgfKV6BXUJAODW7VIrc
	 WYVn7dAQERvEXDvhqxKD4PKw1Rh1rzOgWbw9W/oW6U3Ckeo6RgOOL/LCKLo8d3JtD8
	 7C96PLv0rHi8Khypx+/W5DfEQ3IrOMz3G1M8GPm+VPccVlLpxFj1YeORwU1kiwGi0w
	 mX+oalBQJQNM+xuOqxqnuktImP5swhoXNYq3O/kcaqxlgWvjID1BlpWXvCzLEFTwDh
	 JCPYbztIsAqSQ==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 00/35] KVM: arm64: Add support for protected guest memory with pKVM
Date: Mon, 19 Jan 2026 12:45:53 +0000
Message-ID: <20260119124629.2563-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

It's back and it's even bigger than before!

Although the first patch has been picked up as a fix (thanks, Oliver),
review feedback has resulted in some additional patches being included
in the series. If you'd like to see the first version, it's available
here:

  https://lore.kernel.org/kvmarm/20260105154939.11041-1-will@kernel.org/

Changes since v1 include:

  * Change hypercall order so that pKVM-specific calls are in their own
    range
  * Make 'pkvm_handle_t' a u16 and check its size at compile-time
  * Rework pte annotations to take a 4-bit type field
  * Fix a memory leak on the kvm_arch_init_vm() failure path
  * Pass KVM_PGTABLE_WALK_IGNORE_EAGAIN when mapping into the host idmap
  * Avoid host annotation when reclaiming guest pages
  * Re-instate guest pte metadata when unsharing a page
  * Extend selftests to cover guest share and unshare hypercalls
  * Drop broken MMU notifier changes
  * Documentation tweaks

As before, patches are based on v6.19-rc4 and are also available at:

  https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory

All feedback welcome.

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

--->8

Fuad Tabba (1):
  KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected
    guests

Quentin Perret (2):
  KVM: arm64: Refactor enter_exception64()
  KVM: arm64: Inject SIGSEGV on illegal accesses

Will Deacon (32):
  KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
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

 .../admin-guide/kernel-parameters.txt         |   4 +-
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 103 +++
 arch/arm64/include/asm/kvm_asm.h              |  27 +-
 arch/arm64/include/asm/kvm_emulate.h          |   5 +
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  51 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   4 +-
 arch/arm64/include/asm/virt.h                 |   6 +
 arch/arm64/kvm/Kconfig                        |  10 +
 arch/arm64/kvm/arm.c                          |  12 +-
 arch/arm64/kvm/hyp/exception.c                | 100 +--
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   6 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 125 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 595 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 224 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/pgtable.c                  |  38 +-
 arch/arm64/kvm/mmu.c                          | 122 +++-
 arch/arm64/kvm/pkvm.c                         | 149 ++++-
 arch/arm64/mm/fault.c                         |  31 +-
 include/uapi/linux/kvm.h                      |   5 +
 25 files changed, 1405 insertions(+), 247 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

-- 
2.52.0.457.g6b5491de43-goog

