From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] arm/arm64: KVM: Propertly account for guest CPU time
Date: Thu, 28 May 2015 14:49:09 +0200
Message-ID: <1432817349-17917-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3263452188
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2015 08:38:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BezpCAtDi6ZM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2015 08:38:57 -0400 (EDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
 [209.85.217.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 092DE520F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2015 08:38:56 -0400 (EDT)
Received: by lbcue7 with SMTP id ue7so27451440lbc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2015 05:48:40 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Until now we have been calling kvm_guest_exit after re-enabling
interrupts when we come back from the guest, but this has the
unfortunate effect that CPU time accounting done in the context of timer
interrupts doesn't properly notice that the time since the last tick was
spent in the guest.

Inspired by the comment in the x86 code, simply move the
kvm_guest_exit() call below the local_irq_enable() call and change
__kvm_guest_exit() to kvm_guest_exit(), because we are now calling this
function with interrupts enabled.  Note that AFAIU we don't need an
explicit barrier like x86 because the arm/arm64 implementation of
local_irq_(en/dis)able has an implicit barrier.

At the same time, move the trace_kvm_exit() call outside of the atomic
section, since there is no reason for us to do that with interrupts
disabled.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
This patch is based on kvm/queue, because it has the kvm_guest_enter/exit
rework recently posted by Christian Borntraeger.  I hope I got the logic
of this wrong, there were 2 slightly worrying facts about this:

First, we now enable and disable and enable interrupts on each exit
path, but I couldn't see any performance overhead on hackbench - yes the
only benchmark we care abotu.

Second, looking at the power and mips code, they seem to also call
kvm_guest_exit() before enabling interrupts, so I don't understand how
guest CPU time accounting works on those architectures.

 arch/arm/kvm/arm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e41cb11..bd0e463 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -559,8 +559,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -574,8 +576,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		local_irq_enable();
 
 		/*
-		 * Back from guest
-		 *************************************************************/
+		 * We do local_irq_enable() before calling kvm_guest_exit so
+		 * that the cputime accounting done in the context of timer
+		 * interrupts properly accounts time spent in the guest as
+		 * guest time.
+		 */
+		kvm_guest_exit();
+		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+
 
 		kvm_timer_sync_hwstate(vcpu);
 		kvm_vgic_sync_hwstate(vcpu);
-- 
2.1.2.330.g565301e.dirty
