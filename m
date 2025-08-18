Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A87C2690ED
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 04:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493099; cv=none; b=bETSla7pVYADpn5Rxhp3hBUSaL6ILMJcb88691ATA8SO4/8fTiM8TJm6RdgkiziceDVP09iJQVjKepRElbYMj4dnOWm3JosV2uFBZqsoFjW15VIAReqA+POlLK4NV5Qtxk3+N0Vt9A0Lsh6pdg/DLP0rfNhq/ce2c7xWbcEiNsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493099; c=relaxed/simple;
	bh=1V7aL4xFBt8bLOvuUCEQeF7XLkvfy5uksgcQrPF3kiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eCwQga7JV4Z/vsT3iIyX9Uj0Jd6zHhylUEen/nfnO1qU32Qo3g6XgrTYOM+PtFAyFk8FVOqW4VZU2HNXx1rfg5XlqQdhIpZkF3LAvLNnYGX1gFMNwhT010HeyhC0xhQ+KUEDeyKhShwpuH8dhMInqawL8rlAwOH2cVgS7NpNVks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E2952D95;
	Sun, 17 Aug 2025 21:58:08 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A580A3F58B;
	Sun, 17 Aug 2025 21:58:13 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] arm64/sysreg: Replace TCR_EL1 field macros
Date: Mon, 18 Aug 2025 10:27:57 +0530
Message-Id: <20250818045759.672408-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250818045759.672408-1-anshuman.khandual@arm.com>
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This just replaces all used TCR_EL1 field macros with tools sysreg variant
based fields and subsequently drops them from the header (pgtable-hwdef.h).
While here, also drop all the unused TCR_XXX macros from the header.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/assembler.h         |   6 +-
 arch/arm64/include/asm/cputype.h           |   2 +-
 arch/arm64/include/asm/kvm_arm.h           |  28 +++---
 arch/arm64/include/asm/kvm_nested.h        |   6 +-
 arch/arm64/include/asm/mmu_context.h       |   4 +-
 arch/arm64/include/asm/pgtable-hwdef.h     | 107 +++------------------
 arch/arm64/include/asm/pgtable-prot.h      |   2 +-
 arch/arm64/kernel/cpufeature.c             |   4 +-
 arch/arm64/kernel/pi/map_kernel.c          |   8 +-
 arch/arm64/kernel/vmcore_info.c            |   2 +-
 arch/arm64/kvm/arm.c                       |   6 +-
 arch/arm64/kvm/at.c                        |  48 ++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h    |   2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c              |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c               |   2 +-
 arch/arm64/kvm/nested.c                    |   8 +-
 arch/arm64/kvm/pauth.c                     |  12 +--
 arch/arm64/mm/proc.S                       |  29 +++---
 tools/arch/arm64/include/asm/cputype.h     |   2 +-
 21 files changed, 101 insertions(+), 183 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 23be85d93348..1392860a3c97 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -325,14 +325,14 @@ alternative_cb_end
  * tcr_set_t0sz - update TCR.T0SZ so that we can load the ID map
  */
 	.macro	tcr_set_t0sz, valreg, t0sz
-	bfi	\valreg, \t0sz, #TCR_T0SZ_OFFSET, #TCR_TxSZ_WIDTH
+	bfi	\valreg, \t0sz, #TCR_EL1_T0SZ_SHIFT, #TCR_EL1_T0SZ_WIDTH
 	.endm
 
 /*
  * tcr_set_t1sz - update TCR.T1SZ
  */
 	.macro	tcr_set_t1sz, valreg, t1sz
