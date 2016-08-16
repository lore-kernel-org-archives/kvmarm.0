From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 7/7] arm64: KVM: Enable selective trapping of TLB instructions
Date: Tue, 16 Aug 2016 11:45:12 +0100
Message-ID: <1471344312-26685-8-git-send-email-punit.agrawal@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Punit Agrawal <punit.agrawal@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The TTLB bit of Hypervisor Control Register (HCR_EL2) controls the
trapping of guest TLB maintenance instructions. Taking the trap requires
a switch to the hypervisor and is an expensive operation.

Enable selective trapping of guest TLB instructions when the associated
perf trace event is enabled for a specific virtual machine.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/perf_trace.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/kvm/perf_trace.c b/arch/arm64/kvm/perf_trace.c
index 8bacd18..f26da1d 100644
--- a/arch/arm64/kvm/perf_trace.c
+++ b/arch/arm64/kvm/perf_trace.c
@@ -17,6 +17,8 @@
 #include <linux/kvm_host.h>
 #include <linux/trace_events.h>
 
+#include <asm/kvm_emulate.h>
+
 typedef int (*perf_trace_callback_fn)(struct kvm *kvm, bool enable);
 
 struct kvm_trace_hook {
@@ -24,7 +26,37 @@ struct kvm_trace_hook {
 	perf_trace_callback_fn setup_fn;
 };
 
+static int tlb_invalidate_trap(struct kvm *kvm, bool enable)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	/*
+	 * Halt the VM to ensure atomic update across all vcpus (this
+	 * avoids racy behaviour against other modifications of
+	 * HCR_EL2 such as kvm_toggle_cache/kvm_set_way_flush).
+	 */
+	kvm_arm_halt_guest(kvm);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		unsigned long hcr = vcpu_get_hcr(vcpu);
+
+		if (enable)
+			hcr |= HCR_TTLB;
+		else
+			hcr &= ~HCR_TTLB;
+
+		vcpu_set_hcr(vcpu, hcr);
+	}
+	kvm_arm_resume_guest(kvm);
+
+	return 0;
+}
+
 static struct kvm_trace_hook trace_hook[] = {
+	{
+		.key = "kvm_tlb_invalidate",
+		.setup_fn = tlb_invalidate_trap,
+	},
 	{ },
 };
 
-- 
2.8.1
