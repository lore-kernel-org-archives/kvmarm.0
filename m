From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by categorization
Date: Sat, 11 Nov 2017 03:54:10 +0800
Message-ID: <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, james.morse@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

If it is not RAS SError, directly inject virtual SError,
which will keep the old way. If it is RAS SError, firstly
let host ACPI module to handle it. For the ACPI handling,
if the error address is invalid, APEI driver will not
identify the address to hwpoison memory and can not notify
guest to do the recovery. In order to safe, KVM continues
categorizing errors and handle it separately.

If the RAS error is not propagated, let host user space to
handle it. The reason is that sometimes we can only kill the
guest effected application instead of panic whose guest OS.
Host user space specifies a valid ESR and inject virtual
SError, guest can just kill the current application if the
non-consumed error coming from guest application.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
---
 arch/arm64/include/asm/esr.h         | 15 ++++++++
 arch/arm64/include/asm/kvm_asm.h     |  3 ++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kvm/handle_exit.c         | 67 +++++++++++++++++++++++++++++++++---
 arch/arm64/mm/fault.c                | 16 +++++++++
 5 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 66ed8b6..aca7eee 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -102,6 +102,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_SERROR	(0x11)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV_SHIFT	(24)
@@ -119,6 +120,20 @@
 #define ESR_ELx_CM_SHIFT	(8)
 #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
 
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
index 26a64d0..884f723 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -27,6 +27,9 @@
 #define ARM_EXCEPTION_IRQ	  0
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
+/* Error code for SError Interrupt (SEI) exception */
+#define KVM_SEI_SEV_RECOVERABLE	  1
+
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 07aa8e3..9ee13ad 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -57,6 +57,7 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 })
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr);
+int handle_guest_sei(void);
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 7debb74..1afdc87 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/system_misc.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -178,6 +179,66 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+/**
+ * kvm_handle_guest_sei - handles SError interrupt or asynchronous aborts
+ * @vcpu:	the VCPU pointer
+ *
+ * For RAS SError interrupt, firstly let host kernel handle it.
+ * If the AET is [ESR_ELx_AET_UER], then let user space handle it,
+ */
+static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	unsigned int esr = kvm_vcpu_get_hsr(vcpu);
+	bool impdef_syndrome =  esr & ESR_ELx_ISV;	/* aka IDS */
+	unsigned int aet = esr & ESR_ELx_AET;
+
+	/*
+	 * This is not RAS SError
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	/* The host kernel may handle this abort. */
+	handle_guest_sei();
+
+	/*
+	 * In below two conditions, it will directly inject the
+	 * virtual SError:
+	 * 1. The Syndrome is IMPLEMENTATION DEFINED
+	 * 2. It is Uncategorized SEI
+	 */
+	if (impdef_syndrome ||
+		((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
+		return 1;	/* continue processing the guest exit */
+	case ESR_ELx_AET_UER:	/* The error has not been propagated */
+		/*
+		 * Userspace only handle the guest SError Interrupt(SEI) if the
+		 * error has not been propagated
+		 */
+		run->exit_reason = KVM_EXIT_EXCEPTION;
+		run->ex.exception = ESR_ELx_EC_SERROR;
+		run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
+		return 0;
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
@@ -201,8 +262,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*vcpu_pc(vcpu) -= adj;
 		}
 
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu, run);
 	}
 
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
@@ -211,8 +271,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
index b64958b..8560672 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -728,6 +728,22 @@ int handle_guest_sea(phys_addr_t addr, unsigned int esr)
 }
 
 /*
+ * Handle SError interrupt that occurred in guest OS.
+ *
+ * The return value will be zero if the SEI was successfully handled
+ * and non-zero if handling is failed.
+ */
+int handle_guest_sei(void)
+{
+	int ret = -ENOENT;
+
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI))
+		ret = ghes_notify_sei();
+
+	return ret;
+}
+
+/*
  * Dispatch a data abort to the relevant handler.
  */
 asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
-- 
1.9.1