-	bfi	\valreg, \t1sz, #TCR_T1SZ_OFFSET, #TCR_TxSZ_WIDTH
+	bfi	\valreg, \t1sz, #TCR_EL1_T1SZ_SHIFT, #TCR_EL1_T1SZ_WIDTH
 	.endm
 
 /*
@@ -589,7 +589,7 @@ alternative_endif
 	.macro	offset_ttbr1, ttbr, tmp
 #if defined(CONFIG_ARM64_VA_BITS_52) && !defined(CONFIG_ARM64_LPA2)
 	mrs	\tmp, tcr_el1
-	and	\tmp, \tmp, #TCR_T1SZ_MASK
+	and	\tmp, \tmp, #TCR_EL1_T1SZ_MASK
 	cmp	\tmp, #TCR_T1SZ(VA_BITS_MIN)
 	orr	\tmp, \ttbr, #TTBR1_BADDR_4852_OFFSET
 	csel	\ttbr, \tmp, \ttbr, eq
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 661735616787..5d80710ca85f 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -243,7 +243,7 @@
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
 #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
-#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
+#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..560d9cb63413 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -115,10 +115,10 @@
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
 #define TCR_EL2_PS_40B		(2 << TCR_EL2_PS_SHIFT)
-#define TCR_EL2_TG0_MASK	TCR_TG0_MASK
-#define TCR_EL2_SH0_MASK	TCR_SH0_MASK
-#define TCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
-#define TCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
+#define TCR_EL2_TG0_MASK	TCR_EL1_TG0_MASK
+#define TCR_EL2_SH0_MASK	TCR_EL1_SH0_MASK
+#define TCR_EL2_ORGN0_MASK	TCR_EL1_ORGN0_MASK
+#define TCR_EL2_IRGN0_MASK	TCR_EL1_IRGN0_MASK
 #define TCR_EL2_T0SZ_MASK	0x3f
 #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
@@ -130,16 +130,16 @@
 #define VTCR_EL2_HA		(1 << 21)
 #define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
 #define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
-#define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
-#define VTCR_EL2_TG0_4K		TCR_TG0_4K
-#define VTCR_EL2_TG0_16K	TCR_TG0_16K
-#define VTCR_EL2_TG0_64K	TCR_TG0_64K
-#define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
-#define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
-#define VTCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
-#define VTCR_EL2_ORGN0_WBWA	TCR_ORGN0_WBWA
-#define VTCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
-#define VTCR_EL2_IRGN0_WBWA	TCR_IRGN0_WBWA
+#define VTCR_EL2_TG0_MASK	TCR_EL1_TG0_MASK
+#define VTCR_EL2_TG0_4K		(TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
+#define VTCR_EL2_TG0_16K	(TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)
+#define VTCR_EL2_TG0_64K	(TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
+#define VTCR_EL2_SH0_MASK	TCR_EL1_SH0_MASK
+#define VTCR_EL2_SH0_INNER	(TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)
+#define VTCR_EL2_ORGN0_MASK	TCR_EL1_ORGN0_MASK
+#define VTCR_EL2_ORGN0_WBWA	(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
+#define VTCR_EL2_IRGN0_MASK	TCR_EL1_IRGN0_MASK
+#define VTCR_EL2_IRGN0_WBWA	(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
 #define VTCR_EL2_SL0_SHIFT	6
 #define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
 #define VTCR_EL2_T0SZ_MASK	0x3f
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7fd76f41c296..f018c0036baa 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -17,13 +17,13 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 /* Translation helpers from non-VHE EL2 to EL1 */
 static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
 {
-	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
+	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_EL1_IPS_SHIFT;
 }
 
 static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 {
-	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
-	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+	return TCR_EL1_EPD1_MASK |			/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_TBI) ? TCR_EL1_TBI0 : 0) |
 	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
 	       (tcr & TCR_EL2_TG0_MASK) |
 	       (tcr & TCR_EL2_ORGN0_MASK) |
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 0dbe3b29049b..1b4ac7b23e18 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -73,10 +73,10 @@ static inline void __cpu_set_tcr_t0sz(unsigned long t0sz)
 {
 	unsigned long tcr = read_sysreg(tcr_el1);
 
-	if ((tcr & TCR_T0SZ_MASK) == t0sz)
+	if ((tcr & TCR_EL1_T0SZ_MASK) == t0sz)
 		return;
 
-	tcr &= ~TCR_T0SZ_MASK;
+	tcr &= ~TCR_EL1_T0SZ_MASK;
 	tcr |= t0sz;
 	write_sysreg(tcr, tcr_el1);
 	isb();
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index f3b77deedfa2..c74d1811f1fc 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -228,102 +228,17 @@
 /*
  * TCR flags.
  */
-#define TCR_T0SZ_OFFSET		0
-#define TCR_T1SZ_OFFSET		16
-#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_T0SZ_OFFSET)
-#define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_T1SZ_OFFSET)
-#define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
-#define TCR_TxSZ_WIDTH		6
-#define TCR_T0SZ_MASK		(((UL(1) << TCR_TxSZ_WIDTH) - 1) << TCR_T0SZ_OFFSET)
-#define TCR_T1SZ_MASK		(((UL(1) << TCR_TxSZ_WIDTH) - 1) << TCR_T1SZ_OFFSET)
-
-#define TCR_EPD0_SHIFT		7
-#define TCR_EPD0_MASK		(UL(1) << TCR_EPD0_SHIFT)
-#define TCR_IRGN0_SHIFT		8
-#define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
-#define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
-#define TCR_IRGN0_WBWA		(UL(1) << TCR_IRGN0_SHIFT)
-#define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
-#define TCR_IRGN0_WBnWA		(UL(3) << TCR_IRGN0_SHIFT)
-
-#define TCR_EPD1_SHIFT		23
-#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
-#define TCR_IRGN1_SHIFT		24
-#define TCR_IRGN1_MASK		(UL(3) << TCR_IRGN1_SHIFT)
-#define TCR_IRGN1_NC		(UL(0) << TCR_IRGN1_SHIFT)
-#define TCR_IRGN1_WBWA		(UL(1) << TCR_IRGN1_SHIFT)
-#define TCR_IRGN1_WT		(UL(2) << TCR_IRGN1_SHIFT)
-#define TCR_IRGN1_WBnWA		(UL(3) << TCR_IRGN1_SHIFT)
-
-#define TCR_IRGN_NC		(TCR_IRGN0_NC | TCR_IRGN1_NC)
-#define TCR_IRGN_WBWA		(TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
-#define TCR_IRGN_WT		(TCR_IRGN0_WT | TCR_IRGN1_WT)
-#define TCR_IRGN_WBnWA		(TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
-#define TCR_IRGN_MASK		(TCR_IRGN0_MASK | TCR_IRGN1_MASK)
-
-
-#define TCR_ORGN0_SHIFT		10
-#define TCR_ORGN0_MASK		(UL(3) << TCR_ORGN0_SHIFT)
-#define TCR_ORGN0_NC		(UL(0) << TCR_ORGN0_SHIFT)
-#define TCR_ORGN0_WBWA		(UL(1) << TCR_ORGN0_SHIFT)
-#define TCR_ORGN0_WT		(UL(2) << TCR_ORGN0_SHIFT)
-#define TCR_ORGN0_WBnWA		(UL(3) << TCR_ORGN0_SHIFT)
-
-#define TCR_ORGN1_SHIFT		26
-#define TCR_ORGN1_MASK		(UL(3) << TCR_ORGN1_SHIFT)
-#define TCR_ORGN1_NC		(UL(0) << TCR_ORGN1_SHIFT)
-#define TCR_ORGN1_WBWA		(UL(1) << TCR_ORGN1_SHIFT)
-#define TCR_ORGN1_WT		(UL(2) << TCR_ORGN1_SHIFT)
-#define TCR_ORGN1_WBnWA		(UL(3) << TCR_ORGN1_SHIFT)
-
-#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
-#define TCR_ORGN_WBWA		(TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
-#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
-#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
-#define TCR_ORGN_MASK		(TCR_ORGN0_MASK | TCR_ORGN1_MASK)
-
-#define TCR_SH0_SHIFT		12
-#define TCR_SH0_MASK		(UL(3) << TCR_SH0_SHIFT)
-#define TCR_SH0_INNER		(UL(3) << TCR_SH0_SHIFT)
-
-#define TCR_SH1_SHIFT		28
-#define TCR_SH1_MASK		(UL(3) << TCR_SH1_SHIFT)
-#define TCR_SH1_INNER		(UL(3) << TCR_SH1_SHIFT)
-#define TCR_SHARED		(TCR_SH0_INNER | TCR_SH1_INNER)
-
-#define TCR_TG0_SHIFT		14
-#define TCR_TG0_MASK		(UL(3) << TCR_TG0_SHIFT)
-#define TCR_TG0_4K		(UL(0) << TCR_TG0_SHIFT)
-#define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
-#define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
-
-#define TCR_TG1_SHIFT		30
-#define TCR_TG1_MASK		(UL(3) << TCR_TG1_SHIFT)
-#define TCR_TG1_16K		(UL(1) << TCR_TG1_SHIFT)
-#define TCR_TG1_4K		(UL(2) << TCR_TG1_SHIFT)
-#define TCR_TG1_64K		(UL(3) << TCR_TG1_SHIFT)
-
-#define TCR_IPS_SHIFT		32
-#define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
-#define TCR_A1			(UL(1) << 22)
-#define TCR_ASID16		(UL(1) << 36)
-#define TCR_TBI0		(UL(1) << 37)
-#define TCR_TBI1		(UL(1) << 38)
-#define TCR_HA			(UL(1) << 39)
-#define TCR_HD			(UL(1) << 40)
-#define TCR_HPD0_SHIFT		41
-#define TCR_HPD0		(UL(1) << TCR_HPD0_SHIFT)
-#define TCR_HPD1_SHIFT		42
-#define TCR_HPD1		(UL(1) << TCR_HPD1_SHIFT)
-#define TCR_TBID0		(UL(1) << 51)
-#define TCR_TBID1		(UL(1) << 52)
-#define TCR_NFD0		(UL(1) << 53)
-#define TCR_NFD1		(UL(1) << 54)
-#define TCR_E0PD0		(UL(1) << 55)
-#define TCR_E0PD1		(UL(1) << 56)
-#define TCR_TCMA0		(UL(1) << 57)
-#define TCR_TCMA1		(UL(1) << 58)
-#define TCR_DS			(UL(1) << 59)
+#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_EL1_T0SZ_SHIFT)
+#define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_EL1_T1SZ_SHIFT)
+
+#define TCR_IRGN_WBWA		((TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT) |\
+				 (TCR_EL1_IRGN1_WBWA << TCR_EL1_IRGN1_SHIFT))
+
+#define TCR_ORGN_WBWA		((TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT) |\
+				 (TCR_EL1_ORGN1_WBWA << TCR_EL1_ORGN1_SHIFT))
+
+#define TCR_SHARED		((TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT) |\
+				 (TCR_EL1_SH1_INNER << TCR_EL1_SH1_SHIFT))
 
 /*
  * TTBR.
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 85dceb1c66f4..21a3d3342283 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -84,7 +84,7 @@ extern unsigned long prot_ns_shared;
 #else
 static inline bool __pure lpa2_is_enabled(void)
 {
-	return read_tcr() & TCR_DS;
+	return read_tcr() & TCR_EL1_DS;
 }
 
 #define PTE_MAYBE_SHARED	(lpa2_is_enabled() ? 0 : PTE_SHARED)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..bb995d594a88 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2064,7 +2064,7 @@ static struct cpumask dbm_cpus __read_mostly;
 
 static inline void __cpu_enable_hw_dbm(void)
 {
-	u64 tcr = read_sysreg(tcr_el1) | TCR_HD;
+	u64 tcr = read_sysreg(tcr_el1) | TCR_EL1_HD;
 
 	write_sysreg(tcr, tcr_el1);
 	isb();
@@ -2323,7 +2323,7 @@ static bool has_generic_auth(const struct arm64_cpu_capabilities *entry,
 static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
 {
 	if (this_cpu_has_cap(ARM64_HAS_E0PD))
-		sysreg_clear_set(tcr_el1, 0, TCR_E0PD1);
+		sysreg_clear_set(tcr_el1, 0, TCR_EL1_E0PD1);
 }
 #endif /* CONFIG_ARM64_E0PD */
 
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index 0f4bd7771859..3f81e0610577 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -135,13 +135,13 @@ static void __init map_kernel(u64 kaslr_offset, u64 va_offset, int root_level)
 static void noinline __section(".idmap.text") set_ttbr0_for_lpa2(u64 ttbr)
 {
 	u64 sctlr = read_sysreg(sctlr_el1);
-	u64 tcr = read_sysreg(tcr_el1) | TCR_DS;
+	u64 tcr = read_sysreg(tcr_el1) | TCR_EL1_DS;
 	u64 mmfr0 = read_sysreg(id_aa64mmfr0_el1);
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
 							   ID_AA64MMFR0_EL1_PARANGE_SHIFT);
 
