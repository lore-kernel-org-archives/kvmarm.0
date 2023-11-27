Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62EF19445
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 727222F4;
	Mon, 27 Nov 2023 03:18:40 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5737C3F73F;
	Mon, 27 Nov 2023 03:17:51 -0800 (PST)
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
Subject: [PATCH v6 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Date: Mon, 27 Nov 2023 11:17:25 +0000
Message-Id: <20231127111737.1897081-1-ryan.roberts@arm.com>
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
support is provided separately by Ard Biesheuvel's series at [6]. The two series
are independent.

This latest revision incorporates some nits from Marc and Oliver and adds
Oliver's Reviewed-by for the series.

NOTE: The first 3 patches rework the tlbi routines to work for LPA2. These
patches are required by both my series and Ard's series; Ard is prefixing his
series with these same patches.

NOTE TO ARD: I had to modify the second patch of the first 3 to move
kvm_lpa2_is_enabled() to another header to address one of Oliver's requests. So
you might want to reapply that to your series.

Testing
=======

Testing has been done exclusively on the FVP and covers my boot matrix tests
and kvm selftests.

I've expanded the boot matrix tests to include coverage of hvhe mode. This
brings the number of configs to 300, 20 of which fail due to Ard's series not
being present (which is expected).

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

Additionally, when running page_fault_test, when run on FVP against v6.7-rc1 and
newer, I'm seeing RCU stalls. I'm confident that this is not an issue introduced
by this series because it reproduces without my patches.


Changes since v5 [5]
====================

Various nits based on Marc and Oliver's feedback:

 - Added Oliver's reviewed-by tags (thanks!)
 - Switched order of patches 4 and 5 and changed ifdefery for
   has_lpa2_at_stage[1|2]() (suggested by Marc)
 - Standardised on using kvm_lpa2_is_enabled() instead of
   system_supports_lpa2() - had to move kvm_lpa2_is_enabled() from kvm_mmu.h
   to kvm_pgtable.h (suggested by Oliver)
 - Selftests: modified guest_mode_append() to take single argument that inits
   both ::supported and ::enabled (suggested by Oliver)
 - Selftests: replaced magic values in aarch64_get_supported_page_sizes()
   with sysreg defines (suggested by Oliver)


Changes since v4 [4]
====================

Various tidy-ups based on Marc's feedback:

 - rebased onto v6.7-rc1.
 - Changed cpus_have_const_cap() to cpus_have_final_cap().
 - Reworked the tlbi patches to change the scale direction as first patch, then
   introduce LPA2 support in separate patch.
 - Added clarifying comments to tlbi routines.
 - Removed inline and simplified ifdefery for HAP_LPA2 capability.
 - Reverted kvm_get_mode() != KVM_MODE_NONE for HAS_LPA2 capability since the
   key is only used by KVM anyway - kernel can't use this because its too late
   in boot process.
 - Fixed some nits.


Changes since v3 [3]
====================

 - rebased onto v6.6-rc5.
 - has_lpa2() only requires consistency between s1 and s2 when
   kvm_get_mode() != KVM_MODE_NONE.
 - squashed 2 patches that enabled hyp s1 and vm s2 to use LPA2 pgtable format
   respectively, into 1 patch. There were shared accessors so the intermediate
   state was invalid.
 - use FIELD_PREP() to insert PS into TCR_EL2 instead of raw shift.


Changes since v2 [2]
====================

 - rebased onto v6.6-rc1
 - removed small amount of dead code eroneously introduced by previous rebase
 - reworked range-based tlbi to work with LPA2 (KVM has started using
   range-based tlbi as of v6.6-rc1)


Changes since v1 [1]
====================

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
[3] https://lore.kernel.org/kvmarm/20230918065740.3670662-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/kvmarm/20231009185008.3803879-1-ryan.roberts@arm.com/
[5] https://lore.kernel.org/kvmarm/20231116142931.1675485-1-ryan.roberts@arm.com/
[6] https://lore.kernel.org/linux-arm-kernel/20230912141549.278777-63-ardb@google.com/


Thanks,
Ryan

Anshuman Khandual (1):
  arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]

Ryan Roberts (11):
  arm64/mm: Modify range-based tlbi to decrement scale
  arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
  arm64/mm: Update tlb invalidation routines for FEAT_LPA2
  arm64: Add ARM64_HAS_LPA2 CPU capability
  KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
  KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
  KVM: arm64: Convert translation level parameter to s8
  KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
  KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
  KVM: selftests: arm64: Determine max ipa size per-page size
  KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes

 arch/arm64/include/asm/cpufeature.h           |   5 +
 arch/arm64/include/asm/kvm_arm.h              |   2 +
 arch/arm64/include/asm/kvm_emulate.h          |  12 ++-
 arch/arm64/include/asm/kvm_pgtable.h          |  80 +++++++++-----
 arch/arm64/include/asm/kvm_pkvm.h             |   5 +-
 arch/arm64/include/asm/pgtable-prot.h         |   2 +
 arch/arm64/include/asm/sysreg.h               |   5 +
 arch/arm64/include/asm/tlb.h                  |  15 ++-
 arch/arm64/include/asm/tlbflush.h             | 100 +++++++++++-------
 arch/arm64/kernel/cpufeature.c                |  39 +++++++
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   4 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   6 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  90 ++++++++++------
 arch/arm64/kvm/mmu.c                          |  16 +--
 arch/arm64/kvm/reset.c                        |   9 +-
 arch/arm64/tools/cpucaps                      |   1 +
 .../selftests/kvm/include/aarch64/processor.h |   4 +-
 .../selftests/kvm/include/guest_modes.h       |   4 +-
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../selftests/kvm/lib/aarch64/processor.c     |  69 +++++++++---
 tools/testing/selftests/kvm/lib/guest_modes.c |  50 ++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +
 25 files changed, 362 insertions(+), 171 deletions(-)

--
2.25.1

