Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FF1270031
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 03:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740628299; cv=none; b=nKlr8CuBaisKzf1pASEmdvcYqdEZRW1xDSIq1HJtS+wVMQ7+WkU2Rj3J5r4bFgxsFYDlkNHSl3q7d5WGll/jB2wTQwlOeAHTqHxxyBL+hP/TdcH9cO5fVi1nZAhEeQhmUKmjQUT8KKwvI3JQ8snaYrJYVTJX65DyNBtZsg8nGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740628299; c=relaxed/simple;
	bh=3oh9lEpSsnhMJBwfR+eU55Pw3Lvex7Rob+/9aI21bmA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tEYnqkNEwYkifibfo/M/4cs0xL/AZBNLYWhavUSkRUe/ESlDeLKrsXVGxnhOF7bxjuKYWEzkfUUSeQC/EGspiVR5uj2L+cDyw8MKjRn3TA8+VeTGD7IYO94i5CWiLyT2nfFDWkgzVm/nZ42zFI4JmqnOiSsmOj9+Z3Gp5TCdvnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078241515;
	Wed, 26 Feb 2025 19:51:51 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AEA443F6A8;
	Wed, 26 Feb 2025 19:51:30 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	robh@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH V3] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Date: Thu, 27 Feb 2025 09:21:19 +0530
Message-Id: <20250227035119.2025171-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
access from EL1 requires appropriate EL2 fine grained trap configuration
via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
Otherwise such register accesses will result in traps into EL2.

Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.

Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
based registers to be accessible in EL2.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Fixes: 0bbff9ed8165 ("perf/arm_pmuv3: Add PMUv3.9 per counter EL0 access control")
Fixes: d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter")
Cc: stable@vger.kernel.org
Tested-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Added 'MDCR_EL3.EnPM2 = 0b1' as a booting requirement per Mark
- Added 'Fixes:' and 'CC: stable' tags per Mark

Changes in V2:

https://lore.kernel.org/all/20250203050828.1049370-8-anshuman.khandual@arm.com/

 Documentation/arch/arm64/booting.rst | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/el2_setup.h   | 25 +++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index cad6fdc96b98..dee7b6de864f 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -288,6 +288,12 @@ Before jumping into the kernel, the following conditions must be met:
 
     - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
 
+  For CPUs with the Fine Grained Traps 2 (FEAT_FGT2) extension present:
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
+
   For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
 
   - If EL3 is present and the kernel is entered at EL2:
@@ -382,6 +388,22 @@ Before jumping into the kernel, the following conditions must be met:
 
     - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
 
+  For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
+
+ - If EL3 is present:
+
+    - MDCR_EL3.EnPM2 (bit 7) must be initialised to 0b1.
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
+    - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 25e162651750..1a0071faf57e 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -233,6 +233,30 @@
 .Lskip_fgt_\@:
 .endm
 
+.macro __init_el2_fgt2
+	mrs	x1, id_aa64mmfr0_el1
+	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
+	b.lt	.Lskip_fgt2_\@
+
+	mov	x0, xzr
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
+	b.lt	.Lskip_pmuv3p9_\@
+
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+.Lskip_pmuv3p9_\@:
+	msr_s   SYS_HDFGRTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HFGRTR2_EL2, xzr
+	msr_s   SYS_HFGWTR2_EL2, xzr
+	msr_s   SYS_HFGITR2_EL2, xzr
+.Lskip_fgt2_\@:
+.endm
+
 .macro __init_el2_gcs
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
@@ -283,6 +307,7 @@
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
+	__init_el2_fgt2
         __init_el2_gcs
 .endm
 
-- 
2.25.1

