From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v7 4/4] arm64: kvm: handle SEI notification for guest
Date: Tue, 17 Oct 2017 22:14:49 +0800
Message-ID: <1508249689-10350-5-git-send-email-gengdongjiu@huawei.com>
References: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8F249D2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id poquvXsjyuZ7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 09:49:14 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D02D49D28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:12 -0400 (EDT)
In-Reply-To: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, gengdongjiu@huawei.com, wuquanming@huawei.com, kristina.martsenko@arm.com, mingo@kernel.org, punit.agrawal@arm.com, stephen.boyd@linaro.org, kamensky@cisco.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

when KVM received SError, it firstly classified the error
according to [ESR_ELx.AET]. If the SEI is Uncategorized or
IMPLEMENTATION DEFINED directly inject virtual SError with
IMPLEMENTATION DEFINED syndrome.

If the SError error is not propagated, then let host to handle
it. Because usually the address recorded by APEI table is not
accurate, so can not identify the address to hwpoison memory and
can not notify guest to do the recovery, so at the same time, let
user space specify a valid ESR and inject virtual SError.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
---
 arch/arm64/include/asm/esr.h         | 15 +++++++++
 arch/arm64/include/asm/kvm_asm.h     |  1 +
 arch/arm64/include/asm/kvm_host.h    |  6 ++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++++++++++---
 arch/arm64/mm/fault.c                | 16 ++++++++++
 6 files changed, 97 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8cabd57..e5d23a8f 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -95,6 +95,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_SERROR	(0x11)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV		(UL(1) << 24)
@@ -107,6 +108,20 @@
 #define ESR_ELx_AR 		(UL(1) << 14)
 #define ESR_ELx_CM 		(UL(1) << 8)
 
+/* ISS field definitions for SError interrupt */
+#define ESR_ELx_AET_SHIFT	(10)
+#define ESR_ELx_AET		(UL(0x7) << ESR_ELx_AET_SHIFT)
+/* Uncontainable error */
+#define ESR_ELx_AET_UC		(UL(0) << ESR_ELx_AET_SHIFT)
+/* Unrecoverable error */
+#define ESR_ELx_AET_UEU		(UL(1) << ESR_ELx_AET_SHIFT)
+/* Restartable error */
+#define ESR_ELx_AET_UEO		(UL(2) << ESR_ELx_AET_SHIFT)
+/* Recoverable error */
+#define ESR_ELx_AET_UER		(UL(3) << ESR_ELx_AET_SHIFT)
+/* Corrected */
+#define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)
+
 /* ISS field definitions for exceptions taken in to Hyp */
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 26a64d0..d167ed3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -27,6 +27,7 @@
 #define ARM_EXCEPTION_IRQ	  0
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
+
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1a0c07e..c0da350 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -395,4 +395,10 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+enum {
+	KVM_SEI_SEV_RECOVERABLE = 1,
+	KVM_SEI_SEV_FATAL,
+	KVM_SEI_SEV_CORRECTED,
+};
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index e70cb61..73b45fb 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -57,6 +57,7 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 })
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr);
+int handle_guest_sei(unsigned int esr);
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a16..d546d55 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/system_misc.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -178,6 +179,61 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+/**
+ * kvm_handle_guest_sei - handles SError interrupt or asynchronous aborts
+ * @vcpu:	the VCPU pointer
+ *
+ * For RAS SError interrupt, if the AET is [ESR_ELx_AET_UEU] or
+ * [ESR_ELx_AET_UER], then let host user space do the recovery,
+ * otherwise, directly inject virtual SError to guest or panic.
+ */
+static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	unsigned int esr = kvm_vcpu_get_hsr(vcpu);
+	bool impdef_syndrome =  esr & ESR_ELx_ISV;	/* aka IDS */
+	unsigned int aet = esr & ESR_ELx_AET;
+
+	run->exit_reason = KVM_EXIT_EXCEPTION;
+	run->ex.exception = ARM_EXCEPTION_EL1_SERROR;
+
+	/*
+	 * In below three conditions, it will directly inject the
+	 * virtual SError:
+	 * 1. Not support RAS extension
+	 * 2. The Syndrome is IMPLEMENTATION DEFINED
+	 * 3. It is Uncategorized SEI
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN) || impdef_syndrome ||
+			((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
+		break;		/* continue processing the guest exit */
+	case ESR_ELx_AET_UEU:
+	case ESR_ELx_AET_UER:	/* The error has not been propagated */
+	/*
+	 * Only handle the guest SEI if the error has not been propagated
+	 */
+	if (!handle_guest_sei(kvm_vcpu_get_hsr(vcpu))) {
+		run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
+		return 0;
+	}
+	/* If SError handling is failed, continue run, panic */
+	default:
+		/*
+		 * Until now, the CPU supports RAS and SEI is fatal, or host
+		 * does not support to handle the SError.
+		 */
+		panic("This Asynchronous SError interrupt is dangerous, panic");
+	}
+
+	return 0;
+}
+
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -201,8 +257,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*vcpu_pc(vcpu) -= adj;
 		}
 
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu, run);
 	}
 
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
@@ -211,8 +266,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu, run);
 	case ARM_EXCEPTION_TRAP:
 		/*
 		 * See ARM ARM B1.14.1: "Hyp traps on instructions
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c98c1b3..dce7ab9 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -688,6 +688,22 @@ int handle_guest_sea(phys_addr_t addr, unsigned int esr)
 }
 
 /*
+ * Handle SError interrupt that occurred in guest OS.
+ *
+ * The return value will be zero if the SEI was successfully handled
+ * and non-zero if handling is failed.
+ */
+int handle_guest_sei(unsigned int esr)
+{
+	int ret = -ENOENT;
+
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI))
+		ret = ghes_notify_abort(ACPI_HEST_NOTIFY_SEI);
+
+	return ret;
+}
+
+/*
  * Dispatch a data abort to the relevant handler.
  */
 asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
-- 
2.10.1
