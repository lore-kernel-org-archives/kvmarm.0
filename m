Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE261D9A46
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 11:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903727; cv=none; b=DB4G0KiFFRkGHzBQbeeFhbCDho4BHEoiLMZbbESZFQMUhplUYEH3ncHUvTorG9+OY09aNBmhttScF52MOd+LOC0CJNzpvqiJ98gorO7ptQjj7ZAJUUIyPq1OQul057+2zjN21bOJ/K9bFTueb89hl+QPoIdHe18lYgqOYRSlQxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903727; c=relaxed/simple;
	bh=BKIWzn9UnlQ2N8rj7swnRq+vBQjr60y2aGLASxxR9f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhiVmUJ3QI8rJ/UIMqNjZZ6wrOJVfjZbPnI9vBUFgxUezn6t5F3ZysbRRz9bf1pDfEAm8MR0SfVTNvUDrTiPwFhVwU10dUxHtDUGdVumDRSMbRHXOXSJAUVyp01ZukpgD7VUO2XLMdhARhNRlr4YLSZbTk0KycI0ie/QcjGCunc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 926581A2D;
	Mon, 14 Oct 2024 04:02:34 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55EA53F51B;
	Mon, 14 Oct 2024 04:02:02 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Marsden <greg.marsden@oracle.com>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matthias Brugger <mbrugger@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 52/57] arm64: Remove PAGE_SIZE from assembly code
Date: Mon, 14 Oct 2024 11:58:59 +0100
Message-ID: <20241014105912.3207374-52-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014105912.3207374-1-ryan.roberts@arm.com>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove usage of PAGE_SHIFT, PAGE_SIZE and PAGE_MASK macros from assembly
code since these are no longer compile-time constants when boot-time
page size is in use.

For the most part, they are replaced with run-time lookups based on the
value of TG0. This is done outside of loops so while there is a cost of
a few extra instructions, performance should not be impacted.

However, invalid_host_el2_vect requires that the page shift be an
immediate since it has no registers to spare. So for this, let's use
alternatives patching. This code is guarranteed not to run until after
patching is complete.

__pi_copy_page has no registers to spare to hold the page size, and we
want to avoid having to reload it on every iteration of the loop. Since
I couldn't provably conclude that the function is not called prior to
alternatives patching, I opted to make a copy of the function for each
page size and branch to the right one at the start.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---

***NOTE***
Any confused maintainers may want to read the cover note here for context:
https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/

 arch/arm64/include/asm/assembler.h  | 18 +++++++++++++---
 arch/arm64/kernel/hibernate-asm.S   |  6 ++++--
 arch/arm64/kernel/relocate_kernel.S | 10 ++++++---
 arch/arm64/kvm/hyp/nvhe/host.S      | 10 ++++++++-
 arch/arm64/lib/clear_page.S         |  7 ++++--
 arch/arm64/lib/copy_page.S          | 33 +++++++++++++++++++++--------
 arch/arm64/lib/mte.S                | 27 +++++++++++++++++------
 7 files changed, 85 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 77c2d707adb1a..6424fd6be1cbe 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -495,9 +495,11 @@ alternative_endif
 .Lskip_\@:
 	.endm
 /*
- * copy_page - copy src to dest using temp registers t1-t8
+ * copy_page - copy src to dest using temp registers t1-t9
  */
