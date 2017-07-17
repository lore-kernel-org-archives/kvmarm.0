From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 09/19] KVM: arm/arm64: Move timer/vgic flush/sync under
 disabled irq
Date: Mon, 17 Jul 2017 16:27:08 +0200
Message-ID: <20170717142718.13853-10-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 958ED49C14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NiyZcaCh5zLV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:51 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BD1C49C30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:48 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id w126so77797442wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:34 -0700 (PDT)
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
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

As we are about to play tricks with the timer to be more lazy in saving
and restoring state, we need to move the timer sync and flush functions
under a disabled irq section and since we have to flush the vgic state
after the timer and PMU state, we do the whole flush/sync sequence with
disabled irqs.

The only downside is a slightly longer delay before being able to
process hardware interrupts and run softirqs.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arm.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e1..a49b19e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -649,11 +649,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		kvm_pmu_flush_hwstate(vcpu);
 
+		local_irq_disable();
+
 		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
-		local_irq_disable();
-
 		/*
 		 * If we have a singal pending, or need to notify a userspace
 		 * irqchip about timer or PMU level changes, then we exit (and
@@ -678,10 +678,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
-			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			local_irq_enable();
 			preempt_enable();
 			continue;
 		}
@@ -705,6 +705,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_arm_clear_debug(vcpu);
 
 		/*
+		 * We must sync the PMU and timer state before the vgic state so
+		 * that the vgic can properly sample the updated state of the
+		 * interrupt line.
+		 */
+		kvm_pmu_sync_hwstate(vcpu);
+		kvm_timer_sync_hwstate(vcpu);
+
+		kvm_vgic_sync_hwstate(vcpu);
+
+		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
 		 * pending, as we haven't serviced it yet!
@@ -727,16 +737,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
-		/*
-		 * We must sync the PMU and timer state before the vgic state so
-		 * that the vgic can properly sample the updated state of the
-		 * interrupt line.
-		 */
-		kvm_pmu_sync_hwstate(vcpu);
-		kvm_timer_sync_hwstate(vcpu);
-
-		kvm_vgic_sync_hwstate(vcpu);
-
 		preempt_enable();
 
 		ret = handle_exit(vcpu, run, ret);
-- 
2.9.0
