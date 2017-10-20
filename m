From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 09/20] KVM: arm/arm64: Move timer/vgic flush/sync under disabled irq
Date: Fri, 20 Oct 2017 13:49:28 +0200
Message-ID: <20171020114939.12554-10-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

As we are about to play tricks with the timer to be more lazy in saving
and restoring state, we need to move the timer sync and flush functions
under a disabled irq section and since we have to flush the vgic state
after the timer and PMU state, we do the whole flush/sync sequence with
disabled irqs.

The only downside is a slightly longer delay before being able to
process hardware interrupts and run softirqs.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arm.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..27db222a0c8d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -654,11 +654,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
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
@@ -683,10 +683,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -709,6 +709,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		kvm_arm_clear_debug(vcpu);
 
+		/*
+		 * We must sync the PMU and timer state before the vgic state so
+		 * that the vgic can properly sample the updated state of the
+		 * interrupt line.
+		 */
+		kvm_pmu_sync_hwstate(vcpu);
+		kvm_timer_sync_hwstate(vcpu);
+
+		kvm_vgic_sync_hwstate(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -732,16 +742,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
2.14.2
