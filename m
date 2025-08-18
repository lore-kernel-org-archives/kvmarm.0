Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0791426E17A
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 04:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493105; cv=none; b=Ah5EL2EzTch8K3evpcPMLbZdxh2ojp1s5evgsKEJtrtcfN2xflplaHU2Xf3QVwwQUIDDbHyrHaVv+yigyGoH/bw/vd9D+y2g2+OcQ3RsOYiuDPagnFzgo9g6dDEn8ohwkkiSRx9U5ax0WwCK0UN+8qBDyDdT1kW2nOTXLl2UI4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493105; c=relaxed/simple;
	bh=arGTDLJ+WyYUfHUXadbRbVI+ZbCbclB090oJcp2Pzts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K9I5jREPPH3O4FPwRV1bjEnYteNEg4fccyKVpILsYZR7vov4dounMOWI9Q6Fonuv7mPUuJYapTweTiMLuuTtTb0MBrLCPjPF7wxnLA7fUdmDKVRxlpW+yr8U0nGpuLNVy5bFQYraVl+QWVtl7tr7s9pATc302OgDSdmvhK6+u6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48DBB2A2A;
	Sun, 17 Aug 2025 21:58:15 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F4E53F58B;
	Sun, 17 Aug 2025 21:58:20 -0700 (PDT)
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
Subject: [PATCH 4/4] arm64/sysreg: Add VTCR_EL2 register
Date: Mon, 18 Aug 2025 10:27:59 +0530
Message-Id: <20250818045759.672408-5-anshuman.khandual@arm.com>
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

Add VTCR_EL2 register fields as per the latest ARM ARM DDI 0487 7.B in
tools sysreg format and drop the existing macros from the header
(arch/arm64/include/asm/kvm_arm.h). While here also drop an explicit
sysreg definction SYS_VTCR_EL2 from sysreg.h header.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 32 +++---------------
 arch/arm64/include/asm/sysreg.h  |  1 -
 arch/arm64/kvm/hyp/pgtable.c     |  6 ++--
 arch/arm64/kvm/nested.c          |  2 +-
 arch/arm64/tools/sysreg          | 57 ++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8994cddef182..5abe3536f1d2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -110,31 +110,7 @@
 #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
 
-/* VTCR_EL2 Registers bits */
-#define VTCR_EL2_DS		TCR_EL2_DS
-#define VTCR_EL2_RES1		(1U << 31)
-#define VTCR_EL2_HD		(1 << 22)
-#define VTCR_EL2_HA		(1 << 21)
-#define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
-#define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
-#define VTCR_EL2_TG0_MASK	TCR_EL1_TG0_MASK
-#define VTCR_EL2_TG0_4K		(TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
-#define VTCR_EL2_TG0_16K	(TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)
-#define VTCR_EL2_TG0_64K	(TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
-#define VTCR_EL2_SH0_MASK	TCR_EL1_SH0_MASK
-#define VTCR_EL2_SH0_INNER	(TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)
-#define VTCR_EL2_ORGN0_MASK	TCR_EL1_ORGN0_MASK
-#define VTCR_EL2_ORGN0_WBWA	(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
-#define VTCR_EL2_IRGN0_MASK	TCR_EL1_IRGN0_MASK
-#define VTCR_EL2_IRGN0_WBWA	(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
-#define VTCR_EL2_SL0_SHIFT	6
-#define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
-#define VTCR_EL2_T0SZ_MASK	0x3f
-#define VTCR_EL2_VS_SHIFT	19
-#define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
-#define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
-
-#define VTCR_EL2_T0SZ(x)	TCR_T0SZ(x)
+#define VTCR_T0SZ(x) ((UL(64) - (x)) << VTCR_EL2_T0SZ_SHIFT)
 
 /*
  * We configure the Stage-2 page tables to always restrict the IPA space to be
@@ -148,8 +124,10 @@
  *
  */
 
-#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
-				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
+#define VTCR_EL2_COMMON_BITS	((VTCR_EL2_SH0_INNER << VTCR_EL2_SH0_SHIFT) | \
+				 (VTCR_EL2_ORGN0_WBWA << VTCR_EL2_ORGN0_SHIFT) | \
+				 (VTCR_EL2_IRGN0_WBWA << VTCR_EL2_IRGN0_SHIFT) | \
+				 (VTCR_EL2_RES1))
 
 /*
  * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 112d5d0acb50..ea0a7e5a8628 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -524,7 +524,6 @@
 #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
 #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
-#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..c1607b5b7cbf 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -584,7 +584,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	s8 lvls;
 
 	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
-	vtcr |= VTCR_EL2_T0SZ(phys_shift);
+	vtcr |= VTCR_T0SZ(phys_shift);
 	/*
 	 * Use a minimum 2 level page table to prevent splitting
 	 * host PMD huge pages at stage2.
@@ -625,8 +625,8 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
-		VTCR_EL2_VS_16BIT :
-		VTCR_EL2_VS_8BIT;
+		SYS_FIELD_PREP_ENUM(VTCR_EL2, VS, 16BIT) :
+		SYS_FIELD_PREP_ENUM(VTCR_EL2, VS, 8BIT);
 
 	return vtcr;
 }
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7b1802a4072e..34d8d192d5c2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -336,7 +336,7 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 {
 	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
 
-	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	switch (SYS_FIELD_GET(VTCR_EL2, TG0, vtcr)) {
 	case VTCR_EL2_TG0_4K:
 		wi->pgshift = 12;	 break;
 	case VTCR_EL2_TG0_16K:
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index d2b40105eb41..f5a0a304f844 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4910,6 +4910,63 @@ Field	1	PIE
 Field	0	PnCH
 EndSysreg
 
+Sysreg	VTCR_EL2	3	4	2	1	2
+Res0	63:46
+Field	45	HDBSS
+Field	44	HAFT
+Res0	43:42
+Field	41	TL0
+Field	40	GCSH
+Res0	39
+Field	38	D128
+Field	37	S2POE
+Field	36	S2PIE
+Field	35	TL1
+Field	34	AssuredOnly
+Field	33	SL2
+Field	32	DS
+Res1	31
+Field	30	NSA
+Field	29	NSW
+Field	28	HWU62
+Field	27	HWU61
+Field	26	HWU60
+Field	25	HWU59
+Res0	24:23
+Field	22	HD
+Field	21	HA
+Res0	20
+UnsignedEnum	19	VS
+	0b0	8BIT
+	0b1	16BIT
+EndEnum
+Field	18:16	PS
+UnsignedEnum	15:14	TG0
+		0b00	4K
+		0b01	64K
+		0b10	16K
+EndEnum
+UnsignedEnum	13:12	SH0
+		0b00	NONE
+		0b10	OUTER
+		0b11	INNER
+EndEnum
+UnsignedEnum	11:10	ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+UnsignedEnum	9:8	IRGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Field	7:6	SL0
+Field	5:0	T0SZ
+EndSysreg
+
 SysregFields MAIR2_ELx
 Field	63:56	Attr7
 Field	55:48	Attr6
-- 
2.25.1

