From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 03/10] KVM: arm: enable to use the ARM_DSCR_MDBGEN macro from KVM assembly code
Date: Sat, 16 May 2015 12:45:44 +0800
Message-ID: <1431751551-4788-4-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add #ifndef __ASSEMBLY__ in hw_breakpoint.h, in order to use
the ARM_DSCR_MDBGEN macro from KVM assembly code.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
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

