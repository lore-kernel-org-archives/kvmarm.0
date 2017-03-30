From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 5/8] arm64: KVM: add guest SEI support
Date: Thu, 30 Mar 2017 18:31:14 +0800
Message-ID: <1490869877-118713-15-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, gengdongjiu@huawei.com, zhengqiang10@huawei.com, wuquanming@huawei.com, xiexiuqi@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Add ghes handling for SEI so that the host kernel could parse and
report detailed error information for SEI which occur in the guest
kernel.

If there were no CPER records, (or the system doesn't support SEI as a GHES
notification mechanism), then yes we should still call kvm_inject_vabt().

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kernel/traps.c            | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c         | 22 ++++++++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 5b2cecd..d68d61f 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -59,5 +59,6 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 #endif	/* __ASSEMBLY__ */
 
 int handle_guest_sea(unsigned long addr, unsigned int esr);
+int handle_guest_sei(unsigned long addr, unsigned int esr);
 
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 955dc8c..b6d6727 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -618,6 +618,20 @@ const char *esr_get_class_string(u32 esr)
 DEFINE_PER_CPU(int, sei_in_process);
 
 /*
+ * Handle asynchronous SError interrupt that occur in a guest kernel.
+ */
+int handle_guest_sei(unsigned long addr, unsigned int esr)
+{
+        int ret = -ENOENT;
+
+        if(IS_ENABLED(CONFIG_ACPI_APEI_SEI)) {
+                ret = ghes_notify_sei();
+        }
+
+        return ret;
+}
+
+/*
  * bad_mode handles the impossible case in the exception vector. This is always
  * fatal.
  */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index fa1b18e..c89d83a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/system_misc.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -177,6 +178,23 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	unsigned long fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+
+	if (handle_guest_sei((unsigned long)fault_ipa,
+				kvm_vcpu_get_hsr(vcpu))) {
+		kvm_err("Failed to handle guest SEI, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
+				kvm_vcpu_trap_get_class(vcpu),
+				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
+				(unsigned long)kvm_vcpu_get_hsr(vcpu));
+
+		kvm_inject_vabt(vcpu);
+	}
+
+	return 0;
+}
+
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -200,7 +218,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*vcpu_pc(vcpu) -= adj;
 		}
 
-		kvm_inject_vabt(vcpu);
+		kvm_handle_guest_sei(vcpu, run);
 		return 1;
 	}
 
@@ -210,7 +228,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
+		kvm_handle_guest_sei(vcpu, run);
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		/*
-- 
1.8.3.1

