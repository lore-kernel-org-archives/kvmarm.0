Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C9C63DD
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 06:57:58 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58FCE1FB;
	Sun, 17 Sep 2023 23:58:29 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 538463F5A1;
	Sun, 17 Sep 2023 23:57:50 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 00/13] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Date: Mon, 18 Sep 2023 07:57:27 +0100
Message-Id: <20230918065740.3670662-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

This adds support for FEAT_LPA2 to KVM for both hypervisor stage 1 (for the
nvhe/protected modes) and the vm stage 2 translation tables (for all modes).
FEAT_LPA2 enables 52 bit PAs and VAs for 4KB and 16KB granules (note this is
already supported for 64KB granules via the FEAT_LPA and FEAT_LVA extensions).
The series does not include support for FEAT_LPA2 in the kernel stage 1. This
support is provided separately by Ard Biesheuvel's series at [3]. The two series
are mostly independent.

I saw Ard just posted his series rebased onto v6.6-rc1 so thought I would do the
same, to avoid bit rot; These patches are based on top of v6.6-rc1.

NOTE: I've included my patch to update the range-based tlbi functions to work
with LPA2 in this version, because KVM has started using range-based tlbi
invalidation as of v6.6-rc1. I've done this in such a way that KVM-originated
calls will use the LPA2 format if LPA2 is in use by KVM, but the
kernel-originated calls are hardcoded to never use the LPA2 format. If merging
with Ard's series, you will need to update the 2 calls to __flush_tlb_range_op()
from __flush_tlb_range() appropriately.


Testing
-------

Testing has been done exclusively on the FVP and covers my boot matrix tests
and kvm selftests.

The host/guest config boot matrix gives the same (expected) results as for the
v2 submission; of 180 conifgs, 12 fail, and these are all due to attempting to
load the host kernel into high memory which isn't expected to work until the
kernel has FEAT_LPA2 support for its stage 1. (refer to v1 posting for details
on the exact configs).

KVM selftests have been enhanced to support P52V48 4K and 16K guest modes, and
all tests have been run against a P48V48_4K host and a P52V52_4K host (a run
takes about 10 hours on FVP, sigh, but I can test a few more host configs if
useful). All tests pass except "memslot_perf_test", which fails due to a timeout
while syncing. This test fails in the same way for plain v6.6-rc1, so I'm
confident this is not a regression caused by this series. (the issue is that
alarm(2) is issued and the signal is received before alarm(0) is issued. I
expect this is an FVP-time related problem, although I'm not sure how to fix
robustly for the FVP without potentially hanging real systems for long periods
of time).


Changes since v2 [2]
--------------------

 - rebased onto v6.6-rc1
 - removed small amount of dead code eroneously introduced by previous rebase
 - reworked range-based tlbi to work with LPA2 (KVM has started using
   range-based tlbi as of v6.6-rc1)


Changes since v1 [1]
--------------------

 - Create CPU feature for LPA2 (enabled if both S1 and S2 report LPA2 support).
 - Use the CPU feature (and therefore code patching) to globally decide whether
   or not to use LPA2 PTE format; no more per-pgtable flag to pass around.
 - Removed the range-based TLBI changes, which are not required by KVM; leaves
   only minor changes to the non-range-based invalidation code.
 - Removed patch to encode/decode VTCR_EL2.SL2, and replaced with a comment
   describing why we never need to touch SL2 (stage 2 always uses concatenated
   first level lookup).
 - Added support for LPA2 guests in KVM selftests (VM_MODE_P52V48_4K enabled and
   new VM_MODE_P52V48_16K added).
 - Rebased onto 6.3-rc1.


[1] https://lore.kernel.org/kvmarm/20221206135930.3277585-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/kvmarm/20230306195438.1557851-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/linux-arm-kernel/20230912141549.278777-63-ardb@google.com/


Anshuman Khandual (1):
  arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]

Ryan Roberts (12):
  arm64/mm: Update non-range tlb invalidation routines for FEAT_LPA2
  arm64/mm: Update range-based tlb invalidation routines for FEAT_LPA2
  KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
  KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
  KVM: arm64: Use LPA2 page-tables for stage2 if HW supports it
  KVM: arm64: Use LPA2 page-tables for hyp stage1 if HW supports it
  KVM: arm64: Insert PS field at TCR_EL2 assembly time
  KVM: arm64: Convert translation level parameter to s8
  KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
  KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
  KVM: selftests: arm64: Determine max ipa size per-page size
  KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes

 arch/arm64/include/asm/cpufeature.h           |  5 ++
 arch/arm64/include/asm/kvm_arm.h              |  2 +
 arch/arm64/include/asm/kvm_emulate.h          | 12 ++-
 arch/arm64/include/asm/kvm_pgtable.h          | 78 ++++++++++------
 arch/arm64/include/asm/kvm_pkvm.h             |  5 +-
 arch/arm64/include/asm/sysreg.h               |  5 ++
 arch/arm64/include/asm/tlb.h                  | 15 ++--
 arch/arm64/include/asm/tlbflush.h             | 85 +++++++++++-------
 arch/arm64/kernel/cpufeature.c                | 40 +++++++++
 arch/arm64/kvm/arm.c                          |  4 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  6 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |  3 +-
 arch/arm64/kvm/hyp/pgtable.c                  | 88 ++++++++++++-------
 arch/arm64/kvm/hyp/vhe/tlb.c                  |  3 +-
 arch/arm64/kvm/mmu.c                          | 16 ++--
 arch/arm64/kvm/reset.c                        |  9 +-
 arch/arm64/tools/cpucaps                      |  1 +
 .../selftests/kvm/include/aarch64/processor.h |  4 +-
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/lib/aarch64/processor.c     | 66 +++++++++++---
 tools/testing/selftests/kvm/lib/guest_modes.c | 42 ++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  3 +
 25 files changed, 342 insertions(+), 161 deletions(-)

--
2.25.1

