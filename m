From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 08/26] KVM: arm/arm64: Move timer/vgic flush/sync under
 disabled irq
Date: Tue,  7 Nov 2017 11:47:41 +0100
Message-ID: <20171107104800.30021-9-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB19F49D74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BI2BalF09eNS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:29 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ADBB49D77
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:27 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id r196so2842384wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:22 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
