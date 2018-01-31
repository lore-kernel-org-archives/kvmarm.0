From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 15/28] arm64: KVM: Add invalidate_icache_range helper
Date: Wed, 31 Jan 2018 10:34:54 +0100
Message-ID: <20180131093507.22219-16-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We currently tightly couple dcache clean with icache invalidation,
but KVM could do without the initial flush to PoU, as we've
already flushed things to PoC.

Let's introduce invalidate_icache_range which is limited to
invalidating the icache from the linear mapping (and thus
has none of the userspace fault handling complexity), and
wire it in KVM instead of flush_icache_range.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/assembler.h  | 21 +++++++++++++++++++++
 arch/arm64/include/asm/cacheflush.h |  7 +++++++
 arch/arm64/include/asm/kvm_mmu.h    |  4 ++--
 arch/arm64/mm/cache.S               | 32 ++++++++++++++++++++++----------
 4 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index aef72d886677..0884e1fdfd30 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -387,6 +387,27 @@ alternative_endif
 	dsb	\domain
 	.endm
 
+/*
+ * Macro to perform an instruction cache maintenance for the interval
+ * [start, end)
+ *
+ * 	start, end:	virtual addresses describing the region
+ *	label:		A label to branch to on user fault.
+ * 	Corrupts:	tmp1, tmp2
+ */
+	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label
+	icache_line_size \tmp1, \tmp2
+	sub	\tmp2, \tmp1, #1
+	bic	\tmp2, \start, \tmp2
+9997:
+USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
+	add	\tmp2, \tmp2, \tmp1
+	cmp	\tmp2, \end
+	b.lo	9997b
+	dsb	ish
+	isb
+	.endm
+
 /*
  * reset_pmuserenr_el0 - reset PMUSERENR_EL0 if PMUv3 present
  */
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 955130762a3c..bef9f418f089 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -52,6 +52,12 @@
  *		- start  - virtual start address
  *		- end    - virtual end address
  *
+ *	invalidate_icache_range(start, end)
+ *
+ *		Invalidate the I-cache in the region described by start, end.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
  *	__flush_cache_user_range(start, end)
  *
  *		Ensure coherency between the I-cache and the D-cache in the
@@ -66,6 +72,7 @@
  *		- size   - region size
  */
 extern void flush_icache_range(unsigned long start, unsigned long end);
+extern int  invalidate_icache_range(unsigned long start, unsigned long end);
 extern void __flush_dcache_area(void *addr, size_t len);
 extern void __inval_dcache_area(void *addr, size_t len);
 extern void __clean_dcache_area_poc(void *addr, size_t len);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8034b96fb3a4..56b3e03c85e7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -250,8 +250,8 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
 		void *va = page_address(pfn_to_page(pfn));
 
-		flush_icache_range((unsigned long)va,
-				   (unsigned long)va + size);
+		invalidate_icache_range((unsigned long)va,
+					(unsigned long)va + size);
 	}
 }
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 7f1dbe962cf5..bedd23da83f4 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -60,16 +60,7 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	b.lo	1b
 	dsb	ish
 
-	icache_line_size x2, x3
-	sub	x3, x2, #1
-	bic	x4, x0, x3
-1:
-USER(9f, ic	ivau, x4	)		// invalidate I line PoU
-	add	x4, x4, x2
-	cmp	x4, x1
-	b.lo	1b
-	dsb	ish
-	isb
+	invalidate_icache_by_line x0, x1, x2, x3, 9f
 	mov	x0, #0
 1:
 	uaccess_ttbr0_disable x1
@@ -80,6 +71,27 @@ USER(9f, ic	ivau, x4	)		// invalidate I line PoU
 ENDPROC(flush_icache_range)
 ENDPROC(__flush_cache_user_range)
 
+/*
+ *	invalidate_icache_range(start,end)
+ *
+ *	Ensure that the I cache is invalid within specified region.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(invalidate_icache_range)
+	uaccess_ttbr0_enable x2, x3
+
+	invalidate_icache_by_line x0, x1, x2, x3, 2f
+	mov	x0, xzr
+1:
+	uaccess_ttbr0_disable x1
+	ret
+2:
+	mov	x0, #-EFAULT
+	b	1b
+ENDPROC(invalidate_icache_range)
+
 /*
  *	__flush_dcache_area(kaddr, size)
  *
-- 
2.14.2
