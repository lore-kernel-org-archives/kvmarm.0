From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 44/50] ARM: Move system register accessors to asm/cp15.h
Date: Tue, 27 Sep 2016 20:05:52 +0200
Message-ID: <20160927180558.14699-45-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5382349B90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KfMKrewya7+5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:11 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AA3649BF1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:08 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id w84so190375611wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:31 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Russell King <rmk+kernel@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Headers linux/irqchip/arm-gic.v3.h and arch/arm/include/asm/kvm_hyp.h
are included in virt/kvm/arm/hyp/vgic-v3-sr.c and both define macros
called __ACCESS_CP15 and __ACCESS_CP15_64 which obviously creates a
conflict. These macros were introduced independently for GIC and KVM
and, in fact, do the same thing.

As an option we could add prefixes to KVM and GIC version of macros so
they won't clash, but it'd introduce code duplication.  Alternatively,
we could keep macro in, say, GIC header and include it in KVM one (or
vice versa), but such dependency would not look nicer.

So we follow arm64 way (it handles this via sysreg.h) and move only
single set of macros to asm/cp15.h

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/arch_gicv3.h | 27 +++++++++++----------------
 arch/arm/include/asm/cp15.h       | 15 +++++++++++++++
 arch/arm/include/asm/kvm_hyp.h    | 15 +--------------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index e08d151..af25c32 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -22,9 +22,7 @@
 
 #include <linux/io.h>
 #include <asm/barrier.h>
-
-#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
-#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
+#include <asm/cp15.h>
 
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
 #define ICC_DIR				__ACCESS_CP15(c12, 0, c11, 1)
@@ -102,58 +100,55 @@
 
 static inline void gic_write_eoir(u32 irq)
 {
-	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
+	write_sysreg(irq, ICC_EOIR1);
 	isb();
 }
 
 static inline void gic_write_dir(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_DIR) : : "r" (val));
+	write_sysreg(val, ICC_DIR);
 	isb();
 }
 
 static inline u32 gic_read_iar(void)
 {
-	u32 irqstat;
+	u32 irqstat = read_sysreg(ICC_IAR1);
 
-	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
 	dsb(sy);
+
 	return irqstat;
 }
 
 static inline void gic_write_pmr(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
+	write_sysreg(val, ICC_PMR);
 }
 
 static inline void gic_write_ctlr(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_CTLR) : : "r" (val));
+	write_sysreg(val, ICC_CTLR);
 	isb();
 }
 
 static inline void gic_write_grpen1(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_IGRPEN1) : : "r" (val));
+	write_sysreg(val, ICC_IGRPEN1);
 	isb();
 }
 
 static inline void gic_write_sgi1r(u64 val)
 {
-	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
+	write_sysreg(val, ICC_SGI1R);
 }
 
 static inline u32 gic_read_sre(void)
 {
-	u32 val;
-
-	asm volatile("mrc " __stringify(ICC_SRE) : "=r" (val));
-	return val;
+	return read_sysreg(ICC_SRE);
 }
 
 static inline void gic_write_sre(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_SRE) : : "r" (val));
+	write_sysreg(val, ICC_SRE);
 	isb();
 }
 
diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
index c3f1152..dbdbce1 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -49,6 +49,21 @@
 
 #ifdef CONFIG_CPU_CP15
 
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
+	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
+#define __ACCESS_CP15_64(Op1, CRm)		\
+	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+
+#define __read_sysreg(r, w, c, t) ({				\
+	t __val;						\
+	asm volatile(r " " c : "=r" (__val));			\
+	__val;							\
+})
+#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
+
+#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
+#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 6eaff28..e604ad68 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -20,28 +20,15 @@
 
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
+#include <asm/cp15.h>
 #include <asm/kvm_mmu.h>
 #include <asm/vfp.h>
 
 #define __hyp_text __section(.hyp.text) notrace
 
-#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
-	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
-#define __ACCESS_CP15_64(Op1, CRm)		\
-	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
 #define __ACCESS_VFP(CRn)			\
 	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
 
-#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
-#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
-
-#define __read_sysreg(r, w, c, t) ({				\
-	t __val;						\
-	asm volatile(r " " c : "=r" (__val));			\
-	__val;							\
-})
-#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
-
 #define write_special(v, r)					\
 	asm volatile("msr " __stringify(r) ", %0" : : "r" (v))
 #define read_special(r) ({					\
-- 
2.9.0
