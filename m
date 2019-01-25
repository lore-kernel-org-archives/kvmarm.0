From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption and
 vcpu state loaded
Date: Fri, 25 Jan 2019 10:46:52 +0100
Message-ID: <20190125094656.5026-2-christoffer.dall@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 048D34A3CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BB2EfixDyLyo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 04:47:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94EAD4A3A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:03 -0500 (EST)
In-Reply-To: <20190125094656.5026-1-christoffer.dall@arm.com>
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

Resetting the VCPU state modifies the system register state in memory,
but this may interact with vcpu_load/vcpu_put if running with preemption
disabled, which in turn may lead to corrupted system register state.

Address this by disabling preemption and doing put/load if required
around the reset logic.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/reset.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b72a3dd56204..f21a2a575939 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -105,16 +105,33 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  * This function finds the right table above and sets the registers on
  * the virtual CPU struct to their architecturally defined reset
  * values.
+ *
+ * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
+ * ioctl or as part of handling a request issued by another VCPU in the PSCI
+ * handling code.  In the first case, the VCPU will not be loaded, and in the
+ * second case the VCPU will be loaded.  Because this function operates purely
+ * on the memory-backed valus of system registers, we want to do a full put if
+ * we were loaded (handling a request) and load the values back at the end of
+ * the function.  Otherwise we leave the state alone.  In both cases, we
+ * disable preemption around the vcpu reset as we would otherwise race with
+ * preempt notifiers which also call put/load.
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	const struct kvm_regs *cpu_reset;
+	int ret = -EINVAL;
+	bool loaded;
+
+	preempt_disable();
+	loaded = (vcpu->cpu != -1);
+	if (loaded)
+		kvm_arch_vcpu_put(vcpu);
 
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
 			if (!cpu_has_32bit_el1())
-				return -EINVAL;
+				goto out;
 			cpu_reset = &default_regs_reset32;
 		} else {
 			cpu_reset = &default_regs_reset;
@@ -137,7 +154,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
 
 	/* Reset timer */
-	return kvm_timer_vcpu_reset(vcpu);
+	ret = kvm_timer_vcpu_reset(vcpu);
+out:
+	if (loaded)
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+	return ret;
 }
 
 void kvm_set_ipa_limit(void)
-- 
2.18.0
