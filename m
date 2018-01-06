From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v9 7/7] arm64: kvm: handle guest SError Interrupt by
 categorization
Date: Sun, 7 Jan 2018 00:02:57 +0800
Message-ID: <1515254577-6460-8-git-send-email-gengdongjiu@huawei.com>
References: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFF2349D40
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1MABwtLFICst for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Jan 2018 02:53:38 -0500 (EST)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD6D49DCA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:37 -0500 (EST)
In-Reply-To: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, james.morse@arm.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: huangshaoyu@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

If it is not RAS SError, directly inject virtual SError,
which will keep the old way, otherwise firstly let host
ACPI kernel driver to handle it. If the ACPI handling is
failed, KVM continues categorizing errors by the ESR_ELx.

For the recoverable error (UER), it has not been silently
propagated and has not (yet) been architecturally consumed
by the PE, the exception is precise. In order to make it
simple, we temporarily shut down the VM to isolate the error.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
change since v8:
1. Check handle_guest_sei()'s return value
2. Temporarily shut down the VM to isolate the error for the
   recoverable error (UER) 
3. Remove some unused macro definitions
---
 arch/arm64/include/asm/esr.h         | 11 ++++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kvm/handle_exit.c         | 68 +++++++++++++++++++++++++++++++++---
 arch/arm64/mm/fault.c                | 16 +++++++++
 4 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 66ed8b6..a751e86 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -102,6 +102,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_SERROR	(0x11)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV_SHIFT	(24)
@@ -119,6 +120,16 @@
 #define ESR_ELx_CM_SHIFT	(8)
 #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
 
+/* ISS field definitions for SError interrupt */
+#define ESR_ELx_AET_SHIFT	(10)
+#define ESR_ELx_AET		(UL(0x7) << ESR_ELx_AET_SHIFT)
+/* Restartable error */
+#define ESR_ELx_AET_UEO		(UL(2) << ESR_ELx_AET_SHIFT)
+/* Recoverable error */
+#define ESR_ELx_AET_UER		(UL(3) << ESR_ELx_AET_SHIFT)
+/* Corrected error */
+#define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)
+
 /* ISS field definitions for exceptions taken in to Hyp */
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
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
index 7debb74..5b806d4 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/system_misc.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -178,6 +179,67 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[hsr_ec];
 }
 
+/**
+ * kvm_handle_guest_sei - handles SError interrupt or asynchronous aborts
+ * @vcpu:	the VCPU pointer
+ * @run:        access to the kvm_run structure for results
+ *
+ * For RAS SError interrupt, firstly let host kernel handle it. If handling
+ * failed, then categorize the error by the ESR
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
+	/* For RAS the host kernel may handle this abort. */
+	if (!handle_guest_sei())
+		return 1;
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
+	case ESR_ELx_AET_UER:	/* recoverable error */
+		/*
+		 * the exception is precise, not been silently propagated
+		 * and not been consumed by the CPU, temporarily shut down
+		 * the VM to isolated the error, hope not touch it again.
+		 */
+		run->exit_reason = KVM_EXIT_EXCEPTION;
+		return 0;
+	default:
+		/*
+		 * Until now, the CPU supports RAS, SError interrupt is fatal
+		 * and host does not successfully handle it.
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
@@ -201,8 +263,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*vcpu_pc(vcpu) -= adj;
 		}
 
-		kvm_inject_vabt(vcpu);
-		return 1;
+		return kvm_handle_guest_sei(vcpu, run);
 	}
 
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
@@ -211,8 +272,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
