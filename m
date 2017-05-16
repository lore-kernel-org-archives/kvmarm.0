From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 7/9] KVM: arm/arm64: Check if irq lines to the GIC are
 already used
Date: Tue, 16 May 2017 20:45:54 +0200
Message-ID: <20170516184556.26785-8-cdall@linaro.org>
References: <20170516184556.26785-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 818DE40C46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 14:42:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YK-ykNlTSX9L for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 14:42:57 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DA0440C8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 14:42:55 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id d127so129521488wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 11:46:23 -0700 (PDT)
In-Reply-To: <20170516184556.26785-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We check if other in-kernel devices have already been connected to the
GIC for a particular interrupt line when possible.

For the PMU, we can do this whenever setting the PMU interrupt number
from userspace.

For the timers, we have to wait until we try to enable the timer,
because we have a concept of default IRQ numbers that userspace
shouldn't have to work around in the initialization phase.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 18 ++++++++++--------
 virt/kvm/arm/pmu.c        |  7 +++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d3d1dce..528acf0 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -618,20 +618,22 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-static bool timer_irqs_are_valid(struct kvm *kvm)
+static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
 	int vtimer_irq, ptimer_irq;
-	int i;
+	int i, ret;
 
-	vcpu = kvm_get_vcpu(kvm, 0);
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
-	ptimer_irq = vcpu_ptimer(vcpu)->irq.irq;
+	ret = kvm_vgic_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
+	if (ret)
+		return false;
 
-	if (vtimer_irq == ptimer_irq)
+	ptimer_irq = vcpu_ptimer(vcpu)->irq.irq;
+	ret = kvm_vgic_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
+	if (ret)
 		return false;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, vcpu->kvm) {
 		if (vcpu_vtimer(vcpu)->irq.irq != vtimer_irq ||
 		    vcpu_ptimer(vcpu)->irq.irq != ptimer_irq)
 			return false;
@@ -659,7 +661,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (!vgic_initialized(vcpu->kvm))
 		return -ENODEV;
 
-	if (!timer_irqs_are_valid(vcpu->kvm)) {
+	if (!timer_irqs_are_valid(vcpu)) {
 		kvm_debug("incorrectly configured timer irqs\n");
 		return -EINVAL;
 	}
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 0cf62b7..c354bd5 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -463,6 +463,8 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		return -EBUSY;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
+		int ret;
+
 		/*
 		 * If using the PMU with an in-kernel virtual GIC
 		 * implementation, we require the GIC to be already
@@ -473,6 +475,11 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			return -ENXIO;
+
+		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
+					 &vcpu->arch.pmu);
+		if (ret)
+			return ret;
 	}
 
 	kvm_pmu_vcpu_reset(vcpu);
-- 
2.9.0
