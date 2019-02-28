From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 08/13] arm64: KVM/debug: drop pmscr_el1 and use
 sys_regs[PMSCR_EL1] in kvm_cpu_context
Date: Thu, 28 Feb 2019 16:07:30 +0000
Message-ID: <20190228160737.3323-9-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52DD04A479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KkjL79zqjEnC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:14 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E41B4A471
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:14 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_cpu_context now has support to stash the complete SPE buffer control
context. We no longer need the pmscr_el1 kvm_vcpu_arch and it can be
dropped.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/hyp/debug-sr.c     | 26 +++++++++++++++-----------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d113b8271a75..9a5b90dc8962 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -272,8 +272,6 @@ struct kvm_vcpu_arch {
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
 	} host_debug_state;
 
 	/* VGIC state */
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 618884df1dc4..a2714a5eb3e9 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -66,19 +66,19 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
+static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
 	u64 reg;
 
 	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
+	ctxt->sys_regs[PMSCR_EL1] = 0;
 
 	/* SPE present on this CPU? */
 	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
 						  ID_AA64DFR0_PMSVER_SHIFT))
 		return;
 
-	/* Yes; is it owned by EL3? */
+	/* Yes; is it owned by higher EL? */
 	reg = read_sysreg_s(SYS_PMBIDR_EL1);
 	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
 		return;
@@ -89,7 +89,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_el1_s(SYS_PMSCR);
+	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1_s(SYS_PMSCR);
 	write_sysreg_el1_s(0, SYS_PMSCR);
 	isb();
 
@@ -98,16 +98,16 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
+static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
-	if (!pmscr_el1)
+	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
 
 	/* The host page table is installed, but not yet synchronised */
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_el1_s(pmscr_el1, SYS_PMSCR);
+	write_sysreg_el1_s(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
@@ -175,14 +175,15 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
 	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_restore_spe_nvhe(host_ctxt);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
@@ -198,8 +199,11 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
 	 * Non-VHE: Disable and flush SPE data generation
 	 * VHE: The vcpu can run, but it can't hide.
 	 */
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_save_spe_nvhe(host_ctxt);
 }
 
 void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
-- 
2.17.1
