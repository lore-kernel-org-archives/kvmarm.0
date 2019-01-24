From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 05/14] arm/arm64: KVM: Statically configure the host's view of
 MPIDR
Date: Thu, 24 Jan 2019 15:00:23 +0100
Message-ID: <20190124140032.8588-6-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901B94A3D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h8z3fzEQeigr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7614A3D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:49 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We currently eagerly save/restore MPIDR. It turns out to be
slightly pointless:
- On the host, this value is known as soon as we're scheduled on a
  physical CPU
- In the guest, this value cannot change, as it is set by KVM
  (and this is a read-only register)

The result of the above is that we can perfectly avoid the eager
saving of MPIDR_EL1, and only keep the restore. We just have
to setup the host contexts appropriately at boot time.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 8 ++++++++
 arch/arm/kvm/hyp/cp15-sr.c        | 1 -
 arch/arm64/include/asm/kvm_host.h | 8 ++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c    | 1 -
 virt/kvm/arm/arm.c                | 1 +
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4b6193f2f0f6..43e343e00fb8 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 #include <asm/fpstate.h>
+#include <asm/smp_plat.h>
 #include <kvm/arm_arch_timer.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -147,6 +148,13 @@ struct kvm_cpu_context {
 
 typedef struct kvm_cpu_context kvm_cpu_context_t;
 
+static inline void kvm_init_host_cpu_context(kvm_cpu_context_t *cpu_ctxt,
+					     int cpu)
+{
+	/* The host's MPIDR is immutable, so let's set it up at boot time */
+	cpu_ctxt->cp15[c0_MPIDR] = cpu_logical_map(cpu);
+}
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
diff --git a/arch/arm/kvm/hyp/cp15-sr.c b/arch/arm/kvm/hyp/cp15-sr.c
index c4782812714c..8bf895ec6e04 100644
--- a/arch/arm/kvm/hyp/cp15-sr.c
+++ b/arch/arm/kvm/hyp/cp15-sr.c
@@ -27,7 +27,6 @@ static u64 *cp15_64(struct kvm_cpu_context *ctxt, int idx)
 
 void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->cp15[c0_MPIDR]		= read_sysreg(VMPIDR);
 	ctxt->cp15[c0_CSSELR]		= read_sysreg(CSSELR);
 	ctxt->cp15[c1_SCTLR]		= read_sysreg(SCTLR);
 	ctxt->cp15[c1_CPACR]		= read_sysreg(CPACR);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b7702bdb219..f497bb31031f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/smp_plat.h>
 #include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -418,6 +419,13 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 
+static inline void kvm_init_host_cpu_context(kvm_cpu_context_t *cpu_ctxt,
+					     int cpu)
+{
+	/* The host's MPIDR is immutable, so let's set it up at boot time */
+	cpu_ctxt->sys_regs[MPIDR_EL1] = cpu_logical_map(cpu);
+}
+
 void __kvm_enable_ssbs(void);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 68d6f7c3b237..2498f86defcb 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -52,7 +52,6 @@ static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 
 static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
 	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4d55f98f97f7..3dd240ea9e76 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1561,6 +1561,7 @@ static int init_hyp_mode(void)
 		kvm_cpu_context_t *cpu_ctxt;
 
 		cpu_ctxt = per_cpu_ptr(&kvm_host_cpu_state, cpu);
+		kvm_init_host_cpu_context(cpu_ctxt, cpu);
 		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
-- 
2.18.0
