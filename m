From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2 3/5] arm64: Create and use __tlbi_dsb() macros
Date: Thu, 29 Dec 2016 17:43:33 -0500
Message-ID: <20161229224335.13531-3-cov@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BA1404FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j56hyEaAtO8R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2016 17:42:19 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5B6D40537
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:19 -0500 (EST)
In-Reply-To: <20161229224335.13531-1-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

This refactoring will allow an errata workaround that repeats tlbi dsb
sequences to only change one location. This is not intended to change the
generated assembly and comparing before and after preprocessor output of
arch/arm64/mm/mmu.c and vmlinux objdump show no functional changes.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/include/asm/tlbflush.h | 104 +++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index deab523..f28813c 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -25,22 +25,69 @@
 #include <asm/cputype.h>
 
 /*
- * Raw TLBI operations.
+ * Raw TLBI, DSB operations
  *
- * Where necessary, use the __tlbi() macro to avoid asm()
- * boilerplate. Drivers and most kernel code should use the TLB
- * management routines in preference to the macro below.
+ * Where necessary, use __tlbi_*dsb() macros to avoid asm() boilerplate.
+ * Drivers and most kernel code should use the TLB management routines in
+ * preference to the macros below.
  *
- * The macro can be used as __tlbi(op) or __tlbi(op, arg), depending
- * on whether a particular TLBI operation takes an argument or
- * not. The macros handles invoking the asm with or without the
- * register argument as appropriate.
+ * The __tlbi_dsb() macro handles invoking the asm without any register
+ * argument, with a single register argument, and with start (included)
+ * and end (excluded) range of register arguments. For example:
+ *
+ * __tlbi_dsb(op, attr)
+ *
+ * 	tlbi op
+ *	dsb attr
+ *
+ * __tlbi_dsb(op, attr, addr)
+ *
+ *	mov %[addr], =addr
+ *	tlbi op, %[addr]
+ *	dsb attr
+ *
+ * __tlbi_range_dsb(op, attr, start, end)
+ *
+ * 	mov %[arg], =start
+ *	mov %[end], =end
+ * for:
+ * 	tlbi op, %[addr]
+ * 	add %[addr], %[addr], #(1 << (PAGE_SHIFT - 12))
+ * 	cmp %[addr], %[end]
+ * 	b.ne for
+ * 	dsb attr
  */
-#define __TLBI_0(op, arg)		asm ("tlbi " #op)
-#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
-#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
 
-#define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
+#define __TLBI_FOR_0(ig0, ig1, ig2)
+#define __TLBI_INSTR_0(op, ig1, ig2)	"tlbi " #op
+#define __TLBI_IO_0(ig0, ig1, ig2)	: :
+
+#define __TLBI_FOR_1(ig0, ig1, ig2)
+#define __TLBI_INSTR_1(op, ig0, ig1)	"tlbi " #op ", %0"
+#define __TLBI_IO_1(ig0, arg, ig1)	: : "r" (arg)
+
+#define __TLBI_FOR_2(ig0, start, ig1)	unsigned long addr;		       \
+					for (addr = start; addr < end;	       \
+						addr += 1 << (PAGE_SHIFT - 12))
+#define __TLBI_INSTR_2(op, ig0, ig1)	"tlbi " #op ", %0"
+#define __TLBI_IO_2(ig0, ig1, ig2)	: : "r" (addr)
+
+#define __TLBI_FOR_N(op, a1, a2, n, ...)	__TLBI_FOR_##n(op, a1, a2)
+#define __TLBI_INSTR_N(op, a1, a2, n, ...)	__TLBI_INSTR_##n(op, a1, a2)
+#define __TLBI_IO_N(op, a1, a2, n, ...)	__TLBI_IO_##n(op, a1, a2)
+
+#define __TLBI_FOR(op, ...)		__TLBI_FOR_N(op, ##__VA_ARGS__, 2, 1, 0)
+#define __TLBI_INSTR(op, ...)		__TLBI_INSTR_N(op, ##__VA_ARGS__, 2, 1, 0)
+#define __TLBI_IO(op, ...)		__TLBI_IO_N(op, ##__VA_ARGS__, 2, 1, 0)
+
+#define __tlbi_asm_dsb(as, op, attr, ...) do {				       \
+		__TLBI_FOR(op, ##__VA_ARGS__)				       \
+			asm (__TLBI_INSTR(op, ##__VA_ARGS__)		       \
+			__TLBI_IO(op, ##__VA_ARGS__));			       \
+		asm volatile (	     as			"\ndsb " #attr "\n"    \
+		: : : "memory"); } while (0)
+
+#define __tlbi_dsb(...)	__tlbi_asm_dsb("", ##__VA_ARGS__)
 
 /*
  *	TLB Management
@@ -84,16 +131,14 @@
 static inline void local_flush_tlb_all(void)
 {
 	dsb(nshst);
-	__tlbi(vmalle1);
-	dsb(nsh);
+	__tlbi_dsb(vmalle1, nsh);
 	isb();
 }
 
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	__tlbi(vmalle1is);
-	dsb(ish);
+	__tlbi_dsb(vmalle1is, ish);
 	isb();
 }
 
@@ -102,8 +147,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	unsigned long asid = ASID(mm) << 48;
 
 	dsb(ishst);
-	__tlbi(aside1is, asid);
-	dsb(ish);
+	__tlbi_dsb(aside1is, ish, asid);
 }
 
 static inline void flush_tlb_page(struct vm_area_struct *vma,
@@ -112,8 +156,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 	unsigned long addr = uaddr >> 12 | (ASID(vma->vm_mm) << 48);
 
 	dsb(ishst);
-	__tlbi(vale1is, addr);
-	dsb(ish);
+	__tlbi_dsb(vale1is, ish, addr);
 }
 
 /*
@@ -127,7 +170,6 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     bool last_level)
 {
 	unsigned long asid = ASID(vma->vm_mm) << 48;
-	unsigned long addr;
 
 	if ((end - start) > MAX_TLB_RANGE) {
 		flush_tlb_mm(vma->vm_mm);
@@ -138,13 +180,10 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	end = asid | (end >> 12);
 
 	dsb(ishst);
-	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12)) {
-		if (last_level)
-			__tlbi(vale1is, addr);
-		else
-			__tlbi(vae1is, addr);
-	}
-	dsb(ish);
+	if (last_level)
+		__tlbi_dsb(vale1is, ish, start, end);
+	else
+		__tlbi_dsb(vae1is, ish, start, end);
 }
 
 static inline void flush_tlb_range(struct vm_area_struct *vma,
@@ -155,8 +194,6 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 
 static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	unsigned long addr;
-
 	if ((end - start) > MAX_TLB_RANGE) {
 		flush_tlb_all();
 		return;
@@ -166,9 +203,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	end >>= 12;
 
 	dsb(ishst);
-	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12))
-		__tlbi(vaae1is, addr);
-	dsb(ish);
+	__tlbi_dsb(vaae1is, ish, start, end);
 	isb();
 }
 
@@ -181,8 +216,7 @@ static inline void __flush_tlb_pgtable(struct mm_struct *mm,
 {
 	unsigned long addr = uaddr >> 12 | (ASID(mm) << 48);
 
-	__tlbi(vae1is, addr);
-	dsb(ish);
+	__tlbi_dsb(vae1is, ish, addr);
 }
 
 #endif
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