-	tcr &= ~TCR_IPS_MASK;
-	tcr |= parange << TCR_IPS_SHIFT;
+	tcr &= ~TCR_EL1_IPS_MASK;
+	tcr |= parange << TCR_EL1_IPS_SHIFT;
 
 	asm("	msr	sctlr_el1, %0		;"
 	    "	isb				;"
@@ -256,7 +256,7 @@ asmlinkage void __init early_map_kernel(u64 boot_status, void *fdt)
 	}
 
 	if (va_bits > VA_BITS_MIN)
-		sysreg_clear_set(tcr_el1, TCR_T1SZ_MASK, TCR_T1SZ(va_bits));
+		sysreg_clear_set(tcr_el1, TCR_EL1_T1SZ_MASK, TCR_T1SZ(va_bits));
 
 	/*
 	 * The virtual KASLR displacement modulo 2MiB is decided by the
diff --git a/arch/arm64/kernel/vmcore_info.c b/arch/arm64/kernel/vmcore_info.c
index b19d5d6cb8b3..9619ece66b79 100644
--- a/arch/arm64/kernel/vmcore_info.c
+++ b/arch/arm64/kernel/vmcore_info.c
@@ -14,7 +14,7 @@ static inline u64 get_tcr_el1_t1sz(void);
 
 static inline u64 get_tcr_el1_t1sz(void)
 {
-	return (read_sysreg(tcr_el1) & TCR_T1SZ_MASK) >> TCR_T1SZ_OFFSET;
+	return (read_sysreg(tcr_el1) & TCR_EL1_T1SZ_MASK) >> TCR_EL1_T1SZ_SHIFT;
 }
 
 void arch_crash_save_vmcoreinfo(void)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..b47d6d530e57 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2000,10 +2000,10 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 
 	tcr = read_sysreg(tcr_el1);
 	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
-		tcr &= ~(TCR_HD | TCR_HA | TCR_A1 | TCR_T0SZ_MASK);
-		tcr |= TCR_EPD1_MASK;
+		tcr &= ~(TCR_EL1_HD | TCR_EL1_HA | TCR_EL1_A1 | TCR_EL1_T0SZ_MASK);
+		tcr |= TCR_EL1_EPD1_MASK;
 	} else {
-		unsigned long ips = FIELD_GET(TCR_IPS_MASK, tcr);
+		unsigned long ips = FIELD_GET(TCR_EL1_IPS_MASK, tcr);
 
 		tcr &= TCR_EL2_MASK;
 		tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 0e5610533949..5f0f10ef38f0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -134,8 +134,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	tbi = (wi->regime == TR_EL2 ?
 	       FIELD_GET(TCR_EL2_TBI, tcr) :
 	       (va55 ?
-		FIELD_GET(TCR_TBI1, tcr) :
-		FIELD_GET(TCR_TBI0, tcr)));
+		FIELD_GET(TCR_EL1_TBI1, tcr) :
+		FIELD_GET(TCR_EL1_TBI0, tcr)));
 
 	if (!tbi && (u64)sign_extend64(va, 55) != va)
 		goto addrsz;
@@ -183,8 +183,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->hpd &= (wi->regime == TR_EL2 ?
 		    FIELD_GET(TCR_EL2_HPD, tcr) :
 		    (va55 ?
-		     FIELD_GET(TCR_HPD1, tcr) :
-		     FIELD_GET(TCR_HPD0, tcr)));
+		     FIELD_GET(TCR_EL1_HPD1, tcr) :
+		     FIELD_GET(TCR_EL1_HPD0, tcr)));
 	/* R_JHSVW */
 	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
 
