From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 11/13] KVM: arm64: Handle RAS SErrors from EL1 on guest exit
Date: Fri, 15 Dec 2017 15:50:59 +0000
Message-ID: <20171215155101.23505-12-james.morse@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6E249D82
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:50:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8stuQFBRFki for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 10:50:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2E740651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:50:16 -0500 (EST)
In-Reply-To: <20171215155101.23505-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We expect to have firmware-first handling of RAS SErrors, with errors
notified via an APEI method. For systems without firmware-first, add
some minimal handling to KVM.

There are two ways KVM can take an SError due to a guest, either may be a
RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.

For SError that interrupt a guest and are routed to EL2 the existing
behaviour is to inject an impdef SError into the guest.

Add code to handle RAS SError based on the ESR. For uncontained and
uncategorized errors arm64_is_fatal_ras_serror() will panic(), these
errors compromise the host too. All other error types are contained:
For the fatal errors the vCPU can't make progress, so we inject a virtual
SError. We ignore contained errors where we can make progress as if
we're lucky, we may not hit them again.

If only some of the CPUs support RAS the guest will see the cpufeature
sanitised version of the id registers, but we may still take RAS SError
on this CPU. Move the SError handling out of handle_exit() into a new
handler that runs before we can be preempted. This allows us to use
this_cpu_has_cap(), via arm64_is_ras_serror().

Signed-off-by: James Morse <james.morse@arm.com>
---
Changes since v4:
 * Moved SError handling into handle_exit_early(). This will need to move
   earlier, into an SError-masked region once we support kernel-first.
   (hence the vauge name)
 * Dropped Marc & Christoffer's Reviewed-by due to handle_exit_early().

 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/handle_exit.c      | 18 +++++++++++++++++-
 virt/kvm/arm/arm.c                |  3 +++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index b86fc4162539..acbf9ec7b396 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -238,6 +238,9 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
 
+static inline void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				     int exception_index) {}
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9391a076de58..34f1c4e88c98 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -345,6 +345,8 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
+void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		       int exception_index);
 
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 304203fa9e33..6a5a5db4292f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -29,12 +29,19 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
 #include <asm/debug-monitors.h>
+#include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
 
+static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u32 esr)
+{
+	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(NULL, esr))
+		kvm_inject_vabt(vcpu);
+}
+
 static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
@@ -252,7 +259,6 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
 		/* We may still need to return for single-step */
 		if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
 			&& kvm_arm_handle_step_debug(vcpu, run))
@@ -275,3 +281,13 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return 0;
 	}
 }
+
+/* For exit types that need handling before we can be preempted */
+void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		       int exception_index)
+{
+	exception_index = ARM_EXCEPTION_CODE(exception_index);
+
+	if (exception_index == ARM_EXCEPTION_EL1_SERROR)
+		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_hsr(vcpu));
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86059a478a0a..a11040be0443 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -763,6 +763,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
+		/* Exit types that need handling before we can be preempted */
+		handle_exit_early(vcpu, run, ret);
+
 		preempt_enable();
 
 		ret = handle_exit(vcpu, run, ret);
-- 
2.15.0
