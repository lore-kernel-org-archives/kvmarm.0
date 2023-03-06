Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E6A6FD5
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 19:55:05 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6252E11FB;
	Mon,  6 Mar 2023 11:55:42 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7B263F71A;
	Mon,  6 Mar 2023 11:54:57 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Date: Mon,  6 Mar 2023 19:54:26 +0000
Message-Id: <20230306195438.1557851-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FEAT_LPA2 to KVM for both hypervisor stage 1 (for the
nvhe/protected modes) and the vm stage 2 translation tables (for all modes).
FEAT_LPA2 enables 52 bit PAs and VAs for 4KB and 16KB granules (note this is
already supported for 64KB granules via the FEAT_LPA and FEAT_LVA extensions).
The series does not include support for FEAT_LPA2 in the kernel stage 1. This
support is provided separately by Ard Biesheuvel's series at [1]. The two series
are independent.

These patches are based on top of v6.3-rc1, plus 3 kvm selftests bug-fix
patches, which I have posted separately at [2] and [3]. You can find a tree at
[4]. Those bug-fix patches relate to incorrect test code for 52-bit PA (64K)
guests, and are needed in order to test the new 52-bit 4K and 16K guest modes
that this series enables.


Testing:
Testing has been done exclusively on the FVP and covers the boot matrix tests
and kvm selftests.

The host/guest config boot matrix gives the same (expected) results as
for the v1 submission; of 180 conifgs, 12 fail, and these are all due to
attempting to load the host kernel into high memory which isn't expected to work
until the kernel has FEAT_LPA2 support for its stage 1. (refer to v1 posting for
details on the exact configs).

KVM selftests have been enhanced to support P52V48 4K and 16K guest modes, and
all tests have been run against a P48V48_4K host and a P52V52_4K host (a run
takes about 10 hours on FVP, sigh, but I can test a few more host configs if
useful). All tests pass except "memslot_perf_test", which fails due to a timeout
while syncing. This test fails in the same way for plain v6.3-rc1, so I'm
confident this is not a regression caused by this series. (the issue is that
alarm(2) is issued and the signal is received before alarm(0) is issued. I
expect this is an FVP-time related problem, although I'm not sure how to fix
robustly for the FVP without potentially hanging real systems for long periods
of time).


Changes since v1:
https://lore.kernel.org/kvmarm/20221206135930.3277585-1-ryan.roberts@arm.com/
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


[1] https://lore.kernel.org/linux-arm-kernel/20221124123932.2648991-1-ardb@kernel.org
[2] https://lore.kernel.org/kvmarm/20230228170756.769461-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/kvmarm/20230302152033.242073-1-ryan.roberts@arm.com/
[4] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/lpa2/kvm_lkml-v2


Anshuman Khandual (1):
  arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]

Ryan Roberts (11):
  arm64/mm: Update non-range tlb invalidation routines for FEAT_LPA2
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
 arch/arm64/include/asm/kvm_pgtable.h          | 72 +++++++++++------
 arch/arm64/include/asm/kvm_pkvm.h             |  5 +-
 arch/arm64/include/asm/sysreg.h               |  5 ++
 arch/arm64/include/asm/tlb.h                  |  9 ++-
 arch/arm64/include/asm/tlbflush.h             | 43 ++++++----
 arch/arm64/kernel/cpufeature.c                | 40 ++++++++++
 arch/arm64/kvm/arm.c                          |  4 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  6 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  2 +-
 arch/arm64/kvm/hyp/pgtable.c                  | 79 ++++++++++++-------
 arch/arm64/kvm/mmu.c                          | 15 ++--
 arch/arm64/kvm/reset.c                        |  9 +--
 arch/arm64/tools/cpucaps                      |  1 +
 .../selftests/kvm/include/aarch64/processor.h |  4 +-
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/lib/aarch64/processor.c     | 66 ++++++++++++----
 tools/testing/selftests/kvm/lib/guest_modes.c | 42 +++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  3 +
 23 files changed, 297 insertions(+), 136 deletions(-)

--
2.25.1