-	.macro copy_page dest:req src:req t1:req t2:req t3:req t4:req t5:req t6:req t7:req t8:req
+	.macro copy_page dest:req src:req t1:req t2:req t3:req t4:req t5:req t6:req t7:req t8:req t9:req
+	get_page_size \t9
+	sub	\t9, \t9, #1			// (PAGE_SIZE - 1) in \t9
 9998:	ldp	\t1, \t2, [\src]
 	ldp	\t3, \t4, [\src, #16]
 	ldp	\t5, \t6, [\src, #32]
@@ -508,7 +510,7 @@ alternative_endif
 	stnp	\t5, \t6, [\dest, #32]
 	stnp	\t7, \t8, [\dest, #48]
 	add	\dest, \dest, #64
-	tst	\src, #(PAGE_SIZE - 1)
+	tst	\src, \t9
 	b.ne	9998b
 	.endm
 
@@ -911,4 +913,14 @@ alternative_cb_end
 	.macro	tgran_lpa2, val, tg0
 	value_for_page_size \val, \tg0, ID_AA64MMFR0_EL1_TGRAN4_52_BIT, ID_AA64MMFR0_EL1_TGRAN16_52_BIT, -1
 	.endm
+
+	.macro	get_page_size, val
+	get_tg0 \val
+	value_for_page_size \val, \val, SZ_4K, SZ_16K, SZ_64K
+	.endm
+
+	.macro	get_page_mask, val
+	get_tg0 \val
+	value_for_page_size \val, \val, (~(SZ_4K-1)), (~(SZ_16K-1)), (~(SZ_64K-1))
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/hibernate-asm.S b/arch/arm64/kernel/hibernate-asm.S
index 0e1d9c3c6a933..375b2fcf82e84 100644
--- a/arch/arm64/kernel/hibernate-asm.S
+++ b/arch/arm64/kernel/hibernate-asm.S
@@ -57,6 +57,8 @@ SYM_CODE_START(swsusp_arch_suspend_exit)
 	mov	x24, x4
 	mov	x25, x5
 
+	get_page_size x12
+
 	/* walk the restore_pblist and use copy_page() to over-write memory */
 	mov	x19, x3
 
@@ -64,9 +66,9 @@ SYM_CODE_START(swsusp_arch_suspend_exit)
 	mov	x0, x10
 	ldr	x1, [x19, #HIBERN_PBE_ADDR]
 
-	copy_page	x0, x1, x2, x3, x4, x5, x6, x7, x8, x9
+	copy_page	x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x11
 
-	add	x1, x10, #PAGE_SIZE
+	add	x1, x10, x12
 	/* Clean the copied page to PoU - based on caches_clean_inval_pou() */
 	raw_dcache_line_size x2, x3
 	sub	x3, x2, #1
diff --git a/arch/arm64/kernel/relocate_kernel.S b/arch/arm64/kernel/relocate_kernel.S
index 413f899e4ac63..bc4f37fba6c74 100644
--- a/arch/arm64/kernel/relocate_kernel.S
+++ b/arch/arm64/kernel/relocate_kernel.S
@@ -46,6 +46,10 @@ SYM_CODE_START(arm64_relocate_new_kernel)
 	ldr	x27, [x0, #KIMAGE_ARCH_EL2_VECTORS]
 	ldr	x26, [x0, #KIMAGE_ARCH_DTB_MEM]
 
+	/* Grab page size values. */
+	get_page_size x10			/* x10 = PAGE_SIZE */
+	get_page_mask x11			/* x11 = PAGE_MASK */
+
 	/* Setup the list loop variables. */
 	ldr	x18, [x0, #KIMAGE_ARCH_ZERO_PAGE] /* x18 = zero page for BBM */
 	ldr	x17, [x0, #KIMAGE_ARCH_TTBR1]	/* x17 = linear map copy */
@@ -54,7 +58,7 @@ SYM_CODE_START(arm64_relocate_new_kernel)
 	raw_dcache_line_size x15, x1		/* x15 = dcache line size */
 	break_before_make_ttbr_switch	x18, x17, x1, x2 /* set linear map */
 .Lloop:
-	and	x12, x16, PAGE_MASK		/* x12 = addr */
+	and	x12, x16, x11			/* x12 = addr */
 	sub	x12, x12, x22			/* Convert x12 to virt */
 	/* Test the entry flags. */
 .Ltest_source:
@@ -62,8 +66,8 @@ SYM_CODE_START(arm64_relocate_new_kernel)
 
 	/* Invalidate dest page to PoC. */
 	mov	x19, x13
-	copy_page x13, x12, x1, x2, x3, x4, x5, x6, x7, x8
-	add	x1, x19, #PAGE_SIZE
+	copy_page x13, x12, x1, x2, x3, x4, x5, x6, x7, x8, x9
+	add	x1, x19, x10
 	dcache_by_myline_op civac, sy, x19, x1, x15, x20
 	b	.Lnext
 .Ltest_indirection:
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d610fc51f4d3..2b0d583fcf1af 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -193,7 +193,15 @@ SYM_FUNC_END(__host_hvc)
 	 */
 	add	sp, sp, x0			// sp' = sp + x0
 	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
-	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
+alternative_if ARM64_USE_PAGE_SIZE_4K
+	tbz	x0, #ARM64_PAGE_SHIFT_4K, .L__hyp_sp_overflow\@
+alternative_else_nop_endif
+alternative_if ARM64_USE_PAGE_SIZE_16K
+	tbz	x0, #ARM64_PAGE_SHIFT_16K, .L__hyp_sp_overflow\@
+alternative_else_nop_endif
+alternative_if ARM64_USE_PAGE_SIZE_64K
+	tbz	x0, #ARM64_PAGE_SHIFT_64K, .L__hyp_sp_overflow\@
+alternative_else_nop_endif
 	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
 	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
 
diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index ebde40e7fa2b2..b6f2cb8d704cc 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -15,6 +15,9 @@
  *	x0 - dest
  */
 SYM_FUNC_START(__pi_clear_page)
+	get_page_size x3
+	sub	x3, x3, #1	/* (PAGE_SIZE - 1) in x3 */
+
 	mrs	x1, dczid_el0
 	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
 	and	w1, w1, #0xf
@@ -23,7 +26,7 @@ SYM_FUNC_START(__pi_clear_page)
 
 1:	dc	zva, x0
 	add	x0, x0, x1
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	1b
 	ret
 
@@ -32,7 +35,7 @@ SYM_FUNC_START(__pi_clear_page)
 	stnp	xzr, xzr, [x0, #32]
 	stnp	xzr, xzr, [x0, #48]
 	add	x0, x0, #64
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	2b
 	ret
 SYM_FUNC_END(__pi_clear_page)
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index 6a56d7cf309da..6c19b03ab4d69 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -10,14 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/alternative.h>
 
-/*
- * Copy a page from src to dest (both are page aligned)
- *
- * Parameters:
- *	x0 - dest
- *	x1 - src
- */
-SYM_FUNC_START(__pi_copy_page)
+	.macro	copy_page_body, page_size
 	ldp	x2, x3, [x1]
 	ldp	x4, x5, [x1, #16]
 	ldp	x6, x7, [x1, #32]
@@ -30,7 +23,7 @@ SYM_FUNC_START(__pi_copy_page)
 	add	x0, x0, #256
 	add	x1, x1, #128
 1:
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, #(\page_size - 1)
 
 	stnp	x2, x3, [x0, #-256]
 	ldp	x2, x3, [x1]
@@ -62,7 +55,29 @@ SYM_FUNC_START(__pi_copy_page)
 	stnp	x12, x13, [x0, #80 - 256]
 	stnp	x14, x15, [x0, #96 - 256]
 	stnp	x16, x17, [x0, #112 - 256]
+	.endm
 
+/*
+ * Copy a page from src to dest (both are page aligned)
+ *
+ * Parameters:
+ *	x0 - dest
+ *	x1 - src
+ */
+SYM_FUNC_START(__pi_copy_page)
+	get_tg0	x2
+.Lsz_64k:
+	cmp	x2, #TCR_TG0_64K
+	b.ne	.Lsz_16k
+	copy_page_body SZ_64K
+	ret
+.Lsz_16k:
+	cmp	x2, #TCR_TG0_16K
+	b.ne	.Lsz_4k
+	copy_page_body SZ_16K
+	ret
+.Lsz_4k:
+	copy_page_body SZ_4K
 	ret
 SYM_FUNC_END(__pi_copy_page)
 SYM_FUNC_ALIAS(copy_page, __pi_copy_page)
diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
index 5018ac03b6bf3..b4f6f5be0ec79 100644
--- a/arch/arm64/lib/mte.S
+++ b/arch/arm64/lib/mte.S
@@ -28,10 +28,13 @@
  *   x0 - address of the page to be cleared
  */
 SYM_FUNC_START(mte_clear_page_tags)
+	get_page_size x3
+	sub	x3, x3, #1		// (PAGE_SIZE - 1) in x3
+
 	multitag_transfer_size x1, x2
 1:	stgm	xzr, [x0]
 	add	x0, x0, x1
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	1b
 	ret
 SYM_FUNC_END(mte_clear_page_tags)
@@ -43,6 +46,9 @@ SYM_FUNC_END(mte_clear_page_tags)
  *	x0 - address to the beginning of the page
  */
 SYM_FUNC_START(mte_zero_clear_page_tags)
+	get_page_size x3
+	sub	x3, x3, #1		// (PAGE_SIZE - 1) in x3
+
 	and	x0, x0, #(1 << MTE_TAG_SHIFT) - 1	// clear the tag
 	mrs	x1, dczid_el0
 	tbnz	x1, #4, 2f	// Branch if DC GZVA is prohibited
@@ -52,12 +58,12 @@ SYM_FUNC_START(mte_zero_clear_page_tags)
 
 1:	dc	gzva, x0
 	add	x0, x0, x1
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	1b
 	ret
 
 2:	stz2g	x0, [x0], #(MTE_GRANULE_SIZE * 2)
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	2b
 	ret
 SYM_FUNC_END(mte_zero_clear_page_tags)
@@ -68,6 +74,9 @@ SYM_FUNC_END(mte_zero_clear_page_tags)
  *   x1 - address of the source page
  */
 SYM_FUNC_START(mte_copy_page_tags)
+	get_page_size x7
+	sub	x7, x7, #1		// (PAGE_SIZE - 1) in x7
+
 	mov	x2, x0
 	mov	x3, x1
 	multitag_transfer_size x5, x6
@@ -75,7 +84,7 @@ SYM_FUNC_START(mte_copy_page_tags)
 	stgm	x4, [x2]
 	add	x2, x2, x5
 	add	x3, x3, x5
-	tst	x2, #(PAGE_SIZE - 1)
+	tst	x2, x7
 	b.ne	1b
 	ret
 SYM_FUNC_END(mte_copy_page_tags)
@@ -137,6 +146,9 @@ SYM_FUNC_END(mte_copy_tags_to_user)
  *   x1 - tag storage, MTE_PAGE_TAG_STORAGE bytes
  */
 SYM_FUNC_START(mte_save_page_tags)
+	get_page_size x3
+	sub	x3, x3, #1		// (PAGE_SIZE - 1) in x3
+
 	multitag_transfer_size x7, x5
 1:
 	mov	x2, #0
@@ -149,7 +161,7 @@ SYM_FUNC_START(mte_save_page_tags)
 
 	str	x2, [x1], #8
 
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	1b
 
 	ret
@@ -161,6 +173,9 @@ SYM_FUNC_END(mte_save_page_tags)
  *   x1 - tag storage, MTE_PAGE_TAG_STORAGE bytes
  */
 SYM_FUNC_START(mte_restore_page_tags)
+	get_page_size x3
+	sub	x3, x3, #1		// (PAGE_SIZE - 1) in x3
+
 	multitag_transfer_size x7, x5
 1:
 	ldr	x2, [x1], #8
@@ -170,7 +185,7 @@ SYM_FUNC_START(mte_restore_page_tags)
 	tst	x0, #0xFF
 	b.ne	2b
 
-	tst	x0, #(PAGE_SIZE - 1)
+	tst	x0, x3
 	b.ne	1b
 
 	ret
-- 
2.43.0

