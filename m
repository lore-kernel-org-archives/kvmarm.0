From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 38/95] arm64: KVM: VHE: Introduce unified system register
 accessors
Date: Wed,  9 Mar 2016 07:30:32 +0000
Message-ID: <1457508689-19672-39-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0055948531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqIH7DreVKPW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A652349B34
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:32 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VHE brings its own bag of new system registers, or rather system
register accessors, as it define new ways to access both guest
and host system registers. For example, from the host:

- The host TCR_EL2 register is accessed using the TCR_EL1 accessor
- The guest TCR_EL1 register is accessed using the TCR_EL12 accessor

Obviously, this is confusing. A way to somehow reduce the complexity
of writing code for both ARMv8 and ARMv8.1 is to use a set of unified
accessors that will generate the right sysreg, depending on the mode
the CPU is running in. For example:

- read_sysreg_el1(tcr) will use TCR_EL1 on ARMv8, and TCR_EL12 on
  ARMv8.1 with VHE.
- read_sysreg_el2(tcr) will use TCR_EL2 on ARMv8, and TCR_EL1 on
  ARMv8.1 with VHE.

We end up with three sets of accessors ({read,write}_sysreg_el[012])
that can be directly used from C code. We take this opportunity to
also add the definition for the new VHE sysregs.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index fc502f3..744c919 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -48,6 +48,78 @@ static inline unsigned long __hyp_kern_va(unsigned long v)
 
 #define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
 
+#define read_sysreg_elx(r,nvh,vh)					\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
+					 "mrs_s %0, " __stringify(r##vh),\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
+
+#define write_sysreg_elx(v,r,nvh,vh)					\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE("msr " __stringify(r##nvh) ", %x0",\
+					 "msr_s " __stringify(r##vh) ", %x0",\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
+
+/*
+ * Unified accessors for registers that have a different encoding
+ * between VHE and non-VHE. They must be specified without their "ELx"
+ * encoding.
+ */
+#define read_sysreg_el2(r)						\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
+					 "mrs %0, " __stringify(r##_EL1),\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
+
+#define write_sysreg_el2(v,r)						\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE("msr " __stringify(r##_EL2) ", %x0",\
+					 "msr " __stringify(r##_EL1) ", %x0",\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
+
+#define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
+#define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
+#define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
+#define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
+
+/* The VHE specific system registers and their encoding */
+#define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
+#define cpacr_EL12              sys_reg(3, 5, 1, 0, 2)
+#define ttbr0_EL12              sys_reg(3, 5, 2, 0, 0)
+#define ttbr1_EL12              sys_reg(3, 5, 2, 0, 1)
+#define tcr_EL12                sys_reg(3, 5, 2, 0, 2)
+#define afsr0_EL12              sys_reg(3, 5, 5, 1, 0)
+#define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
+#define esr_EL12                sys_reg(3, 5, 5, 2, 0)
+#define far_EL12                sys_reg(3, 5, 6, 0, 0)
+#define mair_EL12               sys_reg(3, 5, 10, 2, 0)
+#define amair_EL12              sys_reg(3, 5, 10, 3, 0)
+#define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
+#define contextidr_EL12         sys_reg(3, 5, 13, 0, 1)
+#define cntkctl_EL12            sys_reg(3, 5, 14, 1, 0)
+#define cntp_tval_EL02          sys_reg(3, 5, 14, 2, 0)
+#define cntp_ctl_EL02           sys_reg(3, 5, 14, 2, 1)
+#define cntp_cval_EL02          sys_reg(3, 5, 14, 2, 2)
+#define cntv_tval_EL02          sys_reg(3, 5, 14, 3, 0)
+#define cntv_ctl_EL02           sys_reg(3, 5, 14, 3, 1)
+#define cntv_cval_EL02          sys_reg(3, 5, 14, 3, 2)
+#define spsr_EL12               sys_reg(3, 5, 4, 0, 0)
+#define elr_EL12                sys_reg(3, 5, 4, 0, 1)
+
 /**
  * hyp_alternate_select - Generates patchable code sequences that are
  * used to switch between two implementations of a function, depending
-- 
2.1.4