@@ -196,28 +196,28 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	/* Someone was silly enough to encode TG0/TG1 differently */
 	if (va55) {
-		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG1_MASK, tcr);
+		wi->txsz = FIELD_GET(TCR_EL1_T1SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_EL1_TG1_MASK, tcr);
 
-		switch (tg << TCR_TG1_SHIFT) {
-		case TCR_TG1_4K:
+		switch (tg << TCR_EL1_TG1_SHIFT) {
+		case TCR_EL1_TG1_4K:
 			wi->pgshift = 12;	 break;
-		case TCR_TG1_16K:
+		case TCR_EL1_TG1_16K:
 			wi->pgshift = 14;	 break;
-		case TCR_TG1_64K:
+		case TCR_EL1_TG1_64K:
 		default:	    /* IMPDEF: treat any other value as 64k */
 			wi->pgshift = 16;	 break;
 		}
 	} else {
-		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG0_MASK, tcr);
+		wi->txsz = FIELD_GET(TCR_EL1_T0SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_EL1_TG0_MASK, tcr);
 
-		switch (tg << TCR_TG0_SHIFT) {
-		case TCR_TG0_4K:
+		switch (tg) {
+		case TCR_EL1_TG0_4K:
 			wi->pgshift = 12;	 break;
-		case TCR_TG0_16K:
+		case TCR_EL1_TG0_16K:
 			wi->pgshift = 14;	 break;
-		case TCR_TG0_64K:
+		case TCR_EL1_TG0_64K:
 		default:	    /* IMPDEF: treat any other value as 64k */
 			wi->pgshift = 16;	 break;
 		}
@@ -236,11 +236,11 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	switch (BIT(wi->pgshift)) {
 	case SZ_4K:
 		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT);
-		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
+		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_EL1_DS);
 		break;
 	case SZ_16K:
 		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT);
