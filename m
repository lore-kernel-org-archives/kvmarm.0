Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE14729D294
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370002; cv=none; b=N2M1ipxTiVnOBTxQaWMmu95x0ARnVH/QMHS9ZAQuUhx0RSAARR+Pt8P484pb+O/Ci/d+Mjr6tea7bM5j2332efEEsTFmWxTZAkUFDo7cRFAR+CY26j/idBnd5CccAr4a3KmWD7tId2KqtjGcXIhqox4ILo+ZC6/6RPx+jd5vong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370002; c=relaxed/simple;
	bh=JlArOMwZiEHzbftaOWNW/ZT/WEfA2atdibRPlbxCOjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLtSsmckReQzIEvJIJipf94FI7mRQPoKscCejc84+QZhg6DmjUzuHs5YRtbJBFVnI3w1QR04Rg567mNI7iXwTY2OM2DIi65ov5h7rLP50j9bBv0pUseWkj7CaVg+slLU66cgnkouhrXivTbrDRIbenZFSRJuQWTBMQh8koyXlMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ivNPBBTR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ivNPBBTR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21FCC2BCB;
	Thu, 21 May 2026 06:26:35 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EEF613F7B4;
	Thu, 21 May 2026 06:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779370000; bh=JlArOMwZiEHzbftaOWNW/ZT/WEfA2atdibRPlbxCOjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivNPBBTRw93e+c4h/Nf9LyCSyCtf42TsbCe5D6a9ol0iicFBJ1Ojonx0A+UQJQa/7
	 Wj73qLxN0rAAegmZVarSS8STFWrMOeEvjdaFQXYEcYZL236h1mJNZOzwD4hGoblZmi
	 I2NT3PhzVPT3dPag4tF0vmBAj2ga5rdO3OGMod1I=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 16/18] arm64: fpsimd: Move sve_flush_live() inline
Date: Thu, 21 May 2026 14:25:54 +0100
Message-Id: <20260521132556.584676-17-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently sve_flush_live() is written in out-of-line assembly. It would
be nice if we could move it inline such that control flow can be written
more clearly in C, and to permit the removal of otherwise unused
assembly macros.

The 'flush_ffr' argument is redundant as sve_flush_live() is always
called from non-streaming mode, and all callers pass 'true'. Remove the
argument and make it a requirement that the function is called from
non-streaming mode.

The 'vq_minus_1' argument is unnecessary, as sve_flush_live() can read
the live VL directly using the RDVL instruction (wrapped by the
sve_get_vl() helper function).

Move the function to C, with the simplifications above.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h       | 26 +++++++++++++++++++++++-
 arch/arm64/include/asm/fpsimdmacros.h | 29 ---------------------------
 arch/arm64/kernel/entry-common.c      |  8 ++------
 arch/arm64/kernel/entry-fpsimd.S      | 22 --------------------
 arch/arm64/kernel/fpsimd.c            |  2 +-
 5 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index d005324bbcf3e..550987b36206a 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -332,7 +332,31 @@ static inline void sve_load_state(const struct sve_state *state, bool ffr)
 	__sve_load_p(state, vl, ffr);
 }
 
-extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
+
+/*
+ * Zero all SVE registers except for the first 128 bits of each vector.
+ *
+ * The caller must ensure that the VL has been configured and the CPU must be
+ * in non-streaming mode.
+ */
+static inline void sve_flush_live(void)
+{
+	unsigned long vl = sve_get_vl();
+
+	if (vl > sizeof(__uint128_t)) {
+		asm volatile(
+		__FPSIMD_PREAMBLE
+		FOR_EACH_Z_REG("n", "mov	v\\n\\().16b, v\\n\\().16b")
+		);
+	}
+
+	asm volatile(
+	__SVE_PREAMBLE
+	FOR_EACH_P_REG("n", "pfalse	p\\n\\().b")
+	"	wrffr	p0.b\n"
+	);
+}
+
 extern void sme_save_state(struct sme_state *state, int zt);
 extern void sme_load_state(const struct sme_state *state, int zt);
 
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index ebf8b47313e90..9e352b5c6b764 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -40,19 +40,6 @@
 	.endif
 .endm
 
-/* Deprecated macros for SVE instructions */
-
-/* WRFFR P\np.B */
-.macro _sve_wrffr np
-	wrffr p\np\().b
-.endm
-
-/* PFALSE P\np.B */
-.macro _sve_pfalse np
-	.arch_extension sve
-	pfalse	p\np\().b
-.endm
-
 /* Deprecated macros for SME instructions */
 
 /* RDSVL X\nx, #\imm */
@@ -130,22 +117,6 @@
 	.purgem _for__body
 .endm
 
-/* Preserve the first 128-bits of Znz and zero the rest. */
-.macro _sve_flush_z nz
-	_sve_check_zreg \nz
-	mov	v\nz\().16b, v\nz\().16b
-.endm
-
-.macro sve_flush_z
- _for n, 0, 31, _sve_flush_z	\n
-.endm
-.macro sve_flush_p
- _for n, 0, 15, _sve_pfalse	\n
-.endm
-.macro sve_flush_ffr
-		_sve_wrffr	0
-.endm
-
 .macro sme_save_za nxbase, xvl, nw
 	mov	w\nw, #0
 
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index cb54335465f66..2352297330e12 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -237,12 +237,8 @@ static inline void fpsimd_syscall_enter(void)
 	if (!system_supports_sve())
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
-		unsigned int sve_vq_minus_one;
-
-		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;
-		sve_flush_live(true, sve_vq_minus_one);
-	}
+	if (test_thread_flag(TIF_SVE))
+		sve_flush_live();
 
 	/*
 	 * Any live non-FPSIMD SVE state has been zeroed. Allow
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index 0575d90e6dffb..bff941eea9566 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -11,28 +11,6 @@
 #include <asm/assembler.h>
 #include <asm/fpsimdmacros.h>
 
-#ifdef CONFIG_ARM64_SVE
-
-/*
- * Zero all SVE registers but the first 128-bits of each vector
- *
- * VQ must already be configured by caller, any further updates of VQ
- * will need to ensure that the register state remains valid.
- *
- * x0 = include FFR?
- * x1 = VQ - 1
- */
-SYM_FUNC_START(sve_flush_live)
-	cbz		x1, 1f	// A VQ-1 of 0 is 128 bits so no extra Z state
-	sve_flush_z
-1:	sve_flush_p
-	tbz		x0, #0, 2f
-	sve_flush_ffr
-2:	ret
-SYM_FUNC_END(sve_flush_live)
-
-#endif /* CONFIG_ARM64_SVE */
-
 #ifdef CONFIG_ARM64_SME
 
 /*
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index f9b3eeacf130d..42177b439b3c7 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1338,7 +1338,7 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		unsigned long vq = sve_vq_from_vl(task_get_sve_vl(current));
 		sysreg_clear_set_s(SYS_ZCR_EL1, ZCR_ELx_LEN, vq - 1);
-		sve_flush_live(true, vq - 1);
+		sve_flush_live();
 		fpsimd_bind_task_to_cpu();
 	} else {
 		fpsimd_to_sve(current);
-- 
2.30.2

