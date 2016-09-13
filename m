From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH 4/7] arm64: tlbflush.h: add __tlbi() macro
Date: Tue, 13 Sep 2016 11:16:06 +0100
Message-ID: <1473761769-30572-5-git-send-email-punit.agrawal@arm.com>
References: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0282949B35
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KgtqV1R03cVj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 06:08:17 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5195412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:17 -0400 (EDT)
In-Reply-To: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

As with dsb() and isb(), add a __tlbi() helper so that we can avoid
distracting asm boilerplate every time we want a TLBI. As some TLBI
operations take an argument while others do not, some pre-processor is
used to handle these two cases with different assembly blocks.

The existing tlbflush.h code is moved over to use the helper.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
[ rename helper to __tlbi, update comment and commit log ]
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b460ae2..deab523 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -25,6 +25,24 @@
 #include <asm/cputype.h>
 
 /*
+ * Raw TLBI operations.
+ *
+ * Where necessary, use the __tlbi() macro to avoid asm()
+ * boilerplate. Drivers and most kernel code should use the TLB
+ * management routines in preference to the macro below.
+ *
+ * The macro can be used as __tlbi(op) or __tlbi(op, arg), depending
+ * on whether a particular TLBI operation takes an argument or
+ * not. The macros handles invoking the asm with or without the
+ * register argument as appropriate.
+ */
+#define __TLBI_0(op, arg)		asm ("tlbi " #op)
+#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
+#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
+
+#define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
+
+/*
  *	TLB Management
  *	==============
  *
@@ -66,7 +84,7 @@
 static inline void local_flush_tlb_all(void)
 {
 	dsb(nshst);
-	asm("tlbi	vmalle1");
+	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 }
@@ -74,7 +92,7 @@ static inline void local_flush_tlb_all(void)
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	asm("tlbi	vmalle1is");
+	__tlbi(vmalle1is);
 	dsb(ish);
 	isb();
 }
@@ -84,7 +102,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	unsigned long asid = ASID(mm) << 48;
 
 	dsb(ishst);
-	asm("tlbi	aside1is, %0" : : "r" (asid));
+	__tlbi(aside1is, asid);
 	dsb(ish);
 }
 
@@ -94,7 +112,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 	unsigned long addr = uaddr >> 12 | (ASID(vma->vm_mm) << 48);
 
 	dsb(ishst);
-	asm("tlbi	vale1is, %0" : : "r" (addr));
+	__tlbi(vale1is, addr);
 	dsb(ish);
 }
 
@@ -122,9 +140,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
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
@@ -149,7 +167,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 
 	dsb(ishst);
 	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12))
-		asm("tlbi vaae1is, %0" : : "r"(addr));
+		__tlbi(vaae1is, addr);
 	dsb(ish);
 	isb();
 }
@@ -163,7 +181,7 @@ static inline void __flush_tlb_pgtable(struct mm_struct *mm,
 {
 	unsigned long addr = uaddr >> 12 | (ASID(mm) << 48);
 
-	asm("tlbi	vae1is, %0" : : "r" (addr));
+	__tlbi(vae1is, addr);
 	dsb(ish);
 }
 
-- 
2.8.1
