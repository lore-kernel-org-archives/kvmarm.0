From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 7/9] KVM: arm/arm64: Check if irq lines to the GIC are
 already used
Date: Thu,  8 Jun 2017 15:34:44 +0200
Message-ID: <20170608133446.3875-8-cdall@linaro.org>
References: <20170608133446.3875-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E954340C54
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q9SzWMhF-Nij for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 09:30:49 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8610940430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:48 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id x70so77671755wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jun 2017 06:34:58 -0700 (PDT)
In-Reply-To: <20170608133446.3875-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
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
index e03da1a..07f6f9b 100644
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
index 574feff..3f08669 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -480,6 +480,8 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		return -EBUSY;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
+		int ret;
+
 		/*
 		 * If using the PMU with an in-kernel virtual GIC
 		 * implementation, we require the GIC to be already
@@ -490,6 +492,11 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			return -ENXIO;
+
+		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
+					 &vcpu->arch.pmu);
+		if (ret)
+			return ret;
 	}
 
 	vcpu->arch.pmu.created = true;
-- 
2.9.0
