From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 13:54:44 +0800
Message-ID: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, james.morse@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

In VHE mode, host kernel runs in the EL2 and can enable
'User Access Override' when fs==KERNEL_DS so that it can
access kernel memory. However, PSTATE.UAO is set to 0 on
an exception taken from EL1 to EL2. Thus when VHE is used
and exception taken from a guest UAO will be disabled and
host will use the incorrect PSTATE.UAO. So check and reset
the PSTATE.UAO when switching to host.

Move the reset PSTATE.PAN on entry to EL2 together with
PSTATE.UAO reset.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>
Tested-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/kvm/hyp/entry.S  |  2 --
 arch/arm64/kvm/hyp/switch.c | 12 ++++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d..7662ef5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -96,8 +96,6 @@ ENTRY(__guest_exit)
 
 	add	x1, x1, #VCPU_CONTEXT
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
-
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index a733461..715b3941 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -22,6 +22,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/fpsimd.h>
+#include <asm/exec.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -399,6 +400,17 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_host_state(host_ctxt);
 
+	if (has_vhe()) {
+		/*
+		 * PSTATE was not saved over guest enter/exit, re-enable
+		 * any detecte features that might not have been set
+		 * correctly.
+		 */
+		uao_thread_switch(current);
+		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1),
+			ARM64_HAS_PAN, CONFIG_ARM64_PAN));
+	}
+
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
-- 
1.8.3.1
