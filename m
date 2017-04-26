From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] arm64: Add ASM modifier for xN register operands
Date: Wed, 26 Apr 2017 14:46:16 -0700
Message-ID: <20170426214616.142580-1-mka@chromium.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
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

Add the modifiers to keep clang happy.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- also add modifiers to multiline ASM statements in include/asm/
  {atomic_ll_sc.h,irqflags.h,pgtable.h,uaccess.h,word-at-a-time.h}
  that were missed on v1

 arch/arm64/include/asm/arch_gicv3.h     |  2 +-
 arch/arm64/include/asm/atomic_ll_sc.h   | 36 ++++++++++++++++-----------------
 arch/arm64/include/asm/barrier.h        |  4 ++--
 arch/arm64/include/asm/io.h             | 24 +++++++++++-----------
 arch/arm64/include/asm/irqflags.h       | 10 ++++-----
 arch/arm64/include/asm/kvm_hyp.h        | 10 ++++-----
 arch/arm64/include/asm/kvm_mmu.h        | 12 +++++------
 arch/arm64/include/asm/percpu.h         |  4 ++--
 arch/arm64/include/asm/pgtable.h        | 20 +++++++++---------
 arch/arm64/include/asm/sysreg.h         |  4 ++--
 arch/arm64/include/asm/uaccess.h        | 14 ++++++-------
 arch/arm64/include/asm/word-at-a-time.h | 14 ++++++-------
 arch/arm64/kernel/armv8_deprecated.c    |  4 ++--
 arch/arm64/kernel/probes/kprobes.c      |  2 +-
 arch/arm64/kvm/hyp/switch.c             |  4 ++--
 15 files changed, 82 insertions(+), 82 deletions(-)

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
diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index f819fdcff1ac..81f0088e3f11 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -140,9 +140,9 @@ __LL_SC_PREFIX(atomic64_##op(long i, atomic64_t *v))			\
 									\
 	asm volatile("// atomic64_" #op "\n"				\
 "	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%0, %2\n"						\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	stxr	%w1, %0, %2\n"						\
+"1:	ldxr	%x0, %2\n"						\
+"	" #asm_op "	%x0, %x0, %3\n"					\
+"	stxr	%w1, %x0, %2\n"						\
 "	cbnz	%w1, 1b"						\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: "Ir" (i));							\
@@ -158,9 +158,9 @@ __LL_SC_PREFIX(atomic64_##op##_return##name(long i, atomic64_t *v))	\
 									\
 	asm volatile("// atomic64_" #op "_return" #name "\n"		\
 "	prfm	pstl1strm, %2\n"					\
-"1:	ld" #acq "xr	%0, %2\n"					\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	st" #rel "xr	%w1, %0, %2\n"					\
+"1:	ld" #acq "xr	%x0, %2\n"					\
+"	" #asm_op "	%x0, %x0, %3\n"					\
+"	st" #rel "xr	%w1, %x0, %2\n"					\
 "	cbnz	%w1, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
@@ -180,9 +180,9 @@ __LL_SC_PREFIX(atomic64_fetch_##op##name(long i, atomic64_t *v))	\
 									\
 	asm volatile("// atomic64_fetch_" #op #name "\n"		\
 "	prfm	pstl1strm, %3\n"					\
-"1:	ld" #acq "xr	%0, %3\n"					\
-"	" #asm_op "	%1, %0, %4\n"					\
-"	st" #rel "xr	%w2, %1, %3\n"					\
+"1:	ld" #acq "xr	%x0, %3\n"					\
+"	" #asm_op "	%x1, %x0, %4\n"					\
+"	st" #rel "xr	%w2, %x1, %3\n"					\
 "	cbnz	%w2, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
@@ -233,10 +233,10 @@ __LL_SC_PREFIX(atomic64_dec_if_positive(atomic64_t *v))
 
 	asm volatile("// atomic64_dec_if_positive\n"
 "	prfm	pstl1strm, %2\n"
-"1:	ldxr	%0, %2\n"
-"	subs	%0, %0, #1\n"
+"1:	ldxr	%x0, %2\n"
+"	subs	%x0, %x0, #1\n"
 "	b.lt	2f\n"
-"	stlxr	%w1, %0, %2\n"
+"	stlxr	%w1, %x0, %2\n"
 "	cbnz	%w1, 1b\n"
 "	dmb	ish\n"
 "2:"
@@ -306,12 +306,12 @@ __LL_SC_PREFIX(__cmpxchg_double##name(unsigned long old1,		\
 									\
 	asm volatile("// __cmpxchg_double" #name "\n"			\
 	"	prfm	pstl1strm, %2\n"				\
-	"1:	ldxp	%0, %1, %2\n"					\
-	"	eor	%0, %0, %3\n"					\
-	"	eor	%1, %1, %4\n"					\
-	"	orr	%1, %0, %1\n"					\
-	"	cbnz	%1, 2f\n"					\
-	"	st" #rel "xp	%w0, %5, %6, %2\n"			\
+	"1:	ldxp	%x0, %x1, %2\n"					\
+	"	eor	%x0, %x0, %x3\n"				\
+	"	eor	%x1, %x1, %x4\n"				\
+	"	orr	%x1, %x0, %x1\n"				\
+	"	cbnz	%x1, 2f\n"					\
+	"	st" #rel "xp	%w0, %x5, %x6, %2\n"			\
 	"	cbnz	%w0, 1b\n"					\
 	"	" #mb "\n"						\
 	"2:"								\
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
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 8c581281fa12..b30d9373c4dc 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -27,7 +27,7 @@ static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	asm volatile(
-		"mrs	%0, daif		// arch_local_irq_save\n"
+		"mrs	%x0, daif		// arch_local_irq_save\n"
 		"msr	daifset, #2"
 		: "=r" (flags)
 		:
@@ -66,7 +66,7 @@ static inline unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 	asm volatile(
-		"mrs	%0, daif		// arch_local_save_flags"
+		"mrs	%x0, daif		// arch_local_save_flags"
 		: "=r" (flags)
 		:
 		: "memory");
@@ -79,7 +79,7 @@ static inline unsigned long arch_local_save_flags(void)
 static inline void arch_local_irq_restore(unsigned long flags)
 {
 	asm volatile(
-		"msr	daif, %0		// arch_local_irq_restore"
+		"msr	daif, %x0		// arch_local_irq_restore"
 	:
 	: "r" (flags)
 	: "memory");
@@ -97,7 +97,7 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 	do {								\
 		typecheck(unsigned long, flags);			\
 		asm volatile(						\
-		"mrs    %0, daif		// local_dbg_save\n"	\
+		"mrs    %x0, daif		// local_dbg_save\n"	\
 		"msr    daifset, #8"					\
 		: "=r" (flags) : : "memory");				\
 	} while (0)
@@ -106,7 +106,7 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 	do {								\
 		typecheck(unsigned long, flags);			\
 		asm volatile(						\
-		"msr    daif, %0		// local_dbg_restore\n"	\
+		"msr    daif, %x0		// local_dbg_restore\n"	\
 		: : "r" (flags) : "memory");				\
 	} while (0)
 
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
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0eef6064bf3b..0035fdc25cbe 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -588,10 +588,10 @@ static inline int __ptep_test_and_clear_young(pte_t *ptep)
 
 	asm volatile("//	__ptep_test_and_clear_young\n"
 	"	prfm	pstl1strm, %2\n"
-	"1:	ldxr	%0, %2\n"
+	"1:	ldxr	%x0, %2\n"
 	"	ubfx	%w3, %w0, %5, #1	// extract PTE_AF (young)\n"
-	"	and	%0, %0, %4		// clear PTE_AF\n"
-	"	stxr	%w1, %0, %2\n"
+	"	and	%x0, %x0, %4		// clear PTE_AF\n"
+	"	stxr	%w1, %x0, %2\n"
 	"	cbnz	%w1, 1b\n"
 	: "=&r" (pteval), "=&r" (tmp), "+Q" (pte_val(*ptep)), "=&r" (res)
 	: "L" (~PTE_AF), "I" (ilog2(PTE_AF)));
@@ -625,7 +625,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 
 	asm volatile("//	ptep_get_and_clear\n"
 	"	prfm	pstl1strm, %2\n"
-	"1:	ldxr	%0, %2\n"
+	"1:	ldxr	%x0, %2\n"
 	"	stxr	%w1, xzr, %2\n"
 	"	cbnz	%w1, 1b\n"
 	: "=&r" (old_pteval), "=&r" (tmp), "+Q" (pte_val(*ptep)));
@@ -654,12 +654,12 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 
 	asm volatile("//	ptep_set_wrprotect\n"
 	"	prfm	pstl1strm, %2\n"
-	"1:	ldxr	%0, %2\n"
-	"	tst	%0, %4			// check for hw dirty (!PTE_RDONLY)\n"
-	"	csel	%1, %3, xzr, eq		// set PTE_DIRTY|PTE_RDONLY if dirty\n"
-	"	orr	%0, %0, %1		// if !dirty, PTE_RDONLY is already set\n"
-	"	and	%0, %0, %5		// clear PTE_WRITE/PTE_DBM\n"
-	"	stxr	%w1, %0, %2\n"
+	"1:	ldxr	%x0, %2\n"
+	"	tst	%x0, %4			// check for hw dirty (!PTE_RDONLY)\n"
+	"	csel	%x1, %x3, xzr, eq	// set PTE_DIRTY|PTE_RDONLY if dirty\n"
+	"	orr	%x0, %x0, %x1		// if !dirty, PTE_RDONLY is already set\n"
+	"	and	%x0, %x0, %5		// clear PTE_WRITE/PTE_DBM\n"
+	"	stxr	%w1, %x0, %2\n"
 	"	cbnz	%w1, 1b\n"
 	: "=&r" (pteval), "=&r" (tmp), "+Q" (pte_val(*ptep))
 	: "r" (PTE_DIRTY|PTE_RDONLY), "L" (PTE_RDONLY), "L" (~PTE_WRITE)
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
index 5308d696311b..4b683b81efa3 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -97,7 +97,7 @@ static inline void set_fs(mm_segment_t fs)
 ({									\
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, ls"		\
+	asm("adds %x1, %x1, %3; ccmp %1, %x4, #2, cc; cset %x0, ls"	\
 		: "=&r" (flag), "=&r" (roksum)				\
 		: "1" (addr), "Ir" (size),				\
 		  "r" (current_thread_info()->addr_limit)		\
@@ -224,8 +224,8 @@ static inline void uaccess_enable_not_uao(void)
  */
 #define __get_user_asm(instr, alt_instr, reg, x, addr, err, feature)	\
 	asm volatile(							\
-	"1:"ALTERNATIVE(instr "     " reg "1, [%2]\n",			\
-			alt_instr " " reg "1, [%2]\n", feature)		\
+	"1:"ALTERNATIVE(instr "     " reg "1, [%x2]\n",			\
+			alt_instr " " reg "1, [%x2]\n", feature)	\
 	"2:\n"								\
 	"	.section .fixup, \"ax\"\n"				\
 	"	.align	2\n"						\
@@ -256,7 +256,7 @@ do {									\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	case 8:								\
-		__get_user_asm("ldr", "ldtr", "%",  __gu_val, (ptr),	\
+		__get_user_asm("ldr", "ldtr", "%x",  __gu_val, (ptr),	\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	default:							\
@@ -292,8 +292,8 @@ do {									\
 
 #define __put_user_asm(instr, alt_instr, reg, x, addr, err, feature)	\
 	asm volatile(							\
-	"1:"ALTERNATIVE(instr "     " reg "1, [%2]\n",			\
-			alt_instr " " reg "1, [%2]\n", feature)		\
+	"1:"ALTERNATIVE(instr "     " reg "1, [%x2]\n",			\
+			alt_instr " " reg "1, [%x2]\n", feature)	\
 	"2:\n"								\
 	"	.section .fixup,\"ax\"\n"				\
 	"	.align	2\n"						\
@@ -323,7 +323,7 @@ do {									\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	case 8:								\
-		__put_user_asm("str", "sttr", "%", __pu_val, (ptr),	\
+		__put_user_asm("str", "sttr", "%x", __pu_val, (ptr),	\
 			       (err), ARM64_HAS_UAO);			\
 		break;							\
 	default:							\
diff --git a/arch/arm64/include/asm/word-at-a-time.h b/arch/arm64/include/asm/word-at-a-time.h
index b0d708ff7f4e..ab884d35780c 100644
--- a/arch/arm64/include/asm/word-at-a-time.h
+++ b/arch/arm64/include/asm/word-at-a-time.h
@@ -68,18 +68,18 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 
 	/* Load word from unaligned pointer addr */
 	asm(
-	"1:	ldr	%0, %3\n"
+	"1:	ldr	%x0, %3\n"
 	"2:\n"
 	"	.pushsection .fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x7\n"
-	"	bic	%2, %2, #0x7\n"
-	"	ldr	%0, [%2]\n"
-	"	lsl	%1, %1, #0x3\n"
+	"3:	and	%x1, %x2, #0x7\n"
+	"	bic	%x2, %x2, #0x7\n"
+	"	ldr	%x0, [%x2]\n"
+	"	lsl	%x1, %x1, #0x3\n"
 #ifndef __AARCH64EB__
-	"	lsr	%0, %0, %1\n"
+	"	lsr	%x0, %x0, %x1\n"
 #else
-	"	lsl	%0, %0, %1\n"
+	"	lsl	%x0, %x0, %x1\n"
 #endif
 	"	b	2b\n"
 	"	.popsection\n"
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
2.13.0.rc0.306.g87b477812d-goog
