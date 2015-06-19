From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/12] arm/arm64: KVM: Properly account for guest CPU time
Date: Fri, 19 Jun 2015 13:53:09 +0100
Message-ID: <1434718396-13110-6-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E22561C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qk07XZTc8XDe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:43:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36FF9561D4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:04 -0400 (EDT)
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Until now we have been calling kvm_guest_exit after re-enabling
interrupts when we come back from the guest, but this has the
unfortunate effect that CPU time accounting done in the context of timer
interrupts occurring while the guest is running doesn't properly notice
that the time since the last tick was spent in the guest.

Inspired by the comment in the x86 code, move the kvm_guest_exit() call
below the local_irq_enable() call and change __kvm_guest_exit() to
kvm_guest_exit(), because we are now calling this function with
interrupts enabled.  We have to now explicitly disable preemption and
not enable preemption before we've called kvm_guest_exit(), since
otherwise we could be preempted and everything happening before we
eventually get scheduled again would be accounted for as guest time.

At the same time, move the trace_kvm_exit() call outside of the atomic
section, since there is no reason for us to do that with interrupts
disabled.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 7e82330..bc738d2 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -531,6 +531,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_vgic_flush_hwstate(vcpu);
 		kvm_timer_flush_hwstate(vcpu);
 
+		preempt_disable();
 		local_irq_disable();
 
 		/*
@@ -543,6 +544,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
 			local_irq_enable();
+			preempt_enable();
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			continue;
@@ -558,8 +560,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
-		__kvm_guest_exit();
-		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		/*
+		 * Back from guest
+		 *************************************************************/
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -573,8 +577,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		local_irq_enable();
 
 		/*
-		 * Back from guest
-		 *************************************************************/
+		 * We do local_irq_enable() before calling kvm_guest_exit() so
+		 * that if a timer interrupt hits while running the guest we
+		 * account that tick as being spent in the guest.  We enable
+		 * preemption after calling kvm_guest_exit() so that if we get
+		 * preempted we make sure ticks after that is not counted as
+		 * guest time.
+		 */
+		kvm_guest_exit();
+		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		preempt_enable();
+
 
 		kvm_timer_sync_hwstate(vcpu);
 		kvm_vgic_sync_hwstate(vcpu);
-- 
2.1.4
