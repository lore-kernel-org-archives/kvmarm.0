Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2299D21C9E0;
	Mon,  7 Apr 2025 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047751; cv=none; b=PY9h20T9FjSKyGEHYUKeO/0qWSAlolsjmN4pApJwODNS+Gq+CtHBUF/eAL/pMWgCRB7bgepvQ/hcfMN0w20exPhmntsQXVzgveBuM0J8GFfScOInDKYfCS4DUBG3GxstUqCioZ9zU0xF3GJ8SPePC9ZK9u6gwBCbC4KBJW99M2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047751; c=relaxed/simple;
	bh=nmLiqJamG5V2Ys3W6lwPvxgJ53poaGnijKkT4FeQwME=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H2JTFqZ/uijSjXNuq0t79apV6isJdziPnrhoEVhnr02v82yYyPk+EGXlSGCRzeDSghHkyBQvTiBTku1u+tuDUg0SJJXwelF02GkyOnKKv97EPezTf1Aj5vDQ7rRGJoSzy1NQ6ouN54EVzfAI3A68nO/3/bbQFNTtMViRPDzu5Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRLjMRHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRLjMRHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F695C4CEDD;
	Mon,  7 Apr 2025 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744047750;
	bh=nmLiqJamG5V2Ys3W6lwPvxgJ53poaGnijKkT4FeQwME=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XRLjMRHlTDivIg6LYFuBPUsdJYmp3nUkVnMM2YxlCicRLKBbB5qQcCe9dT2CZqx9y
	 zuNkccOrVq2/SeqGnVprwBjrmLXQ1BBvVqnUXp22yan6nqviXCEwlj/cyCxlcrtu1+
	 /23UcDZ8cYiWxWWu8nzyDr3Xk6HF9icuUCn8YPIL+liD/mIAFjitghkPWU15w0fPJV
	 Qetpi78KO8aDSUMQpmwJAahyq1YtpgB4RHBhuW6kB3cuNLDdfXPMIdYFSQJrJyd5+n
	 byRPVTirXCkyuq43I7bcUkCz0s/1V3vuHMYdFoA8csyx976g1txCxMEl7WHjFsdvjL
	 n1SwEoBRcO9tA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Mon, 07 Apr 2025 12:41:31 -0500
Subject: [PATCH v21 2/4] arm64: Handle BRBE booting requirements
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250407-arm-brbe-v19-v21-2-ff187ff6c928@kernel.org>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
In-Reply-To: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

To use the Branch Record Buffer Extension (BRBE), some configuration is
necessary at EL3 and EL2. This patch documents the requirements and adds
the initial EL2 setup code, which largely consists of configuring the
fine-grained traps and initializing a couple of BRBE control registers.

Before this patch, __init_el2_fgt() would initialize HDFGRTR_EL2 and
HDFGWTR_EL2 with the same value, relying on the read/write trap controls
for a register occupying the same bit position in either register. The
'nBRBIDR' trap control only exists in bit 59 of HDFGRTR_EL2, while bit
59 of HDFGWTR_EL2 is RES0, and so this assumption no longer holds.

To handle HDFGRTR_EL2 and HDFGWTR_EL2 having (slightly) different bit
layouts, __init_el2_fgt() is changed to accumulate the HDFGRTR_EL2 and
HDFGWTR_EL2 control bits separately. While making this change the
open-coded value (1 << 62) is replaced with
HDFG{R,W}TR_EL2_nPMSNEVFR_EL1_MASK.

The BRBCR_EL1 and BRBCR_EL2 registers are unusual and require special
initialisation: even though they are subject to E2H renaming, both have
an effect regardless of HCR_EL2.TGE, even when running at EL2, and
consequently both need to be initialised. This is handled in
__init_el2_brbe() with a comment to explain the situation.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
[Mark: rewrite commit message, fix typo in comment]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Tested-by: James Clark <james.clark@linaro.org>
---
v20:
 - Document that MDCR_EL3.SBRBE can be 0b01 also
 - Fix "HDFGWTR_EL2 is RES0" in commit msg
---
 Documentation/arch/arm64/booting.rst | 21 +++++++++
 arch/arm64/include/asm/el2_setup.h   | 86 ++++++++++++++++++++++++++++++++++--
 2 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index dee7b6de864f..a627c1e0e4a0 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -358,6 +358,27 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HWFGWTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
 
+  For CPUs with feature Branch Record Buffer Extension (FEAT_BRBE):
+
+  - If EL3 is present:
+
+    - MDCR_EL3.SBRBE (bits 33:32) must be initialised to 0b01 or 0b11.
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - BRBCR_EL2.CC (bit 3) must be initialised to 0b1.
+    - BRBCR_EL2.MPRED (bit 4) must be initialised to 0b1.
+
+    - HDFGRTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
+    - HDFGRTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
+    - HDFGRTR_EL2.nBRBIDR  (bit 59) must be initialised to 0b1.
+
+    - HDFGWTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
+    - HDFGWTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
+
+    - HFGITR_EL2.nBRBIALL (bit 56) must be initialised to 0b1.
+    - HFGITR_EL2.nBRBINJ  (bit 55) must be initialised to 0b1.
+
   For CPUs with the Scalable Matrix Extension FA64 feature (FEAT_SME_FA64):
 
   - If EL3 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index ebceaae3c749..e7fcba1e7d8e 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -189,6 +189,39 @@
 .Lskip_set_cptr_\@:
 .endm
 
