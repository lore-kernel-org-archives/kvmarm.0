From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/14] arm64: Call ARCH_WORKAROUND_2 on transitions between
 EL0 and EL1
Date: Tue, 22 May 2018 16:06:36 +0100
Message-ID: <20180522150648.28297-3-marc.zyngier@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 876224A119
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 10:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dA-fAaKqiTyr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 10:56:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3214A0F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 10:56:42 -0400 (EDT)
In-Reply-To: <20180522150648.28297-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

In order for the kernel to protect itself, let's call the SSBD mitigation
implemented by the higher exception level (either hypervisor or firmware)
on each transition between userspace and kernel.

We must take the PSCI conduit into account in order to target the
right exception level, hence the introduction of a runtime patching
callback.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 18 ++++++++++++++++++
 arch/arm64/kernel/entry.S      | 22 ++++++++++++++++++++++
 include/linux/arm-smccc.h      |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a900befadfe8..46b3aafb631a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -232,6 +232,24 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
+#ifdef CONFIG_ARM64_SSBD
+void __init arm64_update_smccc_conduit(struct alt_instr *alt,
+				       __le32 *origptr, __le32 *updptr,
+				       int nr_inst)
+{
+	u32 insn;
+
+	BUG_ON(nr_inst != 1);
+
+	if (psci_ops.conduit == PSCI_CONDUIT_HVC)
+		insn = aarch64_insn_get_hvc_value();
+	else
+		insn = aarch64_insn_get_smc_value();
+
+	*updptr = cpu_to_le32(insn);
+}
+#endif	/* CONFIG_ARM64_SSBD */
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ec2ee720e33e..f33e6aed3037 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -18,6 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
 
@@ -137,6 +138,18 @@ alternative_else_nop_endif
 	add	\dst, \dst, #(\sym - .entry.tramp.text)
 	.endm
 
+	// This macro corrupts x0-x3. It is the caller's duty
+	// to save/restore them if required.
+	.macro	apply_ssbd, state
+#ifdef CONFIG_ARM64_SSBD
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
+	mov	w1, #\state
+alternative_cb	arm64_update_smccc_conduit
+	nop					// Patched to SMC/HVC #0
+alternative_cb_end
+#endif
+	.endm
+
 	.macro	kernel_entry, el, regsize = 64
 	.if	\regsize == 32
 	mov	w0, w0				// zero upper 32 bits of x0
@@ -163,6 +176,13 @@ alternative_else_nop_endif
 	ldr	x19, [tsk, #TSK_TI_FLAGS]	// since we can unmask debug
 	disable_step_tsk x19, x20		// exceptions when scheduling.
 
+	apply_ssbd 1
+
+#ifdef CONFIG_ARM64_SSBD
+	ldp	x0, x1, [sp, #16 * 0]
+	ldp	x2, x3, [sp, #16 * 1]
+#endif
+
 	mov	x29, xzr			// fp pointed to user-space
 	.else
 	add	x21, sp, #S_FRAME_SIZE
@@ -303,6 +323,8 @@ alternative_if ARM64_WORKAROUND_845719
 alternative_else_nop_endif
 #endif
 3:
+	apply_ssbd 0
+
 	.endif
 
 	msr	elr_el1, x21			// set up the return data
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index c89da86de99f..ca1d2cc2cdfa 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -80,6 +80,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x8000)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_2					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x7fff)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
-- 
2.14.2