-		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
+		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_EL1_DS);
 		break;
 	case SZ_64K:
 		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, VARange, 52);
@@ -259,12 +259,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	/* I_ZFSYQ */
 	if (wi->regime != TR_EL2 &&
-	    (tcr & (va55 ? TCR_EPD1_MASK : TCR_EPD0_MASK)))
+	    (tcr & (va55 ? TCR_EL1_EPD1_MASK : TCR_EL1_EPD0_MASK)))
 		goto transfault_l0;
 
 	/* R_BNDVG and following statements */
 	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
-	    wi->as_el0 && (tcr & (va55 ? TCR_E0PD1 : TCR_E0PD0)))
+	    wi->as_el0 && (tcr & (va55 ? TCR_EL1_E0PD1 : TCR_EL1_E0PD0)))
 		goto transfault_l0;
 
 	/* AArch64.S1StartLevel() */
@@ -272,7 +272,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
 
 	ps = (wi->regime == TR_EL2 ?
-	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
+	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_EL1_IPS_MASK, tcr));
 
 	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps));
 
@@ -421,13 +421,13 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		switch (wi->regime) {
 		case TR_EL10:
 			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
-			asid_ttbr = ((tcr & TCR_A1) ?
+			asid_ttbr = ((tcr & TCR_EL1_A1) ?
 				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
 				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
 			break;
 		case TR_EL20:
 			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-			asid_ttbr = ((tcr & TCR_A1) ?
+			asid_ttbr = ((tcr & TCR_EL1_A1) ?
 				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
 				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
 			break;
@@ -437,7 +437,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
+		    !(tcr & TCR_EL1_AS))
 			wr->asid &= GENMASK(7, 0);
 	}
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84ec4e100fbb..91189c5ab190 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -881,7 +881,7 @@ static bool handle_ampere1_tcr(struct kvm_vcpu *vcpu)
 	 * Uphold the requirements of the architecture by masking guest writes
 	 * to TCR_EL1.{HA,HD} here.
 	 */
-	val &= ~(TCR_HD | TCR_HA);
+	val &= ~(TCR_EL1_HD | TCR_EL1_HA);
 	write_sysreg_el1(val, SYS_TCR);
 	__kvm_skip_instr(vcpu);
 	return true;
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a17cbe7582de..fb0dc749db7b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -225,7 +225,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 		 * set. Pairs with nVHE's __activate_traps().
 		 */
 		write_sysreg_el1((ctxt_sys_reg(ctxt, TCR_EL1) |
-				  TCR_EPD1_MASK | TCR_EPD0_MASK),
+				  TCR_EL1_EPD1_MASK | TCR_EL1_EPD0_MASK),
 				 SYS_TCR);
 		isb();
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index ccd575d5f6de..70c3d020d97e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -86,7 +86,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		 * ensure that things happen in this exact order.
 		 */
 		val = read_sysreg_el1(SYS_TCR);
-		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
+		write_sysreg_el1(val | TCR_EL1_EPD1_MASK | TCR_EL1_EPD0_MASK, SYS_TCR);
 		isb();
 		val = read_sysreg_el1(SYS_SCTLR);
 		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 48da9ca9763f..b4eaa52790b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -84,7 +84,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 		 * temporarily enabled in the next context.
 		 */
 		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
-		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
+		val |= TCR_EL1_EPD1_MASK | TCR_EL1_EPD0_MASK;
 		write_sysreg_el1(val, SYS_TCR);
 		isb();
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index ec2569818629..5c58c3b5cc74 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -41,7 +41,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 		 * allocate IPA->PA walks, so we enable the S1 MMU...
 		 */
 		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
-		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
+		val |= TCR_EL1_EPD1_MASK | TCR_EL1_EPD0_MASK;
 		write_sysreg_el1(val, SYS_TCR);
 		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
 		val |= SCTLR_ELx_M;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 153b3e11b115..7b1802a4072e 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1266,14 +1266,14 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
 
 	if (vt->wr.nG) {
 		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
+		u64 ttbr = ((tcr & TCR_EL1_A1) ?
 			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
 			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
 		u16 asid;
 
 		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
+		    !(tcr & TCR_EL1_AS))
 			asid &= GENMASK(7, 0);
 
 		return asid != vt->wr.asid;
@@ -1366,14 +1366,14 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 
 	if (vt->wr.nG) {
 		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
+		u64 ttbr = ((tcr & TCR_EL1_A1) ?
 			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
 			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
 		u16 asid;
 
 		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
+		    !(tcr & TCR_EL1_AS))
 			asid &= GENMASK(7, 0);
 
 		if (asid != vt->wr.asid)
diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
index d5eb3ae876be..29c3797b3e1c 100644
--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -73,11 +73,11 @@ static bool effective_tbi(struct kvm_vcpu *vcpu, bool bit55)
 		tbi = tcr & BIT(20);
 		tbid = tcr & BIT(29);
 	} else if (bit55) {
-		tbi = tcr & TCR_TBI1;
-		tbid = tcr & TCR_TBID1;
+		tbi = tcr & TCR_EL1_TBI1;
+		tbid = tcr & TCR_EL1_TBID1;
 	} else {
-		tbi = tcr & TCR_TBI0;
-		tbid = tcr & TCR_TBID0;
+		tbi = tcr & TCR_EL1_TBI0;
+		tbid = tcr & TCR_EL1_TBID0;
 	}
 
 	return tbi && !tbid;
@@ -91,9 +91,9 @@ static int compute_bottom_pac(struct kvm_vcpu *vcpu, bool bit55)
 	int txsz;
 
 	if (!vcpu_el2_e2h_is_set(vcpu) || !bit55)
-		txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
+		txsz = FIELD_GET(TCR_EL1_T0SZ_MASK, tcr);
 	else
-		txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
+		txsz = FIELD_GET(TCR_EL1_T1SZ_MASK, tcr);
 
 	return 64 - clamp(txsz, mintxsz, maxtxsz);
 }
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 8c75965afc9e..73b859ec46de 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -23,15 +23,18 @@
 #include <asm/sysreg.h>
 
 #ifdef CONFIG_ARM64_64K_PAGES
-#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
+#define TCR_TG_FLAGS	((TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT) |\
+			 (TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT))
 #elif defined(CONFIG_ARM64_16K_PAGES)
-#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
+#define TCR_TG_FLAGS	((TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT) |\
+			 (TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT))
 #else /* CONFIG_ARM64_4K_PAGES */
