From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 4/7] arm64: tlbflush.h: add __tlbi() macro
Date: Tue, 16 Aug 2016 11:45:09 +0100
Message-ID: <1471344312-26685-5-git-send-email-punit.agrawal@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

As with dsb() and isb(), add a __tbli() helper so that we can avoid
distracting asm boilerplate every time we want a TLBI. As some TLBI
operations take an argument while others do not, some pre-processor is
used to handle these two cases with different assembly blocks.

The existing tlbflush.h code is moved over to use the helper.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
[ rename helper to __tlbi, update commit log ]
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b460ae2..d57a0be 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -25,6 +25,21 @@
 #include <asm/cputype.h>
 
 /*
+ * Raw TLBI operations. Drivers and most kernel code should use the TLB
+ * management routines below in preference to these. Where necessary, these can
+ * be used to avoid asm() boilerplate.
+ *
+ * Can be used as __tlbi(op) or __tlbi(op, arg), depending on whether a
+ * particular TLBI op takes an argument or not. The macros below handle invoking
+ * the asm with or without the register argument as appropriate.
+ */
+#define TLBI_0(op, arg)		asm ("tlbi " #op)
+#define TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
+#define TLBI_N(op, arg, n, ...)	TLBI_##n(op, arg)
+
+#define __tlbi(op, ...)		TLBI_N(op, ##__VA_ARGS__, 1, 0)
+
+/*
  *	TLB Management
  *	==============
  *
@@ -66,7 +81,7 @@
 static inline void local_flush_tlb_all(void)
 {
 	dsb(nshst);
-	asm("tlbi	vmalle1");
+	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 }
@@ -74,7 +89,7 @@ static inline void local_flush_tlb_all(void)
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	asm("tlbi	vmalle1is");
+	__tlbi(vmalle1is);
 	dsb(ish);
 	isb();
 }
@@ -84,7 +99,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	unsigned long asid = ASID(mm) << 48;
 
 	dsb(ishst);
-	asm("tlbi	aside1is, %0" : : "r" (asid));
+	__tlbi(aside1is, asid);
 	dsb(ish);
 }
 
@@ -94,7 +109,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 	unsigned long addr = uaddr >> 12 | (ASID(vma->vm_mm) << 48);
 
 	dsb(ishst);
-	asm("tlbi	vale1is, %0" : : "r" (addr));
+	__tlbi(vale1is, addr);
 	dsb(ish);
 }
 
@@ -122,9 +137,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	dsb(ishst);
 	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12)) {
 		if (last_level)
-			asm("tlbi vale1is, %0" : : "r"(addr));
+			__tlbi(vale1is, addr);
 		else
-			asm("tlbi vae1is, %0" : : "r"(addr));
+			__tlbi(vae1is, addr);
 	}
 	dsb(ish);
 }
@@ -149,7 +164,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 
 	dsb(ishst);
 	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12))
-		asm("tlbi vaae1is, %0" : : "r"(addr));
+		__tlbi(vaae1is, addr);
 	dsb(ish);
 	isb();
 }
@@ -163,7 +178,7 @@ static inline void __flush_tlb_pgtable(struct mm_struct *mm,
 {
 	unsigned long addr = uaddr >> 12 | (ASID(mm) << 48);
 
-	asm("tlbi	vae1is, %0" : : "r" (addr));
+	__tlbi(vae1is, addr);
 	dsb(ish);
 }
 
-- 
2.8.1
