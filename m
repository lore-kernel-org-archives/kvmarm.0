From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC 7/9] arm64: expose PAC bit positions via ptrace
Date: Mon,  3 Apr 2017 16:19:23 +0100
Message-ID: <1491232765-32501-8-git-send-email-mark.rutland@arm.com>
References: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C1540BBB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 11:18:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aj7da-FdXERO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 11:18:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 260BD40CA1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 11:18:26 -0400 (EDT)
In-Reply-To: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When pointer authentication is in use, data/instruction pointers have a
number of PAC bits inserted into them. The number and position of these
bits depends on the configured TCR_ELx.TxSZ and whether tagging is
enabled. ARMv8.3 allows tagging to differ for instruction and data
pointers.

For userspace debuggers to unwind the stack and/or to follow pointer
chains, they need to be able to remove the PAC bits before attempting to
use a pointer.

This patch adds a new structure with masks describing the location of
PAC bits in instruction and data pointers, which userspace can query via
PTRACE_GETREGSET. By clearing these bits from pointers, userspace can
acquire the PAC-less versions.

This new regset is exposed when the kernel is built with (user) pointer
authentication support, and the feature is enabled.  Otherwise, it is
hidden.

Note that even if the feature is available and enabled, we cannot
determine whether userspace is making use of the feature, so debuggers
need to cope with this case regardless.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jiong Wang <jiong.wang@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h |  8 +++++++
 arch/arm64/include/uapi/asm/ptrace.h  |  5 +++++
 arch/arm64/kernel/ptrace.c            | 39 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h              |  1 +
 4 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index 345df24..ed505fe 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -16,9 +16,11 @@
 #ifndef __ASM_POINTER_AUTH_H
 #define __ASM_POINTER_AUTH_H
 
+#include <linux/bitops.h>
 #include <linux/random.h>
 
 #include <asm/cpufeature.h>
+#include <asm/memory.h>
 #include <asm/sysreg.h>
 
 #ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
@@ -70,6 +72,12 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
 	*new = *old;
 }
 
+/*
+ * The pointer bits used by a pointer authentication code.
+ * If we were to use tagged pointers, bits 63:56 would also apply.
+ */
+#define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)
+
 #define mm_ctx_ptrauth_init(ctx) \
 	ptrauth_keys_init(&(ctx)->ptrauth_keys)
 
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index d1ff83d..5092fbf 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -90,6 +90,11 @@ struct user_hwdebug_state {
 	}		dbg_regs[16];
 };
 
+struct user_pac_mask {
+	__u64		data_mask;
+	__u64		insn_mask;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI__ASM_PTRACE_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index c142459..b0bcdfb 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -40,8 +40,10 @@
 #include <linux/elf.h>
 
 #include <asm/compat.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/pointer_auth.h>
 #include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
@@ -693,6 +695,30 @@ static int system_call_set(struct task_struct *target,
 	return ret;
 }
 
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+static int pac_mask_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	/*
+	 * While the PAC bits are currently the same for data and instruction
+	 * pointers, this could change if we use TCR_ELx.TBID*. So we expose
+	 * them separately from the outset.
+	 */
+	unsigned long mask = ptrauth_pac_mask();
+	struct user_pac_mask uregs = {
+		.data_mask = mask,
+		.insn_mask = mask,
+	};
+
+	if (!cpus_have_cap(ARM64_HAS_ADDRESS_AUTH))
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
+}
+#endif
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -702,6 +728,9 @@ enum aarch64_regset {
 	REGSET_HW_WATCH,
 #endif
 	REGSET_SYSTEM_CALL,
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	REGSET_PAC_MASK,
+#endif
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -759,6 +788,16 @@ enum aarch64_regset {
 		.get = system_call_get,
 		.set = system_call_set,
 	},
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	[REGSET_PAC_MASK] = {
+		.core_note_type = NT_ARM_PAC_MASK,
+		.n = sizeof(struct user_pac_mask) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = pac_mask_get,
+		/* this cannot be set dynamically */
+	},
+#endif
 };
 
 static const struct user_regset_view user_aarch64_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index b59ee07..cae3d1e 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -414,6 +414,7 @@
 #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
+#define NT_ARM_PAC_MASK		0x405	/* ARM pointer authentication code masks */
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 #define NT_METAG_TLS	0x502		/* Metag TLS pointer */
-- 
1.9.1
