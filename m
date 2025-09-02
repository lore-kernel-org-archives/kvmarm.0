Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4462DD5F7
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756818842; cv=none; b=lfJJYI8qy4YXbGU+ac1kaegrCmDYVFNhwUqZo2iOwpkV+igiaeu0TVk/626bUwUAjfgGqPn2Ns+eK/2oSFheLe+8wadukLYv7WtpixfjnxCPCwQ1nqaYRmkh/zJ8zvsEcL/VaFZcOFK2TsSZh3gr+/E6pkwL4vgXIosesWenH4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756818842; c=relaxed/simple;
	bh=WVfdcK/bVXM2v0kDzSAy5Z5ewdm95RCWGdWXLy0pT9M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY2NBmlQxQ0bTvRGRaBjWW37SHnjgSN/CtBWQz4F/A5wLdo77DSx5vilrWfMpIrG7iALZIzkoSfq9qzpuk9QSCJw6lFkzJYuTQlokQX0F8Hx91IxhxBsKPRWYqQaxB4ECsnYR+pVyslAj0/7EdJ3tPcZ07H3nI2HYS+vNykiwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 200902720;
	Tue,  2 Sep 2025 06:13:50 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 098EB3F694;
	Tue,  2 Sep 2025 06:13:56 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: [PATCH v2 1/2] KVM: arm64: VHE: Initialize PMSCR_EL1
Date: Tue,  2 Sep 2025 14:08:32 +0100
Message-ID: <20250902130833.338216-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902130833.338216-1-alexandru.elisei@arm.com>
References: <20250902130833.338216-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the pseudocode for StatisticalProfilingEnabled() from Arm
DDI0487L.b, PMSCR_EL1 controls profiling at EL1 and EL0:

- PMSCR_EL1.E1SPE controls profiling at EL1.
- PMSCR_EL1.E0SPE controls profiling at EL0 if HCR_EL2.TGE=0.

These two fields reset to UNKNOWN values.

When KVM runs in VHE mode and profiling is enabled in the host, before
entering a guest, KVM does not touch any of the SPE registers, leaving the
buffer enabled, and it clears HCR_EL2.TGE. As a result, depending on the
reset value for the E1SPE and E0SPE fields, KVM might unintentionally
profile a guest. Make the behaviour consistent and predictable by clearing
PMSCR_EL1 when KVM initialises the host debug configuration.

Note that this is not a problem for nVHE, because KVM clears
PMSCR_EL1.{E1SPE,E0SPE} before entering the guest.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Tested by setting PMSCR_EL1.{E1SPE,E0SPE} in __finalise_el2 (to simulate a
system where the bits reset to 1) and clearing MDCR_EL2.TPMS (so guest
accesses to PMSCR_EL1 are not trapped). I booted the kernel in the model
with FEAT_SPE, but without FEAT_FGT (so I wouldn't have to fiddle with
those traps too).  Then ran a hacked kvm-unit-tests test that reads
PMSCR_EL1.

Without the patch: PMSCR_EL1 = 0x3 - E1SPE and E0SPE are set.
With the patch: PMSCR_EL1 = 0x0- E1SPE and E0SPE are not set.

Also tested by running the series on a cubie a5e (doesn't have FEAT_SPE),
in vhe, nvhe and protected modes.

 arch/arm64/kvm/debug.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 381382c19fe4..e7ce0d5a622d 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -74,13 +74,19 @@ void kvm_init_host_debug_data(void)
 	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
 	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
 
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
+	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P)) {
+		if (has_vhe()) {
+			/* Clear E{0,1}SPE, which reset to UNKNOWN values. */
+			write_sysreg_el1(0, SYS_PMSCR);
+		} else {
+			host_data_set_flag(HAS_SPE);
+		}
+	}
+
 	if (has_vhe())
 		return;
 
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
-	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
-		host_data_set_flag(HAS_SPE);
-
 	/* Check if we have BRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT))
 		host_data_set_flag(HAS_BRBE);
-- 
2.51.0