-#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
+#define TCR_TG_FLAGS	((TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT) |\
+			 (TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT))
 #endif
 
 #ifdef CONFIG_RANDOMIZE_BASE
-#define TCR_KASLR_FLAGS	TCR_NFD1
+#define TCR_KASLR_FLAGS	TCR_EL1_NFD1
 #else
 #define TCR_KASLR_FLAGS	0
 #endif
@@ -40,19 +43,19 @@
 #define TCR_CACHE_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
 
 #ifdef CONFIG_KASAN_SW_TAGS
-#define TCR_KASAN_SW_FLAGS TCR_TBI1 | TCR_TBID1
+#define TCR_KASAN_SW_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
 #else
 #define TCR_KASAN_SW_FLAGS 0
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
+#define TCR_MTE_FLAGS TCR_EL1_TCMA1 | TCR_EL1_TBI1 | TCR_EL1_TBID1
 #elif defined(CONFIG_ARM64_MTE)
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
  * TBI being enabled at EL1.
  */
-#define TCR_MTE_FLAGS TCR_TBI1 | TCR_TBID1
+#define TCR_MTE_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
 #else
 #define TCR_MTE_FLAGS 0
 #endif
@@ -129,7 +132,7 @@ SYM_FUNC_START(cpu_do_resume)
 
 	/* Don't change t0sz here, mask those bits when restoring */
 	mrs	x7, tcr_el1
