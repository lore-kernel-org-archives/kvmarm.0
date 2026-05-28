Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4BD2E7396
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987315; cv=none; b=nZPygG9mqpAty+essRuMx9vn0Fz3GFCN6QvchFXmQn7ICCJvqfKjSQtrXqHo8T7moiZTF+786Hp3ikDYh1O5b6Fc9SXMZ7zYj4j0Yt/xTYHS+zyRNifz0eG0J7AlvfuNzuW1/II2FvhXiuDHua4vZ1bTMpT3ipGUN6OC190h+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987315; c=relaxed/simple;
	bh=AGrOd3maVfHw9KqMwfvglX6A7MxlCueuD5iraJcfrUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZWcmm66faeJcS/B/vLeh/3fFpF3qHJ6xsNowFD3Ab7ePS3VBr6E685NpN6Afw5DbiIKmL1A/NVjh6OiWYsvceesi0EzvfErcYrTQBfpJmcFIMnFe7jkcfEy/xnOQXlD69PlSGNRsUFjZ1D5BezShCmO19aRSdWCEOE0ER1LZEws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VQe/DsSe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VQe/DsSe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A245460D;
	Thu, 28 May 2026 09:55:08 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 075753F905;
	Thu, 28 May 2026 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987313; bh=AGrOd3maVfHw9KqMwfvglX6A7MxlCueuD5iraJcfrUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQe/DsSeDWifdu3qam3AubJ1kghECc4gwfKiztxKo64pDA5+BzYOYleCL9QJF1o60
	 wj8KT0OEC35ree5kRyFxui9adJxj/6migQzmKMvAHVsGR4/CbFAVoyjuH0X3ZTxOki
	 h//GJX1eC+2ADoqVH7vEB6ZNuhnlNqrazOUXiyb0=
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
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v2 09/18] arm64: fpsimd: Move sve_get_vl() and sme_get_vl() inline
Date: Thu, 28 May 2026 17:54:37 +0100
Message-Id: <20260528165446.701944-10-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528165446.701944-1-mark.rutland@arm.com>
References: <20260528165446.701944-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sve_get_vl() and sme_get_vl() functions are wrappers for the RDVL
and RDSVL instructions respectively. There's no need for those to be
out-of-line.

Replace the out-of-line assembly functions with equivalent inline
functions.

The _sve_rdvl assembly macro is unused, and so it is removed. The
_sme_rdsvl assembly macro is still used elsewhere, and so is kept for
now.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h       | 31 +++++++++++++++++++++++++--
 arch/arm64/include/asm/fpsimdmacros.h |  6 ------
 arch/arm64/kernel/entry-fpsimd.S      | 10 ---------
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 8efa3c0402a7a..36cf528e64971 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -22,6 +22,9 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 
+#define __SVE_PREAMBLE		".arch_extension sve\n"
+#define __SME_PREAMBLE		".arch_extension sme\n"
+
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
 #define VFP_FPSCR_STAT_MASK	0xf800009f
 #define VFP_FPSCR_CTRL_MASK	0x07f79f00
@@ -141,11 +144,23 @@ static inline void *thread_zt_state(struct thread_struct *thread)
 	return thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
 }
 
+static inline unsigned int sve_get_vl(void)
+{
+	unsigned int vl;
+
+	asm volatile(
+	__SVE_PREAMBLE
+	"	rdvl %x[vl], #1\n"
+	: [vl] "=r" (vl)
+	);
+
+	return vl;
+}
+
 extern void sve_save_state(void *state, u32 *pfpsr, int save_ffr);
 extern void sve_load_state(void const *state, u32 const *pfpsr,
 			   int restore_ffr);
 extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
-extern unsigned int sve_get_vl(void);
 extern void sme_save_state(void *state, int zt);
 extern void sme_load_state(void const *state, int zt);
 
@@ -400,8 +415,20 @@ static inline int sme_max_virtualisable_vl(void)
 	return vec_max_virtualisable_vl(ARM64_VEC_SME);
 }
 
+static inline unsigned int sme_get_vl(void)
+{
+	unsigned int vl;
+
+	asm volatile(
+	__SME_PREAMBLE
+	"	rdsvl %x[vl], #1\n"
+	: [vl] "=r" (vl)
+	);
+
+	return vl;
+}
+
 extern void sme_alloc(struct task_struct *task, bool flush);
-extern unsigned int sme_get_vl(void);
 extern int sme_set_current_vl(unsigned long arg);
 extern int sme_get_current_vl(void);
 extern void sme_suspend_exit(void);
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index 4a9bf46e52913..c724fcad7ee02 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -125,12 +125,6 @@
 	ldr p\np, [x\nxbase, #\offset, MUL VL]
 .endm
 
-/* RDVL X\nx, #\imm */
-.macro _sve_rdvl nx, imm
-	.arch_extension sve
-	rdvl x\nx, #\imm
-.endm
-
 /* RDFFR (unpredicated): RDFFR P\np.B */
 .macro _sve_rdffr np
 	.arch_extension sve
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index 88c555745b584..7f2d31dff8c17 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -57,11 +57,6 @@ SYM_FUNC_START(sve_load_state)
 	ret
 SYM_FUNC_END(sve_load_state)
 
-SYM_FUNC_START(sve_get_vl)
-	_sve_rdvl	0, 1
-	ret
-SYM_FUNC_END(sve_get_vl)
-
 /*
  * Zero all SVE registers but the first 128-bits of each vector
  *
@@ -84,11 +79,6 @@ SYM_FUNC_END(sve_flush_live)
 
 #ifdef CONFIG_ARM64_SME
 
-SYM_FUNC_START(sme_get_vl)
-	_sme_rdsvl	0, 1
-	ret
-SYM_FUNC_END(sme_get_vl)
-
 /*
  * Save the ZA and ZT state
  *
-- 
2.30.2