+/*
+ * Configure BRBE to permit recording cycle counts and branch mispredicts.
+ *
+ * At any EL, to record cycle counts BRBE requires that both BRBCR_EL2.CC=1 and
+ * BRBCR_EL1.CC=1.
+ *
+ * At any EL, to record branch mispredicts BRBE requires that both
+ * BRBCR_EL2.MPRED=1 and BRBCR_EL1.MPRED=1.
+ *
+ * When HCR_EL2.E2H=1, the BRBCR_EL1 encoding is redirected to BRBCR_EL2, but
+ * the {CC,MPRED} bits in the real BRBCR_EL1 register still apply.
+ *
+ * Set {CC,MPRED} in both BRBCR_EL2 and BRBCR_EL1 so that at runtime we only
+ * need to enable/disable these in BRBCR_EL1 regardless of whether the kernel
+ * ends up executing in EL1 or EL2.
+ */
+.macro __init_el2_brbe
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
+	cbz	x1, .Lskip_brbe_\@
+
+	mov_q	x0, BRBCR_ELx_CC | BRBCR_ELx_MPRED
+	msr_s	SYS_BRBCR_EL2, x0
+
+	__check_hvhe .Lset_brbe_nvhe_\@, x1
+	msr_s	SYS_BRBCR_EL12, x0	// VHE
+	b	.Lskip_brbe_\@
+
+.Lset_brbe_nvhe_\@:
+	msr_s	SYS_BRBCR_EL1, x0	// NVHE
+.Lskip_brbe_\@:
+.endm
+
 /* Disable any fine grained traps */
 .macro __init_el2_fgt
 	mrs	x1, id_aa64mmfr0_el1
@@ -196,16 +229,48 @@
 	cbz	x1, .Lskip_fgt_\@
 
 	mov	x0, xzr
+	mov	x2, xzr
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
 	cmp	x1, #3
 	b.lt	.Lskip_spe_fgt_\@
+
 	/* Disable PMSNEVFR_EL1 read and write traps */
-	orr	x0, x0, #(1 << 62)
+	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
+	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK
 
 .Lskip_spe_fgt_\@:
+#ifdef CONFIG_ARM64_BRBE
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
+	cbz	x1, .Lskip_brbe_reg_fgt_\@
+
+	/*
+	 * Disable read traps for the following registers
+	 *
+	 * [BRBSRC|BRBTGT|RBINF]_EL1
+	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
+	 */
+	orr	x0, x0, #HDFGRTR_EL2_nBRBDATA_MASK
+
+	/*
+	 * Disable write traps for the following registers
+	 *
+	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
+	 */
+	orr	x2, x2, #HDFGWTR_EL2_nBRBDATA_MASK
+
+	/* Disable read and write traps for [BRBCR|BRBFCR]_EL1 */
+	orr	x0, x0, #HDFGRTR_EL2_nBRBCTL_MASK
+	orr	x2, x2, #HDFGWTR_EL2_nBRBCTL_MASK
+
+	/* Disable read traps for BRBIDR_EL1 */
+	orr	x0, x0, #HDFGRTR_EL2_nBRBIDR_MASK
+
+.Lskip_brbe_reg_fgt_\@:
+#endif /* CONFIG_ARM64_BRBE */
 	msr_s	SYS_HDFGRTR_EL2, x0
-	msr_s	SYS_HDFGWTR_EL2, x0
+	msr_s	SYS_HDFGWTR_EL2, x2
 
 	mov	x0, xzr
 	mrs	x1, id_aa64pfr1_el1
@@ -246,7 +311,21 @@
 .Lset_fgt_\@:
 	msr_s	SYS_HFGRTR_EL2, x0
 	msr_s	SYS_HFGWTR_EL2, x0
-	msr_s	SYS_HFGITR_EL2, xzr
+	mov	x0, xzr
+#ifdef CONFIG_ARM64_BRBE
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
+	cbz	x1, .Lskip_brbe_insn_fgt_\@
+
+	/* Disable traps for BRBIALL instruction */
+	orr	x0, x0, #HFGITR_EL2_nBRBIALL_MASK
+
+	/* Disable traps for BRBINJ instruction */
+	orr	x0, x0, #HFGITR_EL2_nBRBINJ_MASK
+
+.Lskip_brbe_insn_fgt_\@:
+#endif /* CONFIG_ARM64_BRBE */
+	msr_s	SYS_HFGITR_EL2, x0
 
 	mrs	x1, id_aa64pfr0_el1		// AMU traps UNDEF without AMU
 	ubfx	x1, x1, #ID_AA64PFR0_EL1_AMU_SHIFT, #4
@@ -320,6 +399,7 @@
 	__init_el2_hcrx
 	__init_el2_timers
 	__init_el2_debug
+	__init_el2_brbe
 	__init_el2_lor
 	__init_el2_stage2
 	__init_el2_gicv3

-- 
2.47.2