-	bfi	x8, x7, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	bfi	x8, x7, TCR_EL1_T0SZ_SHIFT, TCR_EL1_T0SZ_WIDTH
 
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
@@ -468,8 +471,8 @@ SYM_FUNC_START(__cpu_setup)
 	tcr2	.req	x15
 	mov_q	mair, MAIR_EL1_SET
 	mov_q	tcr, TCR_T0SZ(IDMAP_VA_BITS) | TCR_T1SZ(VA_BITS_MIN) | TCR_CACHE_FLAGS | \
-		     TCR_SHARED | TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
-		     TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
+		     TCR_SHARED | TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_EL1_AS | \
+		     TCR_EL1_TBI0 | TCR_EL1_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
 	mov	tcr2, xzr
 
 	tcr_clear_errata_bits tcr, x9, x5
@@ -479,7 +482,7 @@ SYM_FUNC_START(__cpu_setup)
 alternative_if ARM64_HAS_VA52
 	tcr_set_t1sz	tcr, x9
 #ifdef CONFIG_ARM64_LPA2
-	orr		tcr, tcr, #TCR_DS
+	orr		tcr, tcr, #TCR_EL1_DS
 #endif
 alternative_else_nop_endif
 #endif
@@ -487,7 +490,7 @@ alternative_else_nop_endif
 	/*
 	 * Set the IPS bits in TCR_EL1.
 	 */
-	tcr_compute_pa_size tcr, #TCR_IPS_SHIFT, x5, x6
+	tcr_compute_pa_size tcr, #TCR_EL1_IPS_SHIFT, x5, x6
 #ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable hardware update of the Access Flags bit.
@@ -497,7 +500,7 @@ alternative_else_nop_endif
 	mrs	x9, ID_AA64MMFR1_EL1
 	ubfx	x9, x9, ID_AA64MMFR1_EL1_HAFDBS_SHIFT, #4
 	cbz	x9, 1f
-	orr	tcr, tcr, #TCR_HA		// hardware Access flag update
+	orr	tcr, tcr, #TCR_EL1_HA		// hardware Access flag update
 #ifdef CONFIG_ARM64_HAFT
 	cmp	x9, ID_AA64MMFR1_EL1_HAFDBS_HAFT
 	b.lt	1f
diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
index 9a5d85cfd1fb..19a68298673c 100644
--- a/tools/arch/arm64/include/asm/cputype.h
+++ b/tools/arch/arm64/include/asm/cputype.h
@@ -223,7 +223,7 @@
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
 #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
-#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
+#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
 
 #ifndef __ASSEMBLY__
 
-- 
2.25.1

