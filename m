From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v3 03/11] KVM: arm: enable to use the ARM_DSCR_MDBGEN macro
 from KVM assembly code
Date: Mon, 22 Jun 2015 18:41:26 +0800
Message-ID: <1434969694-7432-4-git-send-email-zhichao.huang@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74E4656291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FruyEPe7A9ij for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 06:31:08 -0400 (EDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
 [209.85.192.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D07C562C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:31:08 -0400 (EDT)
Received: by pdjn11 with SMTP id n11so136455866pdj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 03:41:59 -0700 (PDT)
In-Reply-To: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add #ifndef __ASSEMBLY__ in hw_breakpoint.h, in order to use
the ARM_DSCR_MDBGEN macro from KVM assembly code.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
Reviewed-by: Alex Bennee <alex.bennee@linaro.org>
---
 arch/arm/include/asm/hw_breakpoint.h | 54 +++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
index 8e427c7..f2f4c61 100644
--- a/arch/arm/include/asm/hw_breakpoint.h
+++ b/arch/arm/include/asm/hw_breakpoint.h
@@ -3,6 +3,8 @@
 
 #ifdef __KERNEL__
 
+#ifndef __ASSEMBLY__
+
 struct task_struct;
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -44,6 +46,33 @@ static inline void decode_ctrl_reg(u32 reg,
 	ctrl->mismatch	= reg & 0x1;
 }
 
+struct notifier_block;
+struct perf_event;
+struct pmu;
+
+extern struct pmu perf_ops_bp;
+extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
+				  int *gen_len, int *gen_type);
+extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
+extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
+extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+					   unsigned long val, void *data);
+
+extern u8 arch_get_debug_arch(void);
+extern u8 arch_get_max_wp_len(void);
+extern void clear_ptrace_hw_breakpoint(struct task_struct *tsk);
+
+int arch_install_hw_breakpoint(struct perf_event *bp);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp);
+void hw_breakpoint_pmu_read(struct perf_event *bp);
+int hw_breakpoint_slots(int type);
+
+#else
+static inline void clear_ptrace_hw_breakpoint(struct task_struct *tsk) {}
+
+#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
+#endif  /* __ASSEMBLY */
+
 /* Debug architecture numbers. */
 #define ARM_DEBUG_ARCH_RESERVED	0	/* In case of ptrace ABI updates. */
 #define ARM_DEBUG_ARCH_V6	1
@@ -110,30 +139,5 @@ static inline void decode_ctrl_reg(u32 reg,
 	asm volatile("mcr p14, 0, %0, " #N "," #M ", " #OP2 : : "r" (VAL));\
 } while (0)
 
-struct notifier_block;
-struct perf_event;
-struct pmu;
-
-extern struct pmu perf_ops_bp;
-extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
-				  int *gen_len, int *gen_type);
-extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
-extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
-extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
-					   unsigned long val, void *data);
-
-extern u8 arch_get_debug_arch(void);
-extern u8 arch_get_max_wp_len(void);
-extern void clear_ptrace_hw_breakpoint(struct task_struct *tsk);
-
-int arch_install_hw_breakpoint(struct perf_event *bp);
-void arch_uninstall_hw_breakpoint(struct perf_event *bp);
-void hw_breakpoint_pmu_read(struct perf_event *bp);
-int hw_breakpoint_slots(int type);
-
-#else
-static inline void clear_ptrace_hw_breakpoint(struct task_struct *tsk) {}
-
-#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
 #endif	/* __KERNEL__ */
 #endif	/* _ARM_HW_BREAKPOINT_H */
-- 
1.7.12.4
