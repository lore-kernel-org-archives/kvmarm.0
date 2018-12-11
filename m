From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v7 5/5] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Tue, 11 Dec 2018 12:13:40 +0000
Message-ID: <1544530420-1477-6-git-send-email-andrew.murray@arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 503C24A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jiXROCc8n-9p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 07:14:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 614234A36A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:16 -0500 (EST)
In-Reply-To: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
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
---
 arch/arm64/kvm/hyp/switch.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d496ef5..bad713f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -373,6 +373,46 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+	u32 clr, set;
+
+	host = container_of(host_ctxt, struct kvm_host_data, __kvm_cpu_state);
+	pmu = &host->pmu_events;
+
+	clr = pmu->events_host & ~pmu->events_guest;
+	set = pmu->events_guest & ~pmu->events_host;
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
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+	u32 clr, set;
+
+	host = container_of(host_ctxt, struct kvm_host_data, __kvm_cpu_state);
+	pmu = &host->pmu_events;
+
+	clr = pmu->events_guest & ~pmu->events_host;
+	set = pmu->events_host & ~pmu->events_guest;
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
@@ -488,12 +528,15 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
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
@@ -524,6 +567,9 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__debug_switch_to_host(vcpu);
 
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
 	return exit_code;
 }
 
@@ -532,6 +578,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
+	bool pmu_switch_needed;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -540,6 +587,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
+	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+
 	__sysreg_save_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
@@ -586,6 +635,9 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 */
 	__debug_switch_to_host(vcpu);
 
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
 	return exit_code;
 }
 
-- 
2.7.4
