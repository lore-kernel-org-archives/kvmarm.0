From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v6 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Mon, 10 Dec 2018 09:45:59 +0000
Message-ID: <1544435159-54781-5-git-send-email-andrew.murray@arm.com>
References: <1544435159-54781-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 970444A32B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 04:46:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XmmeZccWH8Kw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 04:46:28 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DE6E4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 04:46:28 -0500 (EST)
In-Reply-To: <1544435159-54781-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Enable/disable event counters as appropriate when entering and exiting
the guest to enable support for guest or host only event counting.

For both VHE and non-VHE we switch the counters between host/guest at
EL2. EL2 is filtered out by the PMU when we are using the :G modifier.

The PMU may be on when we change which counters are enabled however
we avoid adding an isb as we instead rely on existing context
synchronisation events: the isb in kvm_arm_vhe_guest_exit for VHE and
the eret from the hvc in kvm_call_hyp.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d496ef5..e505cad 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -373,6 +373,32 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+{
+	u32 clr = host_ctxt->events_host & ~host_ctxt->events_guest;
+	u32 set = host_ctxt->events_guest & ~host_ctxt->events_host;
+
+	if (clr)
+		write_sysreg(clr, pmcntenclr_el0);
+
+	if (set)
+		write_sysreg(set, pmcntenset_el0);
+
+	return (clr || set);
+}
+
+static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+{
+	u32 clr = host_ctxt->events_guest & ~host_ctxt->events_host;
+	u32 set = host_ctxt->events_host & ~host_ctxt->events_guest;
+
+	if (clr)
+		write_sysreg(clr, pmcntenclr_el0);
+
+	if (set)
+		write_sysreg(set, pmcntenset_el0);
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -488,12 +514,15 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
+	bool pmu_switch_needed;
 	u64 exit_code;
 
 	host_ctxt = vcpu->arch.host_cpu_context;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
+	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+
 	sysreg_save_host_state_vhe(host_ctxt);
 
 	__activate_traps(vcpu);
@@ -524,6 +553,9 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__debug_switch_to_host(vcpu);
 
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
 	return exit_code;
 }
 
@@ -532,6 +564,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
+	bool pmu_switch_needed;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -540,6 +573,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
+	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+
 	__sysreg_save_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
@@ -586,6 +621,9 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 */
 	__debug_switch_to_host(vcpu);
 
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
 	return exit_code;
 }
 
-- 
2.7.4
