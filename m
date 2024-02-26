Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC82F1D54C
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947186; cv=none; b=MdhLFhhIpAAmzXtszF8nlzDByXCawx2OfrhOVNpxGGW+N8k/iWom/mTkIEPDA7QNHpVUvDOSOwq5BHgAjEe6Z8oQS5H/Q5m6t5oaCphnJNCFALpdFRMVUc8TLzjzRJioZxMRW1NS3JwovWsneOQq6pgAueMY4RQljv12jNfRGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947186; c=relaxed/simple;
	bh=dVvusUqZUQYYyXGU6LPv5l7YLKfrSCfBWtzkuyf2pnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CyHY+TSo8QkdY/bGL1CeLuYM3pjJHOMmO4vDOG0ZMFLEskTCKpmdV59DEN4yYv0/0WiZgAr4H+2wcsiDXbF5Rypvv0+56MaRJWsbnsZhyPKAV3+gj+jB9W4DnHENF/ULGwjyJ0YqoOBv/rCEO+wl0pBeqCjnWMeXWh3Dy5XDfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2B18DA7;
	Mon, 26 Feb 2024 03:33:41 -0800 (PST)
Received: from e127643.broadband (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 923DD3F6C4;
	Mon, 26 Feb 2024 03:32:59 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	acme@kernel.org,
	oliver.upton@linux.dev,
	broonie@kernel.org
Cc: James Clark <james.clark@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Helge Deller <deller@gmx.de>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/8] kvm/coresight: Support exclude guest and exclude host
Date: Mon, 26 Feb 2024 11:30:28 +0000
Message-Id: <20240226113044.228403-1-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a combination of the RFC for nVHE here [1] and v3 of VHE version
here [2]. After a few of the review comments it seemed much simpler for
both versions to use the same interface and be in the same patchset.

FEAT_TRF is a Coresight feature that allows trace capture to be
completely filtered at different exception levels, unlike the existing
TRCVICTLR controls which may still emit target addresses of branches,
even if the following trace is filtered.

Without FEAT_TRF, it was possible to start a trace session on a host and
also collect trace from the guest as TRCVICTLR was never programmed to
exclude guests (and it could still emit target addresses even if it
was).

With FEAT_TRF, the current behavior of trace in guests exists depends on
whether nVHE or VHE are being used. Both of the examples below are from
the host's point of view, as Coresight isn't accessible from guests.
This patchset is only relevant to when FEAT_TRF exists, otherwise there
is no change.

  nVHE/pKVM:

  Because the host and the guest are both using TRFCR_EL1, trace will be
  generated in guests depending on the same filter rules the host is
  using. For example if the host is tracing userspace only, then guest
  userspace trace will also be collected.

  (This is further limited by whether TRBE is used because an issue
  with TRBE means that it's completely disabled in nVHE guests, but it's
  possible to have other tracing components.)

  VHE:

  With VHE, the host filters will be in TRFCR_EL2, but the filters in
  TRFCR_EL1 will be active when the guest is running. Because we don't
  write to TRFCR_EL1, guest trace will be completely disabled.

With this change, the guest filtering rules from the Perf session are
now honored for both nVHE and VHE modes. This is done by either writing
to TRFCR_EL12 at the start of the Perf session and doing nothing else
further, or caching the guest value and writing it at guest switch for
nVHE. In pKVM, trace is now be disabled for both protected and
unprotected guests.

---

Changes since V5 [4]:
  * Sort new sysreg entries by encoding
  * Add a comment about sorting arch/arm64/tools/sysreg
  * Warn on preemptible() before calling smp_processor_id()
  * Pickup tags
  * Change TRFCR_EL2 from SysregFields to Sysreg because it was only
    used once

Changes since V4 [3]:
  * Remove all V3 changes that made it work in pKVM and just disable
    trace there instead
  * Restore PMU host/hyp state sharing back to how it was
    (kvm_pmu_update_vcpu_events())
  * Simplify some of the duplication in the comments and function docs
  * Add a WARN_ON_ONCE() if kvm_etm_set_guest_trfcr() is called when
    the trace filtering feature doesn't exist.
  * Split sysreg change into a tools update followed by the new register
    addition

Changes since V3:
  * Create a new shared area to store the host state instead of copying
    it before each VCPU run
  * Drop commit that moved SPE and trace registers from host_debug_state
    into the kvm sysregs array because the guest values were never used 
  * Document kvm_etm_set_guest_trfcr()
  * Guard kvm_etm_set_guest_trfcr() with a feature check
  * Drop Mark B and Suzuki's review tags on the sysreg patch because it
    turned out that broke the Perf build and needed some unconventional
    changes to fix it (as in: to update the tools copy of the headers in
    the same commit as the kernel changes)

Changes since V2:

  * Add a new iflag to signify presence of FEAT_TRF and keep the
    existing TRBE iflag. This fixes the issue where TRBLIMITR_EL1 was
    being accessed even if TRBE didn't exist
  * Reword a commit message

Changes since V1:

  * Squashed all the arm64/tools/sysreg changes into the first commit
  * Add a new commit to move SPE and TRBE regs into the kvm sysreg array
  * Add a comment above the TRFCR global that it's per host CPU rather
    than vcpu

Changes since nVHE RFC [1]:

 * Re-write just in terms of the register value to be written for the
   host and the guest. This removes some logic from the hyp code and
   a value of kvm_vcpu_arch:trfcr_el1 = 0 no longer means "don't
   restore".
 * Remove all the conditional compilation and new files.
 * Change the kvm_etm_update_vcpu_events macro to a function.
 * Re-use DEBUG_STATE_SAVE_TRFCR so iflags don't need to be expanded
   anymore.
 * Expand the cover letter.

Changes since VHE v3 [2]:

 * Use the same interface as nVHE mode so TRFCR_EL12 is now written by
   kvm.

[1]: https://lore.kernel.org/kvmarm/20230804101317.460697-1-james.clark@arm.com/
[2]: https://lore.kernel.org/kvmarm/20230905102117.2011094-1-james.clark@arm.com/
[3]: https://lore.kernel.org/linux-arm-kernel/20240104162714.1062610-1-james.clark@arm.com/
[4]: https://lore.kernel.org/all/20240220100924.2761706-1-james.clark@arm.com/

James Clark (8):
  arm64: KVM: Fix renamed function in comment
  arm64/sysreg: Add a comment that the sysreg file should be sorted
  tools: arm64: Update sysreg.h header files
  arm64/sysreg/tools: Move TRFCR definitions to sysreg
  arm64: KVM: Add iflag for FEAT_TRF
  arm64: KVM: Add interface to set guest value for TRFCR register
  arm64: KVM: Write TRFCR value on guest switch with nVHE
  coresight: Pass guest TRFCR value to KVM

 arch/arm64/include/asm/kvm_host.h             |   7 +-
 arch/arm64/include/asm/sysreg.h               |  12 -
 arch/arm64/kernel/image-vars.h                |   1 +
 arch/arm64/kvm/debug.c                        |  53 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  53 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/tools/sysreg                       |  38 ++
 .../coresight/coresight-etm4x-core.c          |  42 +-
 drivers/hwtracing/coresight/coresight-etm4x.h |   2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |   3 +
 tools/arch/arm64/include/asm/sysreg.h         | 375 +++++++++++++++++-
 tools/include/linux/kasan-tags.h              |  15 +
 12 files changed, 541 insertions(+), 62 deletions(-)
 create mode 100644 tools/include/linux/kasan-tags.h

-- 
2.34.1

