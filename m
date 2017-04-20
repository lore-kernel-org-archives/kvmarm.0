From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] arm64: Add ASM modifier for xN register operands
Date: Thu, 20 Apr 2017 11:30:53 -0700
Message-ID: <20170420183053.718-1-mka@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Matthias Kaehlcke <mka@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

Many inline assembly statements don't include the 'x' modifier when
using xN registers as operands. This is perfectly valid, however it
causes clang to raise warnings like this:

warning: value size does not match register size specified by the
  constraint and modifier [-Wasm-operand-widths]
...
arch/arm64/include/asm/barrier.h:62:23: note: expanded from macro
  '__smp_store_release'
    asm volatile ("stlr %1, %0"

Add the modifier to keep clang happy.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 arch/arm64/include/asm/arch_gicv3.h  |  2 +-
 arch/arm64/include/asm/barrier.h     |  4 ++--
 arch/arm64/include/asm/io.h          | 24 ++++++++++++------------
 arch/arm64/include/asm/kvm_hyp.h     | 10 +++++-----
 arch/arm64/include/asm/kvm_mmu.h     | 12 ++++++------
 arch/arm64/include/asm/percpu.h      |  4 ++--
 arch/arm64/include/asm/sysreg.h      |  4 ++--
 arch/arm64/include/asm/uaccess.h     |  4 ++--
 arch/arm64/kernel/armv8_deprecated.c |  4 ++--
 arch/arm64/kernel/probes/kprobes.c   |  2 +-
 arch/arm64/kvm/hyp/switch.c          |  4 ++--
 11 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index f37e3a21f6e7..ba54e5bee885 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -166,7 +166,7 @@ static inline void gic_write_sre(u32 val)
 
 static inline void gic_write_bpr1(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %0" : : "r" (val));
+	asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %x0" : : "r" (val));
 }
 
 #define gic_read_typer(c)		readq_relaxed(c)
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 4e0497f581a0..bc167eeda9e4 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -59,7 +59,7 @@ do {									\
 				: "=Q" (*p) : "r" (v) : "memory");	\
 		break;							\
 	case 8:								\
-		asm volatile ("stlr %1, %0"				\
+		asm volatile ("stlr %x1, %0"				\
 				: "=Q" (*p) : "r" (v) : "memory");	\
 		break;							\
 	}								\
@@ -86,7 +86,7 @@ do {									\
 			: "Q" (*p) : "memory");				\
 		break;							\
 	case 8:								\
-		asm volatile ("ldar %0, %1"				\
+		asm volatile ("ldar %x0, %1"				\
 			: "=r" (*(__u64 *)__u.__c)			\
 			: "Q" (*p) : "memory");				\
 		break;							\
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 0c00c87bb9dd..021e1733da0c 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -39,33 +39,33 @@
 #define __raw_writeb __raw_writeb
 static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
 {
-	asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
+	asm volatile("strb %w0, [%x1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_writew __raw_writew
 static inline void __raw_writew(u16 val, volatile void __iomem *addr)
 {
-	asm volatile("strh %w0, [%1]" : : "rZ" (val), "r" (addr));
+	asm volatile("strh %w0, [%x1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_writel __raw_writel
 static inline void __raw_writel(u32 val, volatile void __iomem *addr)
 {
-	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
+	asm volatile("str %w0, [%x1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_writeq __raw_writeq
 static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
 {
-	asm volatile("str %x0, [%1]" : : "rZ" (val), "r" (addr));
+	asm volatile("str %x0, [%x1]" : : "rZ" (val), "r" (addr));
 }
 
 #define __raw_readb __raw_readb
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	u8 val;
-	asm volatile(ALTERNATIVE("ldrb %w0, [%1]",
-				 "ldarb %w0, [%1]",
+	asm volatile(ALTERNATIVE("ldrb %w0, [%x1]",
+				 "ldarb %w0, [%x1]",
 				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
 		     : "=r" (val) : "r" (addr));
 	return val;
@@ -76,8 +76,8 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	u16 val;
 
-	asm volatile(ALTERNATIVE("ldrh %w0, [%1]",
-				 "ldarh %w0, [%1]",
+	asm volatile(ALTERNATIVE("ldrh %w0, [%x1]",
+				 "ldarh %w0, [%x1]",
 				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
 		     : "=r" (val) : "r" (addr));
 	return val;
@@ -87,8 +87,8 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	u32 val;
-	asm volatile(ALTERNATIVE("ldr %w0, [%1]",
-				 "ldar %w0, [%1]",
+	asm volatile(ALTERNATIVE("ldr %w0, [%x1]",
+				 "ldar %w0, [%x1]",
 				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
 		     : "=r" (val) : "r" (addr));
 	return val;
@@ -98,8 +98,8 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	u64 val;
-	asm volatile(ALTERNATIVE("ldr %0, [%1]",
-				 "ldar %0, [%1]",
+	asm volatile(ALTERNATIVE("ldr %x0, [%x1]",
+				 "ldar %x0, [%x1]",
 				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
 		     : "=r" (val) : "r" (addr));
 	return val;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b18e852d27e8..ee872d9aded5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -28,8 +28,8 @@
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
-					 "mrs_s %0, " __stringify(r##vh),\
+		asm volatile(ALTERNATIVE("mrs %x0, " __stringify(r##nvh),\
+					 "mrs_s %x0, " __stringify(r##vh),\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 			     : "=r" (reg));				\
 		reg;							\
@@ -52,8 +52,8 @@
 #define read_sysreg_el2(r)						\
 	({								\
 		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
-					 "mrs %0, " __stringify(r##_EL1),\
+		asm volatile(ALTERNATIVE("mrs %x0, " __stringify(r##_EL2),\
+					 "mrs %x0, " __stringify(r##_EL1),\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 			     : "=r" (reg));				\
 		reg;							\
@@ -115,7 +115,7 @@ typeof(orig) * __hyp_text fname(void)					\
 {									\
 	typeof(alt) *val = orig;					\
 	asm volatile(ALTERNATIVE("nop		\n",			\
-				 "mov	%0, %1	\n",			\
+				 "mov	%x0, %x1\n",			\
 				 cond)					\
 		     : "+r" (val) : "r" (alt));				\
 	return val;							\
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ed1246014901..7692a13efe8e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -115,13 +115,13 @@ alternative_else_nop_endif
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
-	asm volatile(ALTERNATIVE("and %0, %0, %1",
+	asm volatile(ALTERNATIVE("and %x0, %x0, %1",
 				 "nop",
 				 ARM64_HAS_VIRT_HOST_EXTN)
 		     : "+r" (v)
 		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
 	asm volatile(ALTERNATIVE("nop",
-				 "and %0, %0, %1",
+				 "and %x0, %x0, %1",
 				 ARM64_HYP_OFFSET_LOW)
 		     : "+r" (v)
 		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
@@ -181,10 +181,10 @@ static inline void kvm_set_s2pte_readonly(pte_t *pte)
 
 	asm volatile("//	kvm_set_s2pte_readonly\n"
 	"	prfm	pstl1strm, %2\n"
-	"1:	ldxr	%0, %2\n"
-	"	and	%0, %0, %3		// clear PTE_S2_RDWR\n"
-	"	orr	%0, %0, %4		// set PTE_S2_RDONLY\n"
-	"	stxr	%w1, %0, %2\n"
+	"1:	ldxr	%x0, %2\n"
+	"	and	%x0, %x0, %3		// clear PTE_S2_RDWR\n"
+	"	orr	%x0, %x0, %4		// set PTE_S2_RDONLY\n"
+	"	stxr	%w1, %x0, %2\n"
 	"	cbnz	%w1, 1b\n"
 	: "=&r" (pteval), "=&r" (tmp), "+Q" (pte_val(*pte))
 	: "L" (~PTE_S2_RDWR), "L" (PTE_S2_RDONLY));
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 3bd498e4de4c..52be13171fec 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -20,7 +20,7 @@
 
 static inline void set_my_cpu_offset(unsigned long off)
 {
-	asm volatile("msr tpidr_el1, %0" :: "r" (off) : "memory");
+	asm volatile("msr tpidr_el1, %x0" :: "r" (off) : "memory");
 }
 
 static inline unsigned long __my_cpu_offset(void)
@@ -31,7 +31,7 @@ static inline unsigned long __my_cpu_offset(void)
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
-	asm("mrs %0, tpidr_el1" : "=r" (off) :
+	asm("mrs %x0, tpidr_el1" : "=r" (off) :
 		"Q" (*(const unsigned long *)current_stack_pointer));
 
 	return off;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ac24b6e798b1..dd7768e114e3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -309,7 +309,7 @@ asm(
  */
 #define read_sysreg(r) ({					\
 	u64 __val;						\
-	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
+	asm volatile("mrs %x0, " __stringify(r) : "=r" (__val));	\
 	__val;							\
 })
 
@@ -329,7 +329,7 @@ asm(
  */
 #define read_sysreg_s(r) ({						\
 	u64 __val;							\
-	asm volatile("mrs_s %0, " __stringify(r) : "=r" (__val));	\
+	asm volatile("mrs_s %x0, " __stringify(r) : "=r" (__val));	\
 	__val;								\
 })
 
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 5308d696311b..e806471e0934 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -256,7 +256,7 @@ do {									\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	case 8:								\
-		__get_user_asm("ldr", "ldtr", "%",  __gu_val, (ptr),	\
+		__get_user_asm("ldr", "ldtr", "%x",  __gu_val, (ptr),	\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	default:							\
@@ -323,7 +323,7 @@ do {									\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	case 8:								\
-		__put_user_asm("str", "sttr", "%", __pu_val, (ptr),	\
+		__put_user_asm("str", "sttr", "%x", __pu_val, (ptr),	\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	default:							\
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 657977e77ec8..a82d5259aab1 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -288,8 +288,8 @@ do {								\
 	uaccess_enable();					\
 	__asm__ __volatile__(					\
 	"	mov		%w3, %w7\n"			\
-	"0:	ldxr"B"		%w2, [%4]\n"			\
-	"1:	stxr"B"		%w0, %w1, [%4]\n"		\
+	"0:	ldxr"B"		%w2, [%x4]\n"			\
+	"1:	stxr"B"		%w0, %w1, [%x4]\n"		\
 	"	cbz		%w0, 2f\n"			\
 	"	sub		%w3, %w3, #1\n"			\
 	"	cbnz		%w3, 0b\n"			\
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index c5c45942fb6e..237b0e2e3364 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -495,7 +495,7 @@ void __kprobes jprobe_return(void)
 	 * -a special PC to identify it from the other kprobes.
 	 * -restore stack addr to original saved pt_regs
 	 */
-	asm volatile("				mov sp, %0	\n"
+	asm volatile("				mov sp, %x0	\n"
 		     "jprobe_return_break:	brk %1		\n"
 		     :
 		     : "r" (kcb->jprobe_saved_regs.sp),
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index aede1658aeda..cf22fbe3cf06 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -212,7 +212,7 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg(par_el1);
-	asm volatile("at s1e1r, %0" : : "r" (far));
+	asm volatile("at s1e1r, %x0" : : "r" (far));
 	isb();
 
 	tmp = read_sysreg(par_el1);
@@ -388,7 +388,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %x0, =__hyp_panic_string" : "=r" (str_va));
 
 	__hyp_do_panic(str_va,
 		       spsr,  elr,
-- 
2.12.2.816.g2cccc81164-goog
