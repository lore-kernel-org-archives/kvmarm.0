From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH 4/4] arm64: KVM: Enable support for :G/:H perf event modifiers
Date: Thu, 15 Nov 2018 12:55:49 +0000
Message-ID: <1542286549-4501-5-git-send-email-andrew.murray@arm.com>
References: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Enable/disable event counters as appropriate when entering and exiting
the guest to enable support for guest or host only event counting.

For both VHE and non-VHE we switch the counters between host/guest at
EL2. EL2 is filtered out by the PMU when we are using the :G modifier.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d496ef5..ebf0aac 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -373,6 +373,32 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+{
+	u32 host_only = host_ctxt->events_host_only;
+	u32 guest_only = host_ctxt->events_guest_only;
+
+	if (host_only)
+		write_sysreg(host_only, pmcntenclr_el0);
+
+	if (guest_only)
+		write_sysreg(guest_only, pmcntenset_el0);
+
+	return (host_only || guest_only);
+}
+
+static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+{
+	u32 host_only = host_ctxt->events_host_only;
+	u32 guest_only = host_ctxt->events_guest_only;
+
+	if (guest_only)
+		write_sysreg(guest_only, pmcntenclr_el0);
+
+	if (host_only)
+		write_sysreg(host_only, pmcntenset_el0);
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
