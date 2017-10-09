From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/10] arm64: KVM: Add invalidate_icache_range helper
Date: Mon,  9 Oct 2017 16:20:24 +0100
Message-ID: <20171009152032.27804-3-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We currently tightly couple dcache clean with icache invalidation,
but KVM could do without the initial flush to PoU, as we've
already flushed things to PoC.

Let's introduce invalidate_icache_range which is limited to
invalidating the icache from the linear mapping (and thus
has none of the userspace fault handling complexity), and
wire it in KVM instead of flush_icache_range.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cacheflush.h |  8 ++++++++
 arch/arm64/include/asm/kvm_mmu.h    |  4 ++--
 arch/arm64/mm/cache.S               | 24 ++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 76d1cc85d5b1..ad56406944c6 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -52,6 +52,13 @@
  *		- start  - virtual start address
  *		- end    - virtual end address
  *
+ *	invalidate_icache_range(start, end)
+ *
+ *		Invalidate the I-cache in the region described by start, end.
+ *		Linear mapping only!
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
  *	__flush_cache_user_range(start, end)
  *
  *		Ensure coherency between the I-cache and the D-cache in the
@@ -66,6 +73,7 @@
  *		- size   - region size
  */
 extern void flush_icache_range(unsigned long start, unsigned long end);
+extern void invalidate_icache_range(unsigned long start, unsigned long end);
 extern void __flush_dcache_area(void *addr, size_t len);
 extern void __inval_dcache_area(void *addr, size_t len);
 extern void __clean_dcache_area_poc(void *addr, size_t len);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 4c4cb4f0e34f..48d31ca2ce9c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -250,8 +250,8 @@ static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
 		void *va = page_address(pfn_to_page(pfn));
 
-		flush_icache_range((unsigned long)va,
-				   (unsigned long)va + size);
+		invalidate_icache_range((unsigned long)va,
+					(unsigned long)va + size);
 	}
 }
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 7f1dbe962cf5..0c330666a8c9 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -80,6 +80,30 @@ USER(9f, ic	ivau, x4	)		// invalidate I line PoU
 ENDPROC(flush_icache_range)
 ENDPROC(__flush_cache_user_range)
 
+/*
+ *	invalidate_icache_range(start,end)
+ *
+ *	Ensure that the I cache is invalid within specified region. This
+ *	assumes that this is done on the linear mapping. Do not use it
+ *	on a userspace range, as this may fault horribly.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(invalidate_icache_range)
+	icache_line_size x2, x3
+	sub	x3, x2, #1
+	bic	x4, x0, x3
+1:
+	ic	ivau, x4			// invalidate I line PoU
+	add	x4, x4, x2
+	cmp	x4, x1
+	b.lo	1b
+	dsb	ish
+	isb
+	ret
+ENDPROC(invalidate_icache_range)
+
 /*
  *	__flush_dcache_area(kaddr, size)
  *
-- 
2.14.1
