From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v2 09/11] KVM: arm: disable debug mode if we don't actually need it.
Date: Sun, 31 May 2015 12:27:10 +0800
Message-ID: <1433046432-1824-10-git-send-email-zhichao.huang@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Until now we enable debug mode all the time even if we don't
actually need it.

Inspired by the implementation in arm64, disable debug mode if
we don't need it. And then we are able to reduce unnecessary
registers saving/restoring when the debug mode is disabled.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kernel/hw_breakpoint.c | 55 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index dc7d0a9..1d27563 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -266,8 +266,7 @@ static int enable_monitor_mode(void)
 	}
 
 	/* Check that the write made it through. */
-	ARM_DBG_READ(c0, c1, 0, dscr);
-	if (!(dscr & ARM_DSCR_MDBGEN)) {
+	if (!monitor_mode_enabled()) {
 		pr_warn_once("Failed to enable monitor mode on CPU %d.\n",
 				smp_processor_id());
 		return -EPERM;
@@ -277,6 +276,43 @@ out:
 	return 0;
 }
 
+static int disable_monitor_mode(void)
+{
+	u32 dscr;
+
+	ARM_DBG_READ(c0, c1, 0, dscr);
+
+	/* If monitor mode is already disabled, just return. */
+	if (!(dscr & ARM_DSCR_MDBGEN))
+		goto out;
+
+	/* Write to the corresponding DSCR. */
+	switch (get_debug_arch()) {
+	case ARM_DEBUG_ARCH_V6:
+	case ARM_DEBUG_ARCH_V6_1:
+		ARM_DBG_WRITE(c0, c1, 0, (dscr & ~ARM_DSCR_MDBGEN));
+		break;
+	case ARM_DEBUG_ARCH_V7_ECP14:
+	case ARM_DEBUG_ARCH_V7_1:
+	case ARM_DEBUG_ARCH_V8:
+		ARM_DBG_WRITE(c0, c2, 2, (dscr & ~ARM_DSCR_MDBGEN));
+		isb();
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	/* Check that the write made it through. */
+	if (monitor_mode_enabled()) {
+		pr_warn_once("Failed to disable monitor mode on CPU %d.\n",
+				smp_processor_id());
+		return -EPERM;
+	}
+
+out:
+	return 0;
+}
+
 int hw_breakpoint_slots(int type)
 {
 	if (!debug_arch_supported())
@@ -338,6 +374,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	int i, max_slots, ctrl_base, val_base;
 	u32 addr, ctrl;
 
+	enable_monitor_mode();
+
 	addr = info->address;
 	ctrl = encode_ctrl_reg(info->ctrl) | 0x1;
 
@@ -430,6 +468,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 
 	/* Reset the control register. */
 	write_wb_reg(base + i, 0);
+
+	disable_monitor_mode();
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -598,9 +638,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	int ret = 0;
 	u32 offset, alignment_mask = 0x3;
 
-	/* Ensure that we are in monitor debug mode. */
-	if (!monitor_mode_enabled())
-		return -ENODEV;
 
 	/* Build the arch_hw_breakpoint. */
 	ret = arch_build_bp_info(bp);
@@ -1013,12 +1050,12 @@ clear_vcr:
 	}
 
 	/*
-	 * Have a crack at enabling monitor mode. We don't actually need
-	 * it yet, but reporting an error early is useful if it fails.
+	 * We don't enable monitor mode here as we don't actually need it yet.
+	 * We would enable monitor mode when we actually install hwbreakpoint.
 	 */
 out_mdbgen:
-	if (enable_monitor_mode())
-		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
+
+	return;
 }
 
 static int dbg_reset_notify(struct notifier_block *self,
-- 
1.7.12.4

